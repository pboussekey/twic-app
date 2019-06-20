import 'package:flutter/material.dart';
import 'package:twic_app/api/services/schools.dart';
import 'package:twic_app/api/models/models.dart';
import 'package:twic_app/shared/users/userlist.dart';
import 'package:twic_app/shared/users/usercardlist.dart';
import 'package:twic_app/shared/hashtags/hashtaglist.dart';
import 'package:twic_app/shared/schools/schoollist.dart';
import '../root_page.dart';
import 'package:twic_app/style/style.dart';
import 'package:twic_app/shared/form/form.dart';
import 'package:twic_app/shared/components/bottom_nav.dart';
import 'package:twic_app/pages/discover/discover_filters.dart';
import 'package:twic_app/shared/components/tabs.dart';
import 'package:twic_app/api/session.dart';
import 'package:twic_app/style/twic_font_icons.dart';

enum DiscoverModes { Discover, Search }
enum DiscoverTags { Major, Minor, ClassYear, School, University }

class Discover extends StatefulWidget {
  Map<String, dynamic> filters;
  String search;

  Discover({@required this.filters});

  @override
  State createState() => DiscoverState();
}

class DiscoverState extends State<Discover> {
  final controller = TextEditingController();
  bool showFilters = true;
  UniqueKey listKey = UniqueKey();

  DiscoverTags currentTag = DiscoverTags.Major;
  DiscoverModes currentMode = DiscoverModes.Discover;

  String filterText(DiscoverTags tag) {
    switch (tag) {
      case DiscoverTags.Major:
        return "Major";
      case DiscoverTags.Minor:
        return "Minor";
      case DiscoverTags.ClassYear:
        return "Class year";
      case DiscoverTags.School:
        return Session.instance.user.degree == 'UNDERGRADUATE'
            ? 'College'
            : 'School';
      case DiscoverTags.University:
        return "University";
    }
  }

  String filterSubtitle(DiscoverTags tag) {
    switch (tag) {
      case DiscoverTags.Major:
        return "People with same Major";
      case DiscoverTags.Minor:
        return "People with same Minor";
      case DiscoverTags.ClassYear:
        return "People with same Class year";
      case DiscoverTags.School:
        return "People at the same ${Session.instance.user.degree == 'UNDERGRADUATE' ? 'College' : 'School'}";
      case DiscoverTags.University:
        return "People at the same University";
    }
  }

  String filterTitle(DiscoverTags tag) {
    switch (tag) {
      case DiscoverTags.Major:
        return Session.instance.user.major?.name;
      case DiscoverTags.Minor:
        return Session.instance.user.minor?.name;
      case DiscoverTags.ClassYear:
        return Session.instance.user.classYear.toString();
      case DiscoverTags.School:
        return Session.instance.user.school.name;
      case DiscoverTags.University:
        return Session.instance.user.institution.name;
    }
  }

  Widget _renderList() {
    switch (currentTag) {
      case DiscoverTags.School:
        return UserCardList(
            direction: Axis.vertical,
            school_id: Session.instance.user.school.id);
      case DiscoverTags.University:
        return UserCardList(
            direction: Axis.vertical,
            university_id: Session.instance.user.institution.id);
      case DiscoverTags.ClassYear:
        return UserCardList(
            direction: Axis.vertical,
            class_year: Session.instance.user.classYear);
      case DiscoverTags.Major:
        return UserCardList(
            direction: Axis.vertical, major_id: Session.instance.user.major.id);
      case DiscoverTags.Minor:
        return UserCardList(
            direction: Axis.vertical, minor_id: Session.instance.user.minor.id);
    }
  }

