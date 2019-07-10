import 'package:flutter/material.dart';
import 'package:twic_app/api/models/models.dart';
import 'package:twic_app/style/style.dart';
import 'package:twic_app/api/session.dart';
import 'package:intl/intl.dart';
import 'package:flutter/scheduler.dart';
import 'package:twic_app/shared/components/round_picture.dart';
import 'package:twic_app/shared/components/infinite_scroll.dart';

class MessageList extends StatefulWidget {
  List<Message> list;
  final Function fetch;

  MessageList({this.fetch, this.list, Key key})
      : super(key: key);

  @override
  MessageListState createState() => MessageListState();
}

class MessageListState extends State<MessageList> {
  final ScrollController _scrollController = ScrollController();
  bool _isBottom = true;

  void _scrollBottom() {
    if (_isBottom) {
      _scrollController.animateTo(
        0,
        duration: const Duration(milliseconds: 1000),
        curve: Curves.easeOut,
      );
    }
  }

  String _renderDate(DateTime date) {
    DateTime now = DateTime.now();
    if (now.year == date.year &&
        now.month == date.month &&
        now.day == date.day) {
      return "Today ${date.hour.toString().padLeft(2, '0')}:${date.minute.toString().padLeft(2, '0')}";
    }
    return DateFormat.yMMMd().format(date);
  }

  @override
  Widget build(BuildContext context) {
    print(["MESSAGELIST", widget.key, widget.list.length]);
    Size mediaSize = MediaQuery.of(context).size;
    SchedulerBinding.instance.addPostFrameCallback((_) {
      _scrollBottom();
    });
    return Container(
        width: mediaSize.width,
        child: InfiniteScroll(
          fetch: widget.fetch,
          reverse: true,
          shrink: false,
          builder: (BuildContext context, int index) => Padding(
              padding: EdgeInsets.only(bottom: 10, top: index == 0 ? 10 : 0),
              child: Column(
                crossAxisAlignment:
                    widget.list[index].user.id == Session.instance.user.id
                        ? CrossAxisAlignment.end
                        : CrossAxisAlignment.start,
                children: <Widget>[
                  index == 0
                      ? SizedBox(
                          height: 10,
                        )
                      : Container(),
                  Row(children: [
                    widget.list[index].user.id == Session.instance.user.id
                        ? Expanded(child: Container())
                        : Container(
                            width: 15,
                          ),
                    SizedBox(
                      width: 10.0,
                    ),
                    index == 0 ||
                            (widget.list[index].createdAt
                                        .difference(
                                            widget.list[index - 1].createdAt)
                                        .inMinutes >
                                    5 &&
                                _renderDate(widget.list[index].createdAt) !=
                                    _renderDate(
                                        widget.list[index - 1].createdAt))
                        ? Padding(
                            padding: EdgeInsets.only(bottom: 5, right: 20),
                            child: Text(
                                _renderDate(widget.list[index].createdAt),
                                style: Style.lightText))
                        : Container(),
                  ]),
                  Row(children: [
                    widget.list[index].user.id == Session.instance.user.id
                        ? Expanded(child: Container())
                        : SizedBox(width: 25.0),
                    widget.list[index].user.id == Session.instance.user.id
                        ? Padding(
                            padding: EdgeInsets.only(right: 20),
                            child: Container(
                              width: mediaSize.width * 0.55,
                              padding: null != widget.list[index].text
                                  ? EdgeInsets.only(
                                      left: 10.0,
                                      right: 10.0,
                                      top: 5.0,
                                      bottom: 5.0)
                                  : EdgeInsets.all(0),
                              decoration: BoxDecoration(
                                  color: null != widget.list[index].text
                                      ? Style.mainColor
                                      : Colors.transparent,
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(8.0))),
                              child: null != widget.list[index].text
                                  ? Text(
                                      widget.list[index].text,
                                      style: Style.whiteText,
                                      textAlign: TextAlign.start,
                                    )
                                  : RoundPicture(
                                      picture:
                                          widget.list[index].attachment.href(),
                                    ),
                            ))
                        : Container(
                            width: mediaSize.width * 0.55,
                            padding: EdgeInsets.only(
                                left: 10.0, right: 10.0, top: 5.0, bottom: 5.0),
                            decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius:
                                    BorderRadius.all(Radius.circular(8.0))),
                            child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    widget.list[index].user.firstname,
                                    style: Style.get(
                                        fontSize: 12, color: Style.genZOrange),
                                    textAlign: TextAlign.start,
                                  ),
                                  SizedBox(
                                    height: 3,
                                  ),
                                  null != widget.list[index].text
                                      ? Text(
                                          widget.list[index].text,
                                          style: Style.text,
                                          textAlign: TextAlign.start,
                                        )
                                      : RoundPicture(
                                          picture: widget.list[index].attachment
                                              .href(),
                                        ),
                                ]))
                  ]),
                ],
              )),
          count: widget.list.length,
          scroll: _scrollController,
          onScroll: () {
            _isBottom = _scrollController.position.pixels < 100;
          },
        ));
  }
}
