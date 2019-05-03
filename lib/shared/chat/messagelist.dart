import 'package:flutter/material.dart';
import 'package:twic_app/api/models/message.dart';
import 'package:twic_app/shared/users/avatar.dart';
import 'package:twic_app/style/style.dart';
import 'package:twic_app/api/session.dart';
import 'package:intl/intl.dart';

class MessageList extends StatelessWidget {
  final List<Message> list;

  MessageList({this.list});

  String _renderDate(DateTime date) {
    Duration since = DateTime.now().difference(date);
    print([date, DateTime.now(), since]);
    if (since.inSeconds < 60) {
      return '${since.inSeconds}s';
    } else if (since.inMinutes < 60) {
      return '${since.inMinutes}m';
    } else if (since.inHours < 24) {
      return '${since.inHours}h';
    } else if (since.inDays < 30) {
      return '${since.inDays}d';
    }

    return DateFormat.yMMMd().format(new DateTime.now());
  }

  @override
  Widget build(BuildContext context) {
    Size mediaSize = MediaQuery.of(context).size;
    return Container(
      width: mediaSize.width - 40.0,
        child: ListView.builder(
      shrinkWrap: true,
      physics: NeverScrollableScrollPhysics(),
      itemBuilder: (BuildContext context, int index) => Column(
            crossAxisAlignment: list[index].user.id == Session.instance.user.id
                ? CrossAxisAlignment.end
                : CrossAxisAlignment.start,
            children: <Widget>[
              Row(children: [
                list[index].user.id == Session.instance.user.id
                    ? Expanded( child : Container())
                    : Avatar(
                        size: 20.0,
                        file: list[index].user.avatar,
                      ),
                SizedBox(
                  width: 10.0,
                ),
                Text(_renderDate(list[index].createdAt), style: Style.lightText)
              ]),
              Row(children: [
                list[index].user.id == Session.instance.user.id
                    ? Expanded( child : Container()) : SizedBox(width: 25.0),
                list[index].user.id == Session.instance.user.id
                    ? Container(
                        padding: EdgeInsets.only(
                            left: 20.0, right: 20.0, top: 5.0, bottom: 5.0),
                        constraints:
                            BoxConstraints(maxWidth: mediaSize.width * 0.7),
                        decoration: BoxDecoration(
                            color: Style.genZPurple,
                            borderRadius:
                                BorderRadius.all(Radius.circular(8.0))),
                        child: Text(list[index].text, style: Style.whiteText),
                      )
                    : Container(
                        padding: EdgeInsets.only(
                            left: 20.0, right: 20.0, top: 5.0, bottom: 5.0),
                        constraints:
                            BoxConstraints(maxWidth: mediaSize.width * 0.7),
                        decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius:
                                BorderRadius.all(Radius.circular(8.0))),
                        child: Text(list[index].text, style: Style.text),
                      )
              ]),
            ],
          ),
      itemCount: list.length,
    ));
  }
}