  Widget _renderContent(Size size) {
    if (currentMode == DiscoverModes.Discover) {
      return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Padding(
              padding: EdgeInsets.only(left: 20),
              child: Row(children: _renderFilters())),
        ),
        SizedBox(
          height: 20,
        ),
        Padding(
            padding: EdgeInsets.symmetric(horizontal: 20),
            child:
                Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Text(
                filterSubtitle(currentTag),
                style: Style.get(fontSize: 14, color: Style.grey),
                textAlign: TextAlign.start,
              ),
              Text(
                filterTitle(currentTag),
                style: Style.titleStyle,
                textAlign: TextAlign.start,
              )
            ])),
        Container(key: listKey, height: size.height - 250, child: _renderList())
      ]);
    } else {
      return Tabs(
          height: size.height - 150,
          contentHeight: size.height - 260,
          onTap: (int index) => setState(() => showFilters = index == 0),
          tabs: [
            Text(
              'People',
              textAlign: TextAlign.center,
            ),
            Text('Hashtags', textAlign: TextAlign.center),
            Text('Universities', textAlign: TextAlign.center),
          ],
          widget: showFilters
              ? Container(
                  width: size.width,
                  height: 60,
                  child: ListView(
                    scrollDirection: Axis.horizontal,
                    children: <Widget>[
                      Container(
                          padding: EdgeInsets.only(
                              left: 20, top: 10.0, bottom: 10.0),
                          child: Button(
                            background: widget.filters.length == 0
                                ? Style.veryLightGrey
                                : Style.genZBlue,
                            color: widget.filters.length == 0
                                ? Style.grey
                                : Colors.white,
                            padding: EdgeInsets.only(left: 10),
                            width: 80,
                            height: 30,
                            radius: BorderRadius.all(Radius.circular(6)),
                            onPressed: () =>
                                Navigator.push<Map<String, dynamic>>(
                                  context,
                                  MaterialPageRoute(
                                      builder: (BuildContext context) =>
                                          DiscoverFilters(
                                              filters: widget.filters)),
                                ).then((Map<String, dynamic> _filters) =>
                                    setState(() {
                                      listKey = UniqueKey();
                                      widget.filters =
                                          _filters ?? widget.filters;
                                    })),
                            child: Row(
                              children: <Widget>[
                                Icon(
                                  TwicFont.sliders,
                                  color: widget.filters.length == 0
                                      ? Style.grey
                                      : Colors.white,
                                  size: 18,
                                ),
                                SizedBox(
                                  width: 5,
                                ),
                                Text(
                                  'Filter',
                                  style: widget.filters.length == 0
                                      ? Style.smallText
                                      : Style.smallWhiteText,
                                )
                              ],
                            ),
                          )),
                      null != widget.filters['classYear']
                          ? Container(
                              padding: EdgeInsets.only(
                                  left: 10, top: 10.0, bottom: 10.0),
                              child: Button(
                                height: 30,
                                radius: BorderRadius.all(Radius.circular(8.0)),
                                onPressed: () => setState(() {
                                      listKey = UniqueKey();
                                      widget.filters.remove('classYear');
                                    }),
                                padding: EdgeInsets.only(right: 12.0),
                                child: Row(children: [
                                  Icon(
                                    Icons.cancel,
                                    color: Colors.white,
                                    size: 16,
                                  ),
                                  SizedBox(
                                    width: 5,
                                  ),
                                  Session.instance.user.classYear ==
                                          widget.filters['classYear']
                                      ? Icon(
                                          TwicFont.star,
                                          color: Style.genZYellow,
                                          size: 12,
                                        )
                                      : Container(),
                                  Session.instance.user.classYear ==
                                          widget.filters['classYear']
                                      ? SizedBox(
                                          width: 5,
                                        )
                                      : Container(),
                                  Text(widget.filters['classYear'].toString(),
                                      style: Style.smallWhiteText)
                                ]),
                              ),
                            )
                          : Container(),
                      null != widget.filters['university']
                          ? Container(
                              padding: EdgeInsets.only(
                                  left: 10, top: 10.0, bottom: 10.0),
                              child: Button(
                                  height: 30,
                                  radius:
                                      BorderRadius.all(Radius.circular(8.0)),
                                  padding:
                                      EdgeInsets.only(right: 12.0, left: 5),
                                  child: Row(children: [
                                    Icon(
                                      Icons.cancel,
                                      color: Colors.white,
                                      size: 16,
                                    ),
                                    SizedBox(
                                      width: 5,
                                    ),
                                    Text(
                                        'mine' == widget.filters['university']
                                            ? 'My university'
                                            : widget.filters['university'].name,
                                        style: Style.smallWhiteText)
                                  ]),
                                  onPressed: () => setState(() {
                                        listKey = UniqueKey();
                                        widget.filters.remove('university');
                                      })),
                            )
                          : Container(),
                      null != widget.filters['degree']
                          ? Container(
                              padding: EdgeInsets.only(
                                  left: 10, top: 10.0, bottom: 10.0),
                              child: Button(
                                height: 30,
                                radius: BorderRadius.all(Radius.circular(8.0)),
                                padding: EdgeInsets.only(right: 12.0, left: 5),
                                child: Row(children: [
                                  Icon(
                                    Icons.cancel,
                                    color: Colors.white,
                                    size: 16,
                                  ),
                                  SizedBox(
                                    width: 5,
                                  ),
                                  Text(widget.filters['degree'],
                                      style: Style.smallWhiteText)
                                ]),
                                onPressed: () => setState(() {
                                      listKey = UniqueKey();
                                      widget.filters.remove('degree');
                                    }),
                              ),
                            )
                          : Container(),
                      null != widget.filters['major']
                          ? Container(
                              padding: EdgeInsets.only(
                                  left: 10, top: 10.0, bottom: 10.0),
                              child: Button(
                                  height: 30,
                                  radius: BorderRadius.all(Radius.circular(8)),
                                  padding:
                                      EdgeInsets.only(right: 12.0, left: 5),
                                  child: Row(children: [
                                    Icon(
                                      Icons.cancel,
                                      color: Colors.white,
                                      size: 16,
                                    ),
                                    SizedBox(
                                      width: 5,
                                    ),
                                    Text(widget.filters['major'].name,
                                        style: Style.smallWhiteText)
                                  ]),
                                  onPressed: () => setState(() {
                                        listKey = UniqueKey();
                                        widget.filters.remove('major');
                                      })),
                            )
                          : Container(),
                      null != widget.filters['minor']
                          ? Container(
                              padding: EdgeInsets.only(
                                  left: 10, top: 10.0, bottom: 10.0),
                              child: Button(
                                  height: 30,
                                  radius: BorderRadius.all(Radius.circular(8)),
                                  padding:
                                      EdgeInsets.only(right: 12.0, left: 5),
                                  child: Row(children: [
                                    Icon(
                                      Icons.cancel,
                                      color: Colors.white,
                                      size: 16,
                                    ),
                                    SizedBox(
                                      width: 5,
                                    ),
                                    Text(widget.filters['minor'].name,
                                        style: Style.smallWhiteText)
                                  ]),
                                  onPressed: () => setState(() {
                                        listKey = UniqueKey();
                                        widget.filters.remove('minor');
                                      })),
                            )
                          : Container(),
                      null != widget.filters['school']
                          ? Container(
                              padding: EdgeInsets.only(
                                  left: 10, top: 10.0, bottom: 10.0),
                              child: Button(
                                  height: 30,
                                  radius:
                                      BorderRadius.all(Radius.circular(8.0)),
                                  padding:
                                      EdgeInsets.only(right: 12.0, left: 5),
                                  child: Row(children: [
                                    Icon(
                                      Icons.cancel,
                                      color: Colors.white,
                                      size: 16,
                                    ),
                                    SizedBox(
                                      width: 5,
                                    ),
                                    Text(widget.filters['school'].name,
                                        style: Style.smallWhiteText)
                                  ]),
                                  onPressed: () => setState(() {
                                        listKey = UniqueKey();
                                        widget.filters.remove('school');
                                      })),
                            )
                          : Container(),
                    ],
                  ))
              : SizedBox(
                  height: 10.0,
                ),
          tabsContent: [
            UserList(
                key: listKey,
                university_id: widget.filters['university']?.id,
                school_id: widget.filters['school']?.id,
                major_id: widget.filters['major']?.id,
                minor_id: widget.filters['minor']?.id,
                class_year: widget.filters['classYear'],
                search: widget.search),
            HashtagList(search: widget.search, followed: false),
            Schools.getList(
                search: widget.search,
                degree: 'UNIVERSITY',
                builder: (List<School> schools) => SchoolList(list: schools))
          ]);
    }
  }

  List<Widget> _renderFilters() {
    List<Widget> tags = [];
    DiscoverTags.values.forEach((DiscoverTags tag) {
      if (!((tag == DiscoverTags.School &&
              Session.instance.user.institution ==
                  Session.instance.user.school) ||
          (tag == DiscoverTags.Minor && null == Session.instance.user.minor) ||
          (tag == DiscoverTags.Major && null == Session.instance.user.major))) {
        tags.add(Button(
          height: 40,
          padding: EdgeInsets.all(0),
          fontSize: 12,
          width: filterText(tag).length * 5.0 + 30,
          text: filterText(tag),
          background: tag != currentTag ? Colors.white : Style.mainColor,
          color: tag != currentTag ? Style.lightGrey : Colors.white,
          border: tag != currentTag ? Border.all(color: Style.border) : null,
          radius: BorderRadius.all(Radius.circular(6)),
          onPressed: () => setState(() {
                currentTag = tag;
                listKey = UniqueKey();
              }),
        ));
        tags.add(SizedBox(
          width: 5,
        ));
      }
    });
    return tags;
  }

  @override
  void initState() {
    super.initState();
    controller.addListener(() {
      if (controller.text.isEmpty) {
        setState(() {
          listKey = UniqueKey();
          currentMode = DiscoverModes.Search;
          widget.search = "";
        });
      } else {
        setState(() {
          listKey = UniqueKey();
          currentMode = DiscoverModes.Search;
          widget.search = controller.text;
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    Size mediaSize = MediaQuery.of(context).size;
    return Scaffold(
        resizeToAvoidBottomInset: false,
        body: RootPage(
            scrollable: false,
            child:
                Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Container(
                  padding: EdgeInsets.only(
                      left: 0, right: 20.0, top: 20, bottom: 10),
                  child: Row(children: [
                    SizedBox(
                      width: currentMode == DiscoverModes.Discover ? 20 : 10,
                    ),
                    currentMode == DiscoverModes.Discover
                        ? Container()
                        : Button(
                            padding: EdgeInsets.all(5),
                            height: 40,
                            width: 40,
                            background: Colors.transparent,
                            child: Icon(
                              Icons.arrow_back,
                              size: 30,
                              color: Style.lightGrey,
                            ),
                            onPressed: () => setState(() {
                                  currentMode = DiscoverModes.Discover;
                                  controller.text = '';
                                }),
                          ),
                    Container(
                        width: currentMode == DiscoverModes.Discover
                            ? mediaSize.width - 40
                            : mediaSize.width - 70,
                        child: Input(
                          color: Style.veryLightGrey,
                          shadow: false,
                          icon: TwicFont.search_3,
                          iconSize: 16,
                          controller: controller,
                          placeholder: "Search",
                        ))
                  ])),
              _renderContent(mediaSize)
            ])),
        bottomNavigationBar: BottomNav(
          current: ButtonEnum.Discover,
          refresh: setState,
        ));
  }
}
