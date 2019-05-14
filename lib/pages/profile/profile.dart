import 'package:flutter/material.dart';

import 'package:twic_app/api/models/user.dart';
import 'package:twic_app/api/services/users.dart';
import 'package:twic_app/shared/users/avatar.dart';
import 'package:twic_app/style/style.dart';

import '../root_page.dart';
import 'package:twic_app/shared/feed/feed.dart';
import 'package:twic_app/shared/form/button.dart';
import 'package:twic_app/api/session.dart';
import 'package:twic_app/shared/components/bottom_nav.dart';
import 'package:twic_app/pages/profile/profile_followers.dart';
import 'package:twic_app/pages/profile/profile_followings.dart';
import 'package:twic_app/pages/profile/profile_edition.dart';

class Profile extends StatefulWidget {
  final int user_id;

  Profile({this.user_id});

  @override
  State createState() => ProfileState();
}

class ProfileState extends State<Profile> {
  @override
  Widget build(BuildContext context) {
    Size mediaSize = MediaQuery.of(context).size;
    return Scaffold(
        body: RootPage(
            child: Users.get(
                id: widget.user_id,
                builder: (User user) => Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                              child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              Padding(
                                padding: EdgeInsets.only(
                                    left: 20.0, right: 20.0, top: 20.0),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: <Widget>[
                                    Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Avatar(
                                            file: user.avatar,
                                          ),
                                          Session.instance.user.id == user.id
                                              ? Button(
                                                  text: "Edit profile",
                                                  height: 40,
                                                  color: Style.lightGrey,
                                                  background:
                                                      Colors.transparent,
                                                  border: Border.all(
                                                      color: Style.lightGrey),
                                                  onPressed: () => Navigator.push(
                                                      context,
                                                      MaterialPageRoute(
                                                          builder: (BuildContext
                                                                  context) =>
                                                              ProfileEdition())),
                                                )
                                              : Container()
                                        ]),
                                    SizedBox(
                                      height: 10.0,
                                    ),
                                    Row(children: [
                                      Text("${user.firstname} ${user.lastname}",
                                          style: Style.titleStyle),
                                      null != user.classYear
                                          ? Text(
                                              "'${user.classYear % 100}",
                                              style: Style.lightTitle,
                                            )
                                          : Container()
                                    ]),
                                    Row(children: [
                                      null != user.university.logo
                                          ? Image.network(
                                              user.university.logo.href(),
                                              height: 12.0,
                                              width: 12.0,
                                            )
                                          : Container(),
                                      SizedBox(
                                        width: 10.0,
                                      ),
                                      Column(
                                        children: <Widget>[
                                          Text(user.university.name,
                                              style: Style.hashtagStyle),
                                          null != user.school
                                              ? Text(user.school.name,
                                                  style: Style.smallGreyText)
                                              : Container(),
                                        ],
                                      )
                                    ]),
                                    SizedBox(
                                      height: 10.0,
                                    ),
                                    Row(children: [
                                      null != user.major
                                          ? Container(
                                              padding: EdgeInsets.only(
                                                  top: 4.0,
                                                  bottom: 5.0,
                                                  left: 10.0,
                                                  right: 10.0),
                                              height: 20.0,
                                              decoration: BoxDecoration(
                                                borderRadius: BorderRadius.all(
                                                    Radius.circular(10.0)),
                                                color: Style.grey,
                                              ),
                                              child: Text(user.major.name,
                                                  style: Style.smallWhiteText),
                                            )
                                          : Container(),
                                      SizedBox(
                                        width: 10.0,
                                      ),
                                      null != user.minor
                                          ? Container(
                                              padding: EdgeInsets.only(
                                                  top: 4.0,
                                                  bottom: 5.0,
                                                  left: 10.0,
                                                  right: 10.0),
                                              height: 20.0,
                                              decoration: BoxDecoration(
                                                borderRadius: BorderRadius.all(
                                                    Radius.circular(10.0)),
                                                color: Style.lightGrey,
                                              ),
                                              child: Text(user.minor.name,
                                                  style: Style.smallGreyText),
                                            )
                                          : Container(),
                                    ]),
                                  ],
                                ),
                              ),
                              SizedBox(
                                height: 10.0,
                              ),
                              SizedBox(
                                height: 10.0,
                                child: Container(
                                  decoration: BoxDecoration(
                                      border: Border(
                                          bottom: BorderSide(
                                              width: 1,
                                              color: Style.border,
                                              style: BorderStyle.solid))),
                                ),
                              ),
                              Padding(
                                padding:
                                    EdgeInsets.only(left: 10.0, right: 10.0),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: <Widget>[
                                    Container(
                                        width: (mediaSize.width - 20) / 4,
                                        child: FlatButton(
                                            padding: EdgeInsets.all(0.0),
                                            onPressed: () => Navigator.push(
                                                context,
                                                MaterialPageRoute(
                                                    builder: (BuildContext
                                                            context) =>
                                                        ProfileFollowers(
                                                            user_id: user.id))),
                                            child: Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: <Widget>[
                                                Text(
                                                    user.nbFollowers.toString(),
                                                    style: Style.largeText),
                                                Text('FOLLOWERS',
                                                    style: Style
                                                        .verySmallWhiteText),
                                              ],
                                            ))),
                                    Container(
                                        width: (mediaSize.width - 20) / 4,
                                        child: FlatButton(
                                            padding: EdgeInsets.all(0.0),
                                            onPressed: () => Navigator.push(
                                                context,
                                                MaterialPageRoute(
                                                    builder: (BuildContext
                                                            context) =>
                                                        ProfileFollowings(
                                                            user_id: user.id))),
                                            child: Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: <Widget>[
                                                Text(
                                                    user.nbFollowings
                                                        .toString(),
                                                    style: Style.largeText),
                                                Text('FOLLOWINGS',
                                                    style: Style
                                                        .verySmallWhiteText),
                                              ],
                                            ))),
                                    Container(
                                        width: (mediaSize.width - 20) / 4,
                                        child: FlatButton(
                                            padding: EdgeInsets.all(0.0),
                                            onPressed: () => Navigator.push(
                                                context,
                                                MaterialPageRoute(
                                                    builder: (BuildContext
                                                            context) =>
                                                        ProfileFollowings(
                                                            user_id: user.id))),
                                            child: Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: <Widget>[
                                                Text(user.nbPosts.toString(),
                                                    style: Style.largeText),
                                                Text('HASHTAGS',
                                                    style: Style
                                                        .verySmallWhiteText),
                                              ],
                                            ))),
                                    Container(
                                        width: (mediaSize.width - 20) / 4,
                                        child: FlatButton(
                                            padding: EdgeInsets.all(0.0),
                                            onPressed: () => Navigator.push(
                                                context,
                                                MaterialPageRoute(
                                                    builder: (BuildContext
                                                            context) =>
                                                        ProfileFollowings(
                                                            user_id: user.id))),
                                            child: Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: <Widget>[
                                                Text(user.nbPosts.toString(),
                                                    style: Style.largeText),
                                                Text('POSTS',
                                                    style: Style
                                                        .verySmallWhiteText),
                                              ],
                                            ))),
                                  ],
                                ),
                              )
                            ],
                          )),
                          SizedBox(
                            height: 0.0,
                            child: Container(
                              decoration: BoxDecoration(
                                  border: Border(
                                      bottom: BorderSide(
                                          width: 1,
                                          color: Style.border,
                                          style: BorderStyle.solid))),
                            ),
                          ),
                          SizedBox(
                            height: 10.0,
                          ),
                          Padding(
                              padding: EdgeInsets.only(left: 20.0, right: 20.0),
                              child: Text(
                                "Posts",
                                style: Style.titleStyle,
                              )),
                          SizedBox(
                            height: 10.0,
                          ),
                          Feed(
                            user_id: user.id,
                          )
                        ]))),
        bottomNavigationBar: BottomNav(
          current: ButtonEnum.Profile,
          refresh: setState,
        ));
  }
}
