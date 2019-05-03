import 'package:flutter/material.dart';
import 'package:twic_app/api/services/users.dart';
import 'package:twic_app/api/models/user.dart';
import 'package:twic_app/shared/users/userlist.dart';
import '../root_page.dart';
import 'package:twic_app/style/style.dart';
import 'package:twic_app/api/session.dart';
import 'package:twic_app/shared/form/input.dart';
import 'package:twic_app/shared/components/tabs.dart';
import 'package:twic_app/shared/components/bottom_menu.dart';

class ProfileFollowings extends StatefulWidget {
  final int user_id;

  ProfileFollowings({this.user_id});

  @override
  State createState() => ProfileFollowingsState();
}

class ProfileFollowingsState extends State<ProfileFollowings> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.white,
          centerTitle: true,
          title: Text('Followings', style: Style.titleStyle),
          elevation: 0,
        ),
        body: RootPage(
            child: Tabs(
                tabs: [
                  Text(
                    'All',
                    textAlign: TextAlign.center,
                  ),
                  Text('My university', textAlign: TextAlign.center),
                ],
                widget: Padding(
                  padding: EdgeInsets.all(20.0),
                  child: Input(
                    height: 40.0,
                    color: Style.veryLightGrey,
                    shadow: false,
                    icon: Icons.search,
                    placeholder: "Search",
                  ),
                ),
                tabsContent: [
                  Users.getList(
                      following: true,
                      user_id: widget.user_id,
                      builder: (List<User> users) => UserList(list: users)),
                  Users.getList(
                      following: true,
                      school_id: Session.instance.user.university.id,
                      user_id: widget.user_id,
                      builder: (List<User> users) => UserList(list: users))
                ])),
        bottomNavigationBar: BottomMenu(
          current: ButtonEnum.Profile,
          refresh: setState,
        ));
  }
}
