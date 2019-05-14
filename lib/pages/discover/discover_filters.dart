import 'package:flutter/material.dart';
import 'package:twic_app/pages/root_page.dart';
import 'package:twic_app/style/style.dart';
import 'package:twic_app/shared/form/button.dart';
import 'package:twic_app/api/session.dart';

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
                                      'mine' == filters['university']
                                  ? Style.darkGrey
                                  : Style.lightGrey,
                              background: null != filters['university'] &&
                                      'mine' == filters['university']
                                  ? Colors.white
                                  : Colors.transparent,
                              border: null != filters['university'] &&
                                      'mine' == filters['university']
                                  ? Border.all(color: Style.border)
                                  : Border.all(
                                      color: Colors.transparent, width: 0),
                              onPressed: () => setState(
                                  () => filters['university'] = 'mine'),
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
                              onPressed: () =>
                                  setState(() => filters.remove('university')),
                            ),
                            Button(
                              text: "Other",
                              height: 60,
                              radius: BorderRadius.all(Radius.circular(8.0)),
                              width: (mediaSize.width - 42) / 3,
                              color: null != filters['university'] &&
                                      'other' == filters['university']
                                  ? Style.darkGrey
                                  : Style.lightGrey,
                              background: null != filters['university'] &&
                                      'other' == filters['university']
                                  ? Colors.white
                                  : Colors.transparent,
                              border: null != filters['university'] &&
                                      'other' == filters['university']
                                  ? Border.all(color: Style.border)
                                  : Border.all(
                                      color: Colors.transparent, width: 0),
                              onPressed: () => setState(
                                  () => filters['university'] = 'other'),
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
                                      color: Style.lightGrey),
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
                                    radius: BorderRadius.all(Radius.circular(8.0)),
                                    border: null != filters['classYear'] &&
                                            currentYear - 50 + index ==
                                                filters['classYear']
                                        ? null
                                        : Border.all(color: Style.border),
                                    background: null != filters['classYear'] &&
                                            currentYear - 50 + index ==
                                                filters['classYear']
                                        ? Style.genZPurple
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
                          Text('Degree focus', style: Style.titleStyle),
                          null != filters['field']
                              ? Button(
                                  height: 20,
                                  width: 20,
                                  padding: EdgeInsets.all(0),
                                  background: Colors.transparent,
                                  child: Icon(Icons.cancel,
                                      color: Style.lightGrey),
                                  onPressed: () => setState(
                                      () => filters.remove('classYear')),
                                )
                              : Container(),
                        ]),
                    SizedBox(
                      height: 20.0,
                    ),
                    Row(children: [
                      Button(
                          background: Colors.white,
                          color: Style.grey,
                          border: Border.all(color: Style.border),
                          height: 60,
                          radius: BorderRadius.all(Radius.circular(8.0)),
                          width: (mediaSize.width - 50) / 2,
                          text: "Major"),
                      SizedBox(
                        width: 10.0,
                      ),
                      Button(
                          background: Colors.white,
                          color: Style.grey,
                          border: Border.all(color: Style.border),
                          height: 60,
                          radius: BorderRadius.all(Radius.circular(8.0)),
                          width: (mediaSize.width - 50) / 2,
                          text: "Minor")
                    ]),
                    SizedBox(
                      height: 20.0,
                    ),
                    Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text('School', style: Style.titleStyle),
                          null != filters['school']
                              ? Button(
                                  height: 20,
                                  width: 20,
                                  padding: EdgeInsets.all(0),
                                  background: Colors.transparent,
                                  child: Icon(Icons.cancel,
                                      color: Style.lightGrey),
                                  onPressed: () => setState(
                                      () => filters.remove('classYear')),
                                )
                              : Container(),
                        ]),
                    SizedBox(
                      height: 20.0,
                    ),
                    Button(
                        background: Colors.white,
                        color: Style.grey,
                        border: Border.all(color: Style.border),
                        height: 60,
                        radius: BorderRadius.all(Radius.circular(8.0)),
                        width: (mediaSize.width - 40),
                        text: "Select school"),

                    SizedBox(
                      height: 40.0,
                    ),
                    Button(
                      width: (mediaSize.width - 40),
                      text: "Apply",
                      onPressed: () => setState(() => Navigator.pop(context, filters)),
                    )
                  ],
                ))));
  }
}
