import 'package:flutter/material.dart';
import 'package:twic_app/style/style.dart';


class Tabs extends StatelessWidget{

  final List<Text> tabs;
  final List<Widget> tabsContent;
  final Widget widget;
  final Function onTap;
  final double contentHeight;
  final double height;
  Tabs({this.tabs, this.tabsContent, this.widget, this.onTap, this.contentHeight, this.height});

  @override
  Widget build(BuildContext context) {
    Size mediaSize = MediaQuery.of(context).size;
    return DefaultTabController(
        length: tabs.length,
        child: Container(
            height: height ?? mediaSize.height,
            width: mediaSize.width,
            color: Colors.white,
            child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
              Container(
                  padding: EdgeInsets.only(left: 20.0, right: 20.0),
                  child: TabBar(
                    indicatorColor: Style.mainColor,
                    labelStyle: Style.smallText,
                    unselectedLabelColor: Style.lightGrey,
                    indicatorWeight: 2.0,
                    indicatorPadding: EdgeInsets.only(bottom: -1.0),
                    onTap: onTap,
                    labelPadding:
                    EdgeInsets.only(top: 10.0, bottom: 10.0),
                    tabs: tabs,
                  )),
              null != widget ? widget : Container(),
              SizedBox(height: 10.0,),
              Container(
                height: contentHeight ?? mediaSize.height - 210,
                width: mediaSize.width,
                child: TabBarView(children: tabsContent),
              )
            ])));
  }
}