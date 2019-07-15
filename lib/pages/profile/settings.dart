import 'package:flutter/material.dart';
import 'package:twic_app/pages/root_page.dart';
import 'package:twic_app/pages/welcome/welcome.dart';
import 'package:twic_app/style/style.dart';
import 'package:twic_app/shared/form/form.dart';
import 'package:twic_app/api/session.dart';
import 'package:twic_app/main.dart';

class Settings extends StatefulWidget {
  @override
  State<Settings> createState() => SettingsState();
}

class SettingsState extends State<Settings> {
  @override
  Widget build(BuildContext context) {
    Size mediaSize = MediaQuery.of(context).size;
    return RootPage(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
      ),
      child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 20),
          child: Column(children: [
        Text("Settings", style: Style.titleStyle),
        Button(
          background: Colors.transparent,
          color: Style.lightGrey,
          text: "Log out",
          padding: EdgeInsets.all(0),
          onPressed: () async{
            await Session.destroy();
            TwicApp.restartApp(context);
          },
        )
      ])),
    );
  }
}
