import 'package:flutter/material.dart';
import 'package:twic_app/style/style.dart';
import 'package:twic_app/pages/home.dart';
import 'package:twic_app/pages/profile/profile.dart';
import 'package:twic_app/pages/discover/discover.dart';
import 'package:twic_app/pages/chat/conversations.dart';
import 'package:twic_app/api/services/messages.dart';
import 'package:twic_app/pages/posts/create.dart';
import 'package:twic_app/api/session.dart';
import 'package:twic_app/shared/users/avatar.dart';
import 'package:twic_app/shared/form/form.dart';
import 'package:twic_app/style/twic_font_icons.dart';

enum ButtonEnum { Home, Discover, Create, Profile, Chat }

class BottomNav extends StatelessWidget {
  final ButtonEnum current;
  final Function refresh;
  final Map<String, dynamic> filters = {};

  BottomNav({this.current, this.refresh});

  @override
  Widget build(BuildContext context) {
    print(Messages.unread);
    return Container(
        color: Colors.white,
        padding: EdgeInsets.symmetric(horizontal: 24),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            IconButton(
              icon: Icon(
                current == ButtonEnum.Home
                    ? TwicFont.home_plain
                    : TwicFont.home,
                size: 24.0,
                color: Style.grey,
              ),
              onPressed: () {
                current == ButtonEnum.Home
                    ? refresh(() {})
                    : Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (BuildContext context) => Home()));
              },
            ),
            IconButton(
                icon: Icon(
                  TwicFont.search,
                  size: 24.0,
                  color: Style.lightGrey,
                ),
                onPressed: () {
                  current == ButtonEnum.Discover
                      ? refresh(() {})
                      : Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (BuildContext context) => Discover(
                                    filters: filters,
                                  )));
                }),
            Button(
              background: Style.mainColor,
              height: 24.0,
              width: 40.0,
              radius: BorderRadius.all(Radius.circular(4.0)),
              color: Colors.white,
              fontSize: 18.0,
              text: "+",
              onPressed: () => Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (BuildContext context) => CreatePost())),
            ),
            Stack(alignment: Alignment(0, 0), children: [
              Container(
                height: 24,
                width: 24,
                decoration: BoxDecoration(
                    color: Style.mainColor,
                    borderRadius: BorderRadius.all(Radius.circular(12))),
              ),
              IconButton(
                icon: Avatar(
                  size: 22.0,
                  href: Session.instance.user.avatar?.href(),
                ),
                onPressed: () {
                  current == ButtonEnum.Profile
                      ? refresh(() {})
                      : Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (BuildContext context) =>
                                  Profile(user_id: Session.instance.user.id)));
                },
              ),
            ]),
            Stack(children: [
              IconButton(
                icon: Icon(
                  current == ButtonEnum.Chat
                      ? TwicFont.conversation_plain
                      : TwicFont.conversation,
                  size: 24.0,
                  color: Style.grey,
                ),
                onPressed: () {
                  current == ButtonEnum.Chat
                      ? refresh(() {})
                      : Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (BuildContext context) =>
                                  ConversationsList()));
                },
              ),
              Messages.unread['MESSAGE'] > 0 ||
                      Messages.unread['GROUP'] > 0 ||
                      Messages.unread['CHANNEL'] > 0
                  ? Container(
                      width: 30,
                      height: 30,
                      alignment: Alignment(3, 2),
                      child: Container(
                        decoration: BoxDecoration(
                            color: Colors.red,
                            borderRadius:
                                BorderRadius.all(Radius.circular(10))),
                        height: 10,
                        width: 10,
                      ),
                    )
                  : Container(width: 0, height: 0,)
            ]),
          ],
        ));
  }
}
