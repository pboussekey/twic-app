import 'package:flutter/material.dart';
import 'package:twic_app/style/style.dart';

class Tabs extends StatelessWidget {
  final List<Widget> tabs;
  final List<Widget> tabsContent;
  final Widget widget;
  final Function onTap;
  final double contentHeight;
  final double height;
  final Color indicatorColor;
  final TextStyle labelStyle;
  final Color unselectedLabelColor;
  final bool scrollable;
  final EdgeInsetsGeometry padding;

  Tabs(
      {this.tabs,
        this.padding,
      this.tabsContent,
      this.widget,
        this.scrollable,
      this.onTap,
      this.contentHeight,
      this.height,
      this.labelStyle,
      this.unselectedLabelColor,
      this.indicatorColor});

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
                      padding: padding ?? EdgeInsets.only(left: 20.0, right: 20.0),
                      child: TabBar(
                        isScrollable: scrollable ?? true,
                        indicatorColor: indicatorColor ?? Style.mainColor,
                        labelStyle: labelStyle ?? Style.smallText,
                        unselectedLabelColor: unselectedLabelColor ?? Style.lightGrey,
                        indicatorWeight: 2.0,
                        indicatorPadding: EdgeInsets.only(bottom: -1.0),
                        onTap: onTap,
                        labelPadding: EdgeInsets.only(top: 10.0, bottom: 10.0),
                        tabs: tabs,
                      )),
                  null != widget ? widget : Container(),
                  SizedBox(
                    height: 10.0,
                  ),
                  Container(
                    height: contentHeight ?? mediaSize.height - 210,
                    width: mediaSize.width,
                    child: TabBarView(children: tabsContent),
                  )
                ])));
  }
}
