import 'package:flutter/material.dart';

import 'package:twic_app/style/style.dart';

import 'root_page.dart';
import 'package:twic_app/shared/feed/feed.dart';
import 'package:twic_app/shared/components/bottom_nav.dart';

class Home extends StatefulWidget {
  @override
  State createState() => HomeState();
}

class HomeState extends State<Home> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        centerTitle: true,
        title: Image.asset(
          'assets/logo.png',
          height: 20,
          fit: BoxFit.fitHeight,
        ),
        elevation: 0,
        leading: Container(),
        bottom: PreferredSize(
            child: Container(
              color: Style.border,
              height: 1.0,
            ),
            preferredSize: Size.fromHeight(1.0)),
      ),
      body: RootPage(
          child: Feed()),
      bottomNavigationBar: BottomNav(
        current: ButtonEnum.Home,
        refresh: setState,
      ),
    );
  }
}
