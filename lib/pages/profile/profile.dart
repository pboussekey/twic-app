import 'package:flutter/material.dart';

import 'package:twic_app/api/models/user.dart';
import 'package:twic_app/api/services/users.dart';
import 'package:twic_app/shared/users/avatar.dart';
import 'package:twic_app/style/style.dart';

import '../root_page.dart';
import 'package:twic_app/shared/feed/feed.dart';
import 'package:twic_app/shared/components/bottom_menu.dart';
import 'package:twic_app/pages/profile/profile_followers.dart';
import 'package:twic_app/pages/profile/profile_followings.dart';

class Profile extends StatefulWidget {
  final int user_id;

  Profile({this.user_id});

  @override
  State createState() => ProfileState();
}

class ProfileHeader extends StatelessWidget {
  final User user;
  final int tab;

  ProfileHeader({this.user, this.tab});

  @override
  Widget build(BuildContext context) {
    Size mediaSize = MediaQuery.of(context).size;
    return Container(
        child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Padding(
          padding: EdgeInsets.only(left: 20.0, right: 20.0, top: 20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Avatar(
                file: user.avatar,
              ),
              SizedBox(height: 10.0,),
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
                    Text(user.university.name, style: Style.hashtagStyle),
                    null != user.school
                        ? Text(user.school.name, style: Style.smallGreyText)
                        : Container(),
                  ],
                )
              ]),
              SizedBox(
                height: 10.0,
              ),
              Row(children: [
              null != user.major ? Container(
                  padding: EdgeInsets.only(
                      top: 5.0, bottom: 5.0, left: 10.0, right: 10.0),
                  height: 20.0,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.all(Radius.circular(10.0)),
                    color: Style.grey,
                  ),
                  child: Text(user.major.name, style: Style.smallWhiteText),
                ) : Container(),
                SizedBox(
                  width: 10.0,
                ),
                null != user.minor ? Container(
                  padding: EdgeInsets.only(
                      top: 5.0, bottom: 5.0, left: 10.0, right: 10.0),
                  height: 20.0,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.all(Radius.circular(10.0)),
                    color: Style.lightGrey,
                  ),
                  child: Text(user.minor.name, style: Style.smallGreyText),
                ) : Container(),
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
            decoration: BoxDecoration(border: Border(bottom: BorderSide(width: 1, color: Style.border, style: BorderStyle.solid))),
          ),
        ),
        Padding(
          padding: EdgeInsets.only(left: 10.0, right: 10.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Container(
                  width: (mediaSize.width - 20) / 4,
                  child: FlatButton(
                      padding: EdgeInsets.all(0.0),
                      onPressed: () => Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (BuildContext context) =>
                                  ProfileFollowers(user_id: user.id))),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Text(user.nbFollowers.toString(),
                              style: Style.largeText),
                          Text('FOLLOWERS', style: Style.verySmallWhiteText),
                        ],
                      ))),
              Container(
                  width: (mediaSize.width - 20) / 4,
                  child: FlatButton(
                      padding: EdgeInsets.all(0.0),
                      onPressed: () => Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (BuildContext context) =>
                                  ProfileFollowings(user_id: user.id))),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Text(user.nbFollowings.toString(),
                              style: Style.largeText),
                          Text('FOLLOWINGS', style: Style.verySmallWhiteText),
                        ],
                      ))),
              Container(
                  width: (mediaSize.width - 20) / 4,
                  child: FlatButton(
                      padding: EdgeInsets.all(0.0),
                      onPressed: () => Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (BuildContext context) =>
                                  ProfileFollowings(user_id: user.id))),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Text(user.nbPosts.toString(), style: Style.largeText),
                          Text('HASHTAGS', style: Style.verySmallWhiteText),
                        ],
                      ))),
              Container(
                  width: (mediaSize.width - 20) / 4,
                  child: FlatButton(
                      padding: EdgeInsets.all(0.0),
                      onPressed: () => Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (BuildContext context) =>
                                  ProfileFollowings(user_id: user.id))),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Text(user.nbPosts.toString(), style: Style.largeText),
                          Text('POSTS', style: Style.verySmallWhiteText),
                        ],
                      ))),
            ],
          ),
        )
      ],
    ));
  }
}

class ProfileState extends State<Profile> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      /*appBar: AppBar(
        backgroundColor: Colors.white,
        centerTitle: true,
        title: Image.asset(
          'assets/logo.png',
          height: 20,
          fit: BoxFit.fitHeight,
        ),
        elevation: 0,
        leading: Container(),
        bottom: PreferredSize(
            child: Container(
              color: Style.border,
              height: 1.0,
            ),
            preferredSize: Size.fromHeight(1.0)),
      ),*/
      body: RootPage(
          child: Users.get(
              id: widget.user_id,
              builder: (User user) => Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    ProfileHeader(
                      user: user,
                      tab: 0,
                    ),
                    SizedBox(
                      height: 0.0,
                      child: Container(
                        decoration: BoxDecoration(border: Border(bottom: BorderSide(width: 1, color: Style.border, style: BorderStyle.solid))),
                      ),
                    ),
                    SizedBox(height: 10.0,),
                    Padding(
                        padding: EdgeInsets.only(left : 20.0, right : 20.0),
                        child : Text("Posts", style: Style.titleStyle,)
                    ),
                    SizedBox(height: 10.0,),
                    Feed(
                      user_id: user.id,
                    )
                  ]))),
      bottomNavigationBar: BottomMenu(
        current: ButtonEnum.Profile,
        refresh: setState,
      ),
    );
  }
}
