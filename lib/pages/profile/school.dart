import 'package:flutter/material.dart';

import 'package:twic_app/api/models/models.dart';
import 'package:twic_app/api/services/schools.dart';
import 'package:twic_app/style/style.dart';

import '../root_page.dart';
import 'package:twic_app/shared/form/form.dart';
import 'package:twic_app/shared/components/bottom_nav.dart';
import 'package:twic_app/shared/components/tabs.dart';
import 'package:twic_app/shared/feed/feed.dart';
import 'package:twic_app/shared/users/userlist.dart';
import 'package:twic_app/shared/hashtags/hashtaglist.dart';
import 'package:twic_app/style/twic_font_icons.dart';

class SchoolProfile extends StatefulWidget {
  final int school_id;

  SchoolProfile({this.school_id});

  @override
  State createState() => SchoolProfileState();
}

class SchoolProfileState extends State<SchoolProfile> {
  ScrollController _scroll;

  @override
  void initState() {
    _scroll = ScrollController();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: RootPage(
            scroll: _scroll,
            scrollable: false,
            child: Schools.get(
                id: widget.school_id,
                builder: (School school) => SchoolProfileContent(
                      logo: school?.logo?.href(),
                      name: school.name,
                      id: school.id,
                      scroll: _scroll,
                    ))),
        bottomNavigationBar: BottomNav(
          current: ButtonEnum.Profile,
          refresh: setState,
        ));
  }
}

class SchoolProfileContent extends StatefulWidget {
  String logo;
  String name;
  int id;
  int nb_students;
  ScrollController scroll;

  SchoolProfileContent(
      {this.logo, this.name, this.nb_students, this.id, this.scroll});

  @override
  State<SchoolProfileContent> createState() => SchoolProfileContentState();
}

class SchoolProfileContentState extends State<SchoolProfileContent> {
  @override
  Widget build(BuildContext context) {
    Size mediaSize = MediaQuery.of(context).size;
    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      Column(crossAxisAlignment: CrossAxisAlignment.start, children: <Widget>[
        Container(
            padding: EdgeInsets.only(left: 20.0, right: 20.0),
            child:
                Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Button(
                width: 25,
                height: 40,
                background: Colors.transparent,
                child: Icon(
                  Icons.arrow_back,
                  color: Style.lightGrey,
                  size: 25,
                ),
                onPressed: () => Navigator.pop(context),
                padding: EdgeInsets.all(0),
              ),
              SizedBox(
                height: 28,
              ),
              Row(children: [
                null != widget.logo
                    ? Container(
                        padding: EdgeInsets.all(4.0),
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.all(Radius.circular(4)),
                            border: Border.all(
                                width: 1,
                                color: Style.border,
                                style: BorderStyle.solid)),
                        child: Image.network(
                          widget.logo,
                          height: 12.0,
                          width: 12.0,
                        ))
                    : Container(),
                SizedBox(
                  width: 10.0,
                ),
                Text(widget.name, style: Style.titleStyle)
              ]),
              SizedBox(
                height: 10.0,
              ),
              Text("5746 students enrolled", style: Style.greyText),
            ])),
        SizedBox(
          height: 20.0,
        ),
        Tabs(
          height: mediaSize.height - 210,
          contentHeight: mediaSize.height - 261,
          indicatorColor: Colors.transparent,
          labelStyle: Style.largeText,
          padding: EdgeInsets.all(0),
          scrollable: true,
          tabs: [
            Container(
                padding: EdgeInsets.only(left: 20, right: 40),
                child: Text(
                  'Posts',
                  textAlign: TextAlign.start,
                )),
            Container(
                padding: EdgeInsets.only(right: 40),
                child: Text(
                  'Students',
                  textAlign: TextAlign.start,
                )),
            Container(
                child: Text(
              'Channels',
              textAlign: TextAlign.start,
            ))
          ],
          tabsContent: <Widget>[
            Feed(
              scroll: widget.scroll,
              school_id: widget.id,
            ),
            UserList(
              university_id: widget.id,
            ),
            HashtagList(
                university_id: widget.id,
                placeholder: Column(children: [
                  SizedBox(
                    height: 40,
                  ),
                  Container(
                    height: 80,
                    width: 80,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.all(Radius.circular(40)),
                      border: Border.all(color: Style.mainColor),
                    ),
                    child: Icon(
                      TwicFont.hashtag,
                      color: Style.mainColor,
                      size: 40,
                    ),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  Text("No channels yet", style: Style.largeText),
                  SizedBox(
                    height: 40,
                  )
                ])),
          ],
        )
      ]),
    ]);
  }
}
