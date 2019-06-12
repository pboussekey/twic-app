import 'package:flutter/material.dart';
import 'package:twic_app/pages/root_page.dart';
import 'package:twic_app/pages/discover/search.dart';
import 'package:twic_app/style/style.dart';
import 'package:twic_app/shared/form/button.dart';
import 'package:twic_app/api/session.dart';
import 'package:twic_app/api/models/models.dart';
import 'package:twic_app/api/services/fields.dart';
import 'package:twic_app/api/services/schools.dart';
import 'package:twic_app/style/twic_font_icons.dart';

class DiscoverFilters extends StatefulWidget {
  Map<String, dynamic> filters;

  DiscoverFilters({this.filters});

  @override
  State createState() => DiscoverFiltersState(filters: filters ?? {});
}

class DiscoverFiltersState extends State<DiscoverFilters> {
  final Map<String, dynamic> filters;

  DiscoverFiltersState({this.filters});

  @override
  Widget build(BuildContext context) {
    final Size mediaSize = MediaQuery.of(context).size;
    int currentYear = new DateTime.now().year;
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.white,
          centerTitle: true,
          title: Text('Filter by', style: Style.titleStyle),
          elevation: 0,
          actions: <Widget>[
            Button(
              text: "Clear",
              background: Colors.transparent,
              color: Style.grey,
              onPressed: () => setState(() => widget.filters.clear()),
            )
          ],
        ),
        body: RootPage(
            builder: () => Padding(
                padding: EdgeInsets.all(20.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text('University', style: Style.titleStyle),
                    SizedBox(
                      height: 20.0,
                    ),
                    Container(
                        height: 60.0,
                        decoration: BoxDecoration(
                            color: Style.purple,
                            borderRadius:
                                BorderRadius.all(Radius.circular(8.0)),
                            border: Border.all(color: Style.border)),
                        child: Row(
                          children: <Widget>[
                            Button(
                              text: "Mine",
                              height: 60,
                              radius: BorderRadius.all(Radius.circular(8.0)),
                              width: (mediaSize.width - 42) / 3,
                              color: null != filters['university'] &&
                                      Session.instance.user.institution.id ==
                                          filters['university'].id
                                  ? Style.darkGrey
                                  : Style.lightGrey,
                              background: null != filters['university'] &&
                                      Session.instance.user.institution.id ==
                                          filters['university'].id
                                  ? Colors.white
                                  : Colors.transparent,
                              border: null != filters['university'] &&
                                      Session.instance.user.institution.id ==
                                          filters['university'].id
                                  ? Border.all(color: Style.border)
                                  : Border.all(
                                      color: Colors.transparent, width: 0),
                              onPressed: () => setState(() {
                                    filters.remove('school');
                                    filters['university'] =
                                        Session.instance.user.institution;
                                  }),
                            ),
                            Button(
                              text: "All",
                              height: 60,
                              radius: BorderRadius.all(Radius.circular(8.0)),
                              width: (mediaSize.width - 42) / 3,
                              color: null == filters['university']
                                  ? Style.darkGrey
                                  : Style.lightGrey,
                              background: null == filters['university']
                                  ? Colors.white
                                  : Colors.transparent,
                              border: null == filters['university']
                                  ? Border.all(color: Style.border)
                                  : Border.all(
                                      color: Colors.transparent, width: 0),
                              onPressed: () => setState(() {
                                    filters.remove('school');
                                    filters.remove('university');
                                  }),
                            ),
                            Button(
                              text: null != filters['university'] &&
                                      Session.instance.user.institution.id !=
                                          filters['university'].id
                                  ? Session.instance.user.institution.name
                                  : "Select",
                              height: 60,
                              radius: BorderRadius.all(Radius.circular(8.0)),
                              width: (mediaSize.width - 42) / 3,
                              color: null != filters['university'] &&
                                      Session.instance.user.institution.id !=
                                          filters['university'].id
                                  ? Style.darkGrey
                                  : Style.lightGrey,
                              background: null != filters['university'] &&
                                      Session.instance.user.institution.id !=
                                          filters['university'].id
                                  ? Colors.white
                                  : Colors.transparent,
                              border: null != filters['university'] &&
                                      Session.instance.user.institution.id !=
                                          filters['university'].id
                                  ? Border.all(color: Style.border)
                                  : Border.all(
                                      color: Colors.transparent, width: 0),
                              onPressed: () => Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (BuildContext context) =>
                                          SearchPage(
                                            title: 'Search for a University',
                                            at: null,
                                            isMine: (School school) =>
                                                school.id ==
                                                Session.instance.user
                                                    .institution.id,
                                            map: (School school) =>
                                                SearchElement(
                                                    name: school.name),
                                            provider: (String search,
                                                    Function builder) =>
                                                Schools.getList(
                                                    degree: 'University',
                                                    search: search,
                                                    builder: builder),
                                          ))).then(
                                  (dynamic school) => setState(() {
                                        filters.remove('school');
                                        filters['university'] = school;
                                      })),
                            ),
                          ],
                        )),
                    SizedBox(
                      height: 20.0,
                    ),
                    Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text('Graduating class', style: Style.titleStyle),
                          null != filters['classYear']
                              ? Button(
                                  height: 20,
                                  width: 20,
                                  padding: EdgeInsets.all(0),
                                  background: Colors.transparent,
                                  child: Icon(Icons.cancel,
                                      color: Style.lightGrey, size: 16),
                                  onPressed: () => setState(
                                      () => filters.remove('classYear')),
                                )
                              : Container()
                        ]),
                    SizedBox(
                      height: 20.0,
                    ),
                    Container(
                        width: mediaSize.width - 40,
                        height: 50,
                        child: ListView.builder(
                          controller: ScrollController(
                              initialScrollOffset: null != filters['classYear']
                                  ? (filters['classYear'] - currentYear + 50) *
                                      90.0
                                  : (Session.instance.user.classYear -
                                          currentYear +
                                          50) *
                                      90.0),
                          scrollDirection: Axis.horizontal,
                          itemBuilder: (BuildContext context, int index) =>
                              Padding(
                                  padding: EdgeInsets.only(right: 10.0),
                                  child: Button(
                                    width: 80,
                                    padding: EdgeInsets.only(right: 10.0),
                                    radius:
                                        BorderRadius.all(Radius.circular(8.0)),
                                    border: null != filters['classYear'] &&
                                            currentYear - 50 + index ==
                                                filters['classYear']
                                        ? null
                                        : Border.all(color: Style.border),
                                    background: null != filters['classYear'] &&
                                            currentYear - 50 + index ==
                                                filters['classYear']
                                        ? Style.mainColor
                                        : Colors.white,
                                    child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceEvenly,
                                        children: [
                                          currentYear - 50 + index ==
                                                  Session
                                                      .instance.user.classYear
                                              ? Icon(Icons.star,
                                                  color: Style.genZYellow)
                                              : Container(),
                                          Text(
                                              (currentYear - 50 + index)
                                                  .toString(),
                                              textAlign: TextAlign.left,
                                              style: null !=
                                                          filters[
                                                              'classYear'] &&
                                                      currentYear -
                                                              50 +
                                                              index ==
                                                          filters['classYear']
                                                  ? Style.whiteText
                                                  : Style.text),
                                        ]),
                                    onPressed: () => setState(() =>
                                        filters['classYear'] =
                                            currentYear - 50 + index),
                                  )),
                          itemCount: 100,
                        )),
                    SizedBox(
                      height: 20.0,
                    ),
                    Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text('Program', style: Style.titleStyle),
                        ]),
                    SizedBox(
                      height: 20.0,
                    ),
                    Row(children: [
                      Button(
                        background: filters['degree'] == 'Undergraduate'
                            ? Style.mainColor
                            : Colors.white,
                        color: filters['degree'] == 'Undergraduate'
                            ? Colors.white
                            : Style.grey,
                        border: Border.all(color: Style.border),
                        height: 60,
                        radius: BorderRadius.all(Radius.circular(8.0)),
                        width: (mediaSize.width - 50) / 2,
                        text: "Undergraduate",
                        onPressed: () =>
                            setState(() {
                              filters.remove('school');
                              filters['degree'] =
                              filters['degree'] == 'Undergraduate'
                                  ? null
                                  : 'Undergraduate';
                            }),
                      ),
                      SizedBox(
                        width: 10.0,
                      ),
                      Button(
                          background: filters['degree'] == 'Graduate'
                              ? Style.mainColor
                              : Colors.white,
                          color: filters['degree'] == 'Graduate'
                              ? Colors.white
                              : Style.grey,
                          border: Border.all(color: Style.border),
                          height: 60,
                          radius: BorderRadius.all(Radius.circular(8.0)),
                          width: (mediaSize.width - 50) / 2,
                          text: "Graduate",
                          onPressed: () => setState(() {
                                filters.remove('school');
                                filters.remove('major');
                                filters.remove('minor');
                                filters['degree'] =
                                    filters['degree'] == 'Graduate'
                                        ? null
                                        : 'Graduate';
                              })),
                    ]),
                    'Undergraduate' == filters['degree']
                        ? Column(children: [
                            SizedBox(
                              height: 20.0,
                            ),
                            Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text('Degree focus', style: Style.titleStyle),
                                  null != filters['major'] ||
                                          null != filters['minor']
                                      ? Button(
                                          height: 20,
                                          width: 60,
                                          padding: EdgeInsets.all(0),
                                          background: Colors.transparent,
                                          child: Row(children: [
                                            Text(
                                                null != filters['major']
                                                    ? 'Major'
                                                    : 'Minor',
                                                style: Style.smallLightText),
                                            SizedBox(
                                              width: 5,
                                            ),
                                            Icon(Icons.cancel,
                                                color: Style.lightGrey,
                                                size: 16)
                                          ]),
                                          onPressed: () => setState(() {
                                                filters.remove('major');
                                                filters.remove('minor');
                                              }),
                                        )
                                      : Container(),
                                ]),
                            SizedBox(
                              height: 20.0,
                            ),
                            null == filters['major'] && null == filters['minor']
                                ? Row(children: [
                                    Button(
                                      background: Colors.white,
                                      color: Style.grey,
                                      border: Border.all(color: Style.border),
                                      height: 60,
                                      radius: BorderRadius.all(
                                          Radius.circular(8.0)),
                                      width: (mediaSize.width - 50) / 2,
                                      text: "Major",
                                      onPressed: () => Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (BuildContext context) =>
                                                  SearchPage(
                                                    title: 'Search for a Major',
                                                    at: filters['university'],
                                                    isMine: (Field field) =>
                                                        field.id ==
                                                        Session.instance.user
                                                            .major.id,
                                                    map: (Field field) =>
                                                        SearchElement(
                                                            name: field.name),
                                                    provider: (String search,
                                                            Function builder) =>
                                                        Fields.getList(
                                                            school_id: filters[
                                                                    'university']
                                                                ?.id,
                                                            search: search,
                                                            builder: builder),
                                                  ))).then((dynamic field) =>
                                          setState(
                                              () => filters['major'] = field)),
                                    ),
                                    SizedBox(
                                      width: 10.0,
                                    ),
                                    Button(
                                      background: Colors.white,
                                      color: Style.grey,
                                      border: Border.all(color: Style.border),
                                      height: 60,
                                      radius: BorderRadius.all(
                                          Radius.circular(8.0)),
                                      width: (mediaSize.width - 50) / 2,
                                      text: "Minor",
                                      onPressed: () => Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (BuildContext context) =>
                                                  SearchPage(
                                                    title: 'Search for a Minor',
                                                    at: filters['university'],
                                                    isMine: (Field field) =>
                                                        field.id ==
                                                        Session.instance.user
                                                            .minor.id,
                                                    map: (Field field) =>
                                                        SearchElement(
                                                            name: field.name),
                                                    provider: (String search,
                                                            Function builder) =>
                                                        Fields.getList(
                                                            school_id: filters[
                                                                    'university']
                                                                ?.id,
                                                            search: search,
                                                            builder: builder),
                                                  ))).then((dynamic field) =>
                                          setState(
                                              () => filters['minor'] = field)),
                                    )
                                  ])
                                : Button(
                                    child: Row(
                                      children: <Widget>[
                                        ((null != filters['major'] &&
                                                    filters['major'].id ==
                                                        Session.instance.user
                                                            .major.id) ||
                                                (null != filters['minor'] &&
                                                    filters['minor'].id ==
                                                        Session.instance.user
                                                            .minor.id))
                                            ? Row(children: [
                                                Icon(
                                                  TwicFont.star,
                                                  color: Style.genZYellow,
                                                  size: 12,
                                                ),
                                                SizedBox(
                                                  width: 10,
                                                )
                                              ])
                                            : Container(),
                                        Text(
                                            (filters['major'] ??
                                                    filters['minor'])
                                                .name,
                                            style: Style.whiteText),
                                      ],
                                    ),
                                    radius:
                                        BorderRadius.all(Radius.circular(6)),
                                    height: 60,
                                    padding:
                                        EdgeInsets.symmetric(horizontal: 10),
                                    onPressed: () => setState(() {
                                          filters.remove('major');
                                          filters.remove('minor');
                                        }),
                                  )
                          ])
                        : Container(),
                    SizedBox(
                      height: 20.0,
                    ),
                    Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                              'Undergraduate' == filters['degree']
                                  ? 'College'
                                  : 'School',
                              style: Style.titleStyle),
                          null != filters['school']
                              ? Button(
                                  height: 20,
                                  width: 20,
                                  padding: EdgeInsets.all(0),
                                  background: Colors.transparent,
                                  child: Icon(
                                    Icons.cancel,
                                    color: Style.lightGrey,
                                    size: 16,
                                  ),
                                  onPressed: () =>
                                      setState(() => filters.remove('school')),
                                )
                              : Container(),
                        ]),
                    SizedBox(
                      height: 20.0,
                    ),
                    null == filters['school']
                        ? Button(
                            background: Colors.white,
                            color: Style.grey,
                            border: Border.all(color: Style.border),
                            height: 60,
                            radius: BorderRadius.all(Radius.circular(8.0)),
                            width: (mediaSize.width - 40),
                            text:
                                "Select a ${'Undergraduate' == filters['degree'] ? 'Residential College' : 'School'}",
                            onPressed: () => Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (BuildContext context) =>
                                        SearchPage(
                                          title:
                                              'Search for a ${'Undergraduate' == filters['degree'] ? 'Residential College' : 'School'}',
                                          at: filters['university'],
                                          isMine: (School school) =>
                                              school.id ==
                                              Session.instance.user.school.id,
                                          map: (School school) =>
                                              SearchElement(name: school.name),
                                          provider: (String search,
                                                  Function builder) =>
                                              Schools.getList(
                                                  degree: filters['degree']
                                                      ?.toString()
                                                      ?.toUpperCase(),
                                                  university_id:
                                                      filters['university']?.id,
                                                  search: search,
                                                  builder: builder),
                                        ))).then((dynamic school) =>
                                setState(() => filters['school'] = school)))
                        : Button(
                            child: Row(
                              children: <Widget>[
                                (filters['school'].id ==
                                        Session.instance.user.school.id)
                                    ? Row(children: [
                                        Icon(
                                          TwicFont.star,
                                          color: Style.genZYellow,
                                          size: 12,
                                        ),
                                        SizedBox(
                                          width: 10,
                                        )
                                      ])
                                    : Container(),
                                Text(filters['school'].name,
                                    style: Style.whiteText),
                              ],
                            ),
                            radius: BorderRadius.all(Radius.circular(6)),
                            height: 60,
                            padding: EdgeInsets.symmetric(horizontal: 10),
                            onPressed: () => setState(() {
                                  filters.remove('major');
                                  filters.remove('minor');
                                })),
                    SizedBox(
                      height: 40.0,
                    ),
                    Button(
                      width: (mediaSize.width - 40),
                      background: Style.genZBlue,
                      text: "Apply",
                      onPressed: () =>
                          setState(() => Navigator.pop(context, filters)),
                    )
                  ],
                ))));
  }
}
