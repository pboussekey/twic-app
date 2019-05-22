import 'package:flutter/material.dart';
import 'package:twic_app/api/models/conversation.dart';
import 'package:twic_app/pages/chat/conversation.dart';
import 'package:twic_app/shared/form/button.dart';
import 'package:twic_app/shared/users/avatar.dart';
import 'package:twic_app/style/style.dart';
import 'package:intl/intl.dart';

class ConversationList extends StatelessWidget {
  final List<Conversation> list;

  ConversationList({this.list});

  String _renderDate(DateTime date) {
    Duration since = DateTime.now().difference(date);
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
        child: ListView.builder(
      shrinkWrap: true,
      physics: NeverScrollableScrollPhysics(),
      scrollDirection: Axis.horizontal,
      itemBuilder: (BuildContext context, int index) => Button(
        background: Colors.white,
          radius: BorderRadius.all(Radius.circular(0)),
          onPressed: () => Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (BuildContext context) =>
                      ConversationPage(conversation: list[index]))),
          padding:
              EdgeInsets.only(top: 10.0, bottom: 10.0, left: 20.0, right: 20.0),
          height: 50,
          width: mediaSize.width,
          child: Flex(
              direction: Axis.horizontal,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                list[index].users.length == 1 ? Avatar(
                  href: list[index].users[0].avatar?.href(),
                ) : (
                    null != list[index].picture ? Avatar(href : list[index].picture.href()) :
                    Container(
                      color : Style.darkGrey,
                      child: Text((list[index].users.length + 1).toString(), style : Style.whiteTitle),
                    )
                ),
                SizedBox(
                  width: 10,
                ),
                Expanded(
                    child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(
                        "${list[index].users[0].firstname} ${list[index].users[0].lastname}",
                        style: Style.text),
                    null != list[index].last ? Text("${list[index].last}", style: Style.lightText) : Container(),
                  ],
                )),
                Container(
                    height: 50.0,
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: <Widget>[
                        null != list[index].lastDate ? Text(
                          "${_renderDate(list[index].lastDate)}",
                          style: Style.lightText,
                        ): Container()
                      ],
                    )),
              ])),
      itemCount: list.length,
    ));
  }
}
