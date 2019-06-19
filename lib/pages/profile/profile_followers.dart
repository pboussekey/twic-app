import 'package:flutter/material.dart';
import 'package:twic_app/api/services/users.dart';
import 'package:twic_app/api/models/models.dart';
import 'package:twic_app/shared/users/userlist.dart';
import '../root_page.dart';
import 'package:twic_app/style/style.dart';
import 'package:twic_app/api/session.dart';
import 'package:twic_app/shared/form/form.dart';
import 'package:twic_app/shared/components/tabs.dart';
import 'package:twic_app/shared/components/bottom_nav.dart';

class ProfileFollowers extends StatefulWidget {
  final int user_id;

  ProfileFollowers({this.user_id});

  @override
  State createState() => ProfileFollowersState();
}

class ProfileFollowersState extends State<ProfileFollowers> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.white,
          centerTitle: true,
          title: Text('Followers', style: Style.titleStyle),
          elevation: 0,
        ),
        body: RootPage(
            child: Column(children: [
          Padding(
              padding: EdgeInsets.symmetric(horizontal: 20),
              child: Input(
                height: 50.0,
                color: Style.veryLightGrey,
                shadow: false,
                icon: Icons.search,
                placeholder: "Search",
              )),
          SizedBox(
            height: 10,
          ),
          UserList(
            user_id: widget.user_id,
            follower: true,
          )
        ])),
        bottomNavigationBar: BottomNav(
          current: ButtonEnum.Profile,
          refresh: setState,
        ));
  }
}
