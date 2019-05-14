import 'package:flutter/material.dart';
import 'package:twic_app/style/style.dart';
import 'package:twic_app/pages/welcome/presentation.dart';
import 'package:twic_app/pages/home.dart';
import 'package:twic_app/pages/onboarding/onboarding.dart';
import 'package:twic_app/pages/welcome/welcome.dart';
import 'package:twic_app/api/session.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:twic_app/shared/locale/translations.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

ConnectionState state;

void main() async {
  await DotEnv().load('local.env');
  print("MAIN INIT SESSION");
  Session session = await Session.init();
  await translations.init();
  if (null != session) {
    state = session.user.isActive == true
        ? ConnectionState.Logged
        : ConnectionState.Inactive;
  }
  else{
    bool firstTime = await Session.isFirstTime();
    state = firstTime ? ConnectionState.FirstTime : ConnectionState.NotLogged;
  }
  return runApp(TwicApp());
}

enum ConnectionState { FirstTime, NotLogged, Logged, Inactive }

Map<ConnectionState, Widget> states = {
  ConnectionState.FirstTime: Presentation(),
  ConnectionState.NotLogged: Welcome(),
  ConnectionState.Inactive: Onboarding(),
  ConnectionState.Logged: Home(),
};

class TwicApp extends StatelessWidget{

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'TWIC',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.grey,
        accentColor: Style.darkGrey,
        backgroundColor: Color.fromARGB(255, 255, 255, 255),
        fontFamily: 'Rubiks',
        textTheme: TextTheme(
          headline: TextStyle(fontSize: 72.0, fontWeight: FontWeight.bold),
          title: TextStyle(
              fontSize: 16.0,
              fontWeight: FontWeight.bold,
              color: Color.fromARGB(255, 24, 24, 76)),
          body1: TextStyle(fontSize: 15.0, color: Style.darkGrey),
          body2: TextStyle(fontSize: 12.0, color: Style.lightGrey),
        ),
      ),
      localizationsDelegates: [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ],
      supportedLocales: [
        const Locale('en', ''),
      ],
      home: states[state],
    );
  }

}
