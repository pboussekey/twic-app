import 'package:flutter/material.dart';
import 'package:twic_app/api/models/models.dart';
import 'package:twic_app/pages/chat/conversation.dart';
import 'package:twic_app/shared/form/form.dart';
import 'package:twic_app/shared/users/avatar.dart';
import 'package:twic_app/style/style.dart';
import 'package:intl/intl.dart';
import 'package:twic_app/style/twic_font_icons.dart';
import 'package:twic_app/shared/components/round_picture.dart';
import 'package:twic_app/api/services/cache.dart';

class ConversationList extends StatelessWidget {
  final List<int> list;

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
      itemBuilder: (BuildContext context, int index) {
        Conversation conversation = AppCache.getModel(list[index]);
        return null != conversation
            ? Button(
                background: Colors.white,
                radius: BorderRadius.all(Radius.circular(0)),
                onPressed: () => Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (BuildContext context) =>
                            ConversationPage(conversation: conversation))),
                padding: EdgeInsets.only(top: 5.0, left: 20.0, right: 20.0),
                height: 45,
                width: mediaSize.width,
                child: Flex(
                    direction: Axis.horizontal,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      null != conversation.users &&
                              conversation.users.length == 1
                          ? Avatar(
                              href: conversation.users[0].avatar?.href(),
                              size: 35,
                            )
                          : (null != conversation.picture ||
                                  null != conversation.hashtag
                              ? Stack(children: [
                                  null != conversation.hashtag
                                      ? RoundPicture(
                                          width: 25,
                                          padding: EdgeInsets.all(5),
                                          height: 25,
                                          background: Style.darkPurple,
                                          picture: 'assets/logo-white.png',
                                        )
                                      : Avatar(
                                          href: conversation.picture.href(),
                                          size: 35),
                                  null != conversation.hashtag
                                      ? Container(
                                          alignment: Alignment.bottomRight,
                                          height: 35.0,
                                          width: 35.0,
                                          child: ClipRRect(
                                              borderRadius:
                                                  new BorderRadius.circular(
                                                      20.0),
                                              child: Container(
                                                child: Icon(
                                                  TwicFont.hashtag,
                                                  color: Colors.white,
                                                  size: 10,
                                                ),
                                                color: Style.mainColor,
                                                height: 20,
                                                width: 20,
                                                alignment: Alignment.center,
                                              )),
                                        )
                                      : Container()
                                ])
                              : Container(
                                  alignment: Alignment(0, 0),
                                  height: 35,
                                  width: 35,
                                  decoration: BoxDecoration(
                                      color: Style.darkGrey,
                                      borderRadius: BorderRadius.all(
                                          Radius.circular(20))),
                                  child: Text(
                                      (conversation.users.length + 1)
                                          .toString(),
                                      style: Style.whiteTitle),
                                )),
                      SizedBox(
                        width: 10,
                      ),
                      Expanded(
                          child: Padding(
                              padding: EdgeInsets.only(top: 5.0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: <Widget>[
                                  Text(
                                      null != conversation.name
                                          ? conversation.name
                                          : "${conversation.users[0].firstname} ${conversation.users[0].lastname}",
                                      style: Style.get(
                                          fontWeight: FontWeight.w600,
                                          color: Style.darkGrey,
                                          fontSize: 16)),
                                  null != conversation.last
                                      ? Text("${conversation.last}",
                                          style: Style.smallGreyText)
                                      : Container(),
                                ],
                              ))),
                      Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          SizedBox(height: 5,),
                          null != conversation.lastDate
                              ? Text(
                                  "${_renderDate(conversation.lastDate)}",
                                  style: Style.lightText,
                                )
                              : Container(),
                          SizedBox(height: 5,),
                          conversation.unread > 0
                              ? Container(
                              height: 16,
                              width: 16,
                              alignment: Alignment(0, 0),
                              decoration: BoxDecoration(
                                  color: Style.mainColor,
                                  borderRadius: BorderRadius.all(
                                      Radius.circular(8))),
                              child: Text(
                                  conversation.unread.toString(),
                                  textAlign: TextAlign.center,
                                  style: Style.smallWhiteText))
                              : Container()
                        ],
                      ),
                    ]))
            : Container();
      },
      itemCount: list.length,
    ));
  }
}
