import 'package:flutter/material.dart';
import 'package:twic_app/api/services/users.dart';
import 'package:twic_app/api/services/hashtags.dart';
import 'package:twic_app/api/services/schools.dart';
import 'package:twic_app/api/models/models.dart';
import 'package:twic_app/shared/users/userlist.dart';
import 'package:twic_app/shared/hashtags/hashtaglist.dart';
import 'package:twic_app/shared/schools/schoollist.dart';
import '../root_page.dart';
import 'package:twic_app/style/style.dart';
import 'package:twic_app/shared/form/form.dart';
import 'package:twic_app/shared/components/tabs.dart';
import 'package:twic_app/shared/components/bottom_nav.dart';
import 'package:twic_app/pages/discover/discover_filters.dart';
import 'package:twic_app/api/session.dart';
import 'package:twic_app/style/twic_font_icons.dart';

class SearchElement {
  final String name;
  final String info;

  SearchElement({this.name, this.info});
}

class SearchPage extends StatefulWidget {
  String search;
  final String title;
  final School at;
  final Function provider;
  final Function map;
  final Function isMine;

  SearchPage({this.title, this.at, this.provider, this.map, this.isMine});

  @override
  State createState() => SearchState();
}

class SearchState extends State<SearchPage> {
  dynamic selected;
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final controller = TextEditingController();

  SearchState() {
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
        resizeToAvoidBottomInset: false,
        body: RootPage(
            scrollable: false,
            child:
                Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Container(
                  padding: EdgeInsets.only(left: 20, right: 20, top: 10),
                  child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            Button(
                              padding: EdgeInsets.all(5),
                              height: 40,
                              width: 40,
                              background: Colors.transparent,
                              child: Icon(
                                Icons.arrow_back,
                                size: 30,
                                color: Style.lightGrey,
                              ),
                              onPressed: () => Navigator.pop(context),
                            ),
                            Button(
                              background: Style.genZBlue,
                              text: "Apply",
                              height: 40,
                              disabled: null == selected,
                              onPressed: () => Navigator.pop(context, selected),
                            )
                          ],
                        ),
                        SizedBox(
                          height: 25,
                        ),
                        Text(widget.title, style: Style.titleStyle),
                        null != widget.at
                            ?SizedBox(height: 10,) : Container(),
                        null != widget.at
                            ? Row(children: [
                                Text(
                                  'at',
                                  style: Style.lightText,
                                ),
                                SizedBox(
                                  width: 5,
                                ),
                                Text(widget.at.name, style: Style.hashtagStyle)
                              ])
                            : Container(),
                        SizedBox(
                          height: 20,
                        ),
                        Input(
                          width: mediaSize.width - 40,
                          height: 48.0,
                          color: Style.veryLightGrey,
                          shadow: false,
                          icon: Icons.search,
                          controller: controller,
                          placeholder: "Search",
                        ),
                        SizedBox(
                          width: 10.0,
                        )
                      ])),
              SizedBox(height: 10,),
              Container(
                  width: mediaSize.width ,
                  height: mediaSize.height - (null != widget.at ? 275 : 250),
                  child: widget.provider(
                      controller.text,
                      (List<dynamic> list) => ListView.builder(
                          itemCount: list.length,
                          itemBuilder: (BuildContext context, int index) {
                            SearchElement element = widget.map(list[index]);
                            return Button(
                                width: mediaSize.width,
                                padding: EdgeInsets.symmetric(horizontal: 20),
                                onPressed: () =>
                                    setState(() => selected = list[index]),
                                background: Colors.transparent,
                                radius: BorderRadius.all(Radius.circular(0)),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: <Widget>[
                                    Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: <Widget>[
                                        Row(
                                          children: <Widget>[
                                            Text(element.name,
                                                style: Style.text),
                                            SizedBox(width: 5),
                                            widget.isMine(list[index])
                                                ? Icon(
                                                    TwicFont.star,
                                                    color: Style.genZYellow,
                                                    size: 12,
                                                  )
                                                : Container()
                                          ],
                                        ),
                                        null != element.info
                                            ? Text(element.info,
                                                style: Style.smallLightText)
                                            : Container()
                                      ],
                                    ),
                                    RadioButton(
                                        isChecked: null != selected &&
                                            selected.id == list[index % list.length].id),
                                  ],
                                ));
                          })))
            ])),
        bottomNavigationBar: BottomNav(
          current: ButtonEnum.Discover,
          refresh: setState,
        ));
  }
}
