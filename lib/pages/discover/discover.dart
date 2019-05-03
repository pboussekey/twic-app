import 'package:flutter/material.dart';
import 'package:twic_app/api/services/users.dart';
import 'package:twic_app/api/services/hashtags.dart';
import 'package:twic_app/api/services/schools.dart';
import 'package:twic_app/api/models/user.dart';
import 'package:twic_app/api/models/hashtag.dart';
import 'package:twic_app/api/models/school.dart';
import 'package:twic_app/shared/users/userlist.dart';
import 'package:twic_app/shared/hashtags/hashtaglist.dart';
import 'package:twic_app/shared/schools/schoollist.dart';
import '../root_page.dart';
import 'package:twic_app/style/style.dart';
import 'package:twic_app/shared/form/input.dart';
import 'package:twic_app/shared/form/button.dart';
import 'package:twic_app/shared/components/tabs.dart';
import 'package:twic_app/shared/components/bottom_menu.dart';
import 'package:twic_app/pages/discover/discover_filters.dart';
import 'package:twic_app/api/session.dart';

class Discover extends StatefulWidget {
  Map<String, dynamic> filters;
  String search;

  Discover({@required this.filters});

  @override
  State createState() => DiscoverState();
}

class DiscoverState extends State<Discover> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final controller = TextEditingController();

  DiscoverState() {
    controller.addListener(() {
      if (controller.text.isEmpty) {
        setState(() {
          widget.search = "";
        });
      } else {
        setState(() {
          widget.search = controller.text;
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final Size mediaSize = MediaQuery.of(context).size;
    return Scaffold(
        body: RootPage(
            builder: () => Column(children: [
                  Container(
                      padding: EdgeInsets.all(20.0),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Form(
                            key: _formKey,
                            child: Container(
                                width: mediaSize.width - 100,
                                child: Input(
                                  height: 40.0,
                                  color: Style.veryLightGrey,
                                  shadow: false,
                                  icon: Icons.search,
                                  controller: controller,
                                  placeholder: "Search",
                                )),
                          ),
                          SizedBox(
                            width: 10.0,
                          ),
                          Button(
                              background: Colors.transparent,
                              width: 50.0,
                              padding: EdgeInsets.all(0.0),
                              child: Row(children: [
                                widget.filters.length > 0
                                    ? ClipRRect(
                                        borderRadius:
                                            new BorderRadius.circular(10.0),
                                        child: Container(
                                          height: 20,
                                          width: 20,
                                          padding: EdgeInsets.all(2.0),
                                          color: Style.genZPurple,
                                          child: Text(
                                            widget.filters.length.toString(),
                                            style: Style.whiteText,
                                            textAlign: TextAlign.center,
                                          ),
                                        ))
                                    : Container(),
                                Icon(
                                  Icons.tune,
                                  color: Style.grey,
                                )
                              ]),
                              onPressed: () =>
                                  Navigator.push<Map<String, dynamic>>(
                                    context,
                                    MaterialPageRoute(
                                        builder: (BuildContext context) =>
                                            DiscoverFilters(
                                                filters: widget.filters)),
                                  ).then((Map<String, dynamic> _filters) =>
                                      setState(() => widget.filters =
                                          _filters ?? widget.filters)))
                        ],
                      )),
                  Tabs(
                      tabs: [
                        Text(
                          'People',
                          textAlign: TextAlign.center,
                        ),
                        Text('Hashtags', textAlign: TextAlign.center),
                        Text('Universities', textAlign: TextAlign.center),
                      ],
                      widget: widget.filters.length > 0
                          ? Container(
                              width: mediaSize.width - 40,
                              height: 50,
                              child: ListView(
                                scrollDirection: Axis.horizontal,
                                children: <Widget>[
                                  null != widget.filters['classYear']
                                      ? Padding(
                                          padding: EdgeInsets.only(
                                              right: 10,
                                              top: 10.0,
                                              bottom: 10.0),
                                          child: Button(
                                            height: 30,
                                            radius: 8.0,
                                            padding: EdgeInsets.only(
                                                left: 10.0, right: 10.0),
                                            text: widget.filters['classYear']
                                                .toString(),
                                          ),
                                        )
                                      : Container(),
                                  null != widget.filters['university']
                                      ? Padding(
                                          padding: EdgeInsets.only(
                                              right: 10,
                                              top: 10.0,
                                              bottom: 10.0),
                                          child: Button(
                                            height: 30,
                                            radius: 8.0,
                                            padding: EdgeInsets.only(
                                                left: 10.0, right: 10.0),
                                            text: 'mine' ==
                                                    widget.filters['university']
                                                ? 'My university'
                                                : 'Other universities',
                                          ),
                                        )
                                      : Container(),
                                  null != widget.filters['major']
                                      ? Padding(
                                          padding: EdgeInsets.only(
                                              right: 10,
                                              top: 10.0,
                                              bottom: 10.0),
                                          child: Button(
                                            height: 30,
                                            radius: 8.0,
                                            padding: EdgeInsets.only(
                                                left: 10.0, right: 10.0),
                                            text: widget.filters['major'].name,
                                          ),
                                        )
                                      : Container(),
                                  null != widget.filters['minor']
                                      ? Padding(
                                          padding: EdgeInsets.only(
                                              right: 10,
                                              top: 10.0,
                                              bottom: 10.0),
                                          child: Button(
                                            height: 30,
                                            radius: 8.0,
                                            padding: EdgeInsets.only(
                                                left: 10.0, right: 10.0),
                                            text: widget.filters['minor'].name,
                                          ),
                                        )
                                      : Container(),
                                  null != widget.filters['school']
                                      ? Padding(
                                          padding: EdgeInsets.only(
                                              right: 10,
                                              top: 10.0,
                                              bottom: 10.0),
                                          child: Button(
                                            height: 30,
                                            radius: 8.0,
                                            padding: EdgeInsets.only(
                                                left: 10.0, right: 10.0),
                                            text: widget.filters['school'].name,
                                          ),
                                        )
                                      : Container(),
                                ],
                              ))
                          : SizedBox(
                              height: 10.0,
                            ),
                      tabsContent: [
                        Users.getList(
                            follower: false,
                            school_id: 'mine' == widget.filters['university']
                                ? Session.instance.user.university.id
                                : null,
                            major_id: null != widget.filters['major']
                                ? widget.filters['major'].id
                                : null,
                            minor_id: null != widget.filters['minor']
                                ? widget.filters['minor'].id
                                : null,
                            class_year: null != widget.filters['classYear']
                                ? widget.filters['classYear']
                                : null,
                            exclude_school:
                                'other' == widget.filters['university']
                                    ? [Session.instance.user.university.id]
                                    : null,
                            search: widget.search,
                            builder: (List<User> users) =>
                                UserList(list: users)),
                        Hashtags.getList(
                            search: widget.search,
                            followed: false,
                            builder: (List<Hashtag> hashtags) =>
                                HashtagList(list: hashtags)),
                        Schools.getList(
                            search: widget.search,
                            builder: (List<School> schools) =>
                                SchoolList(list: schools))
                      ])
                ])),
        bottomNavigationBar: BottomMenu(
          current: ButtonEnum.Discover,
          refresh: setState,
        ));
  }
}
