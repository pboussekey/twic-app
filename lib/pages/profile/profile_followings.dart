import 'package:flutter/material.dart';
import 'package:twic_app/api/services/users.dart';
import 'package:twic_app/api/services/hashtags.dart';
import 'package:twic_app/api/models/models.dart';
import 'package:twic_app/shared/users/userlist.dart';
import 'package:twic_app/shared/hashtags/hashtaglist.dart';
import '../root_page.dart';
import 'package:twic_app/shared/form/form.dart';
import 'package:twic_app/shared/components/tabs.dart';
import 'package:twic_app/shared/components/bottom_nav.dart';
import 'package:twic_app/style/style.dart';
import 'package:twic_app/api/services/cache.dart';

class ProfileFollowings extends StatefulWidget {
  final int user_id;

  ProfileFollowings({this.user_id});

  @override
  State createState() => ProfileFollowingsState();
}

class ProfileFollowingsState extends State<ProfileFollowings> {
  @override
  Widget build(BuildContext context) {
    return RootPage(
        appBar: AppBar(
          backgroundColor: Colors.white,
          centerTitle: true,
          title: Text('Followings', style: Style.titleStyle),
          elevation: 0,
        ),
        child: Tabs(
            tabs: [
              Text(
                'People',
                textAlign: TextAlign.center,
              ),
              Text('Channels', textAlign: TextAlign.center),
            ],
            widget: Padding(
              padding: EdgeInsets.all(20.0),
              child: Input(
                height: 50.0,
                color: Style.veryLightGrey,
                shadow: false,
                icon: Icons.search,
                placeholder: "Search",
              ),
            ),
            tabsContent: [
              UserList(
                following: true,
                user_id: widget.user_id,
              ),
              HashtagList(user_id: widget.user_id)
            ]),
        bottomBar: BottomNav(
          current: ButtonEnum.Profile,
          refresh: setState,
        ));
  }
}
