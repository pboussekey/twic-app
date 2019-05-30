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
import 'package:firebase_dynamic_links/firebase_dynamic_links.dart';

ConnectionState state;


final DynamicLinkParameters parameters = DynamicLinkParameters(
  uriPrefix: 'https://twicapp.page.link/authentication',
  link: Uri.parse('https://twicapp.page.link/authentication'),
  androidParameters: AndroidParameters(
    packageName: 'io.twic.app',
    minimumVersion: 125,
  ),
  iosParameters: IosParameters(
    bundleId: 'com.example.ios',
    minimumVersion: '1.0.1',
    appStoreId: '123456789',
  ),
);

void main() async {
  await DotEnv().load('dev.env');
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

class TwicApp extends StatefulWidget {


  @override
  State<StatefulWidget> createState() => _TwicApp();
}

class _TwicApp extends State<TwicApp>{

  Future<void> _retrieveDynamicLink() async {
    final PendingDynamicLinkData data = await FirebaseDynamicLinks.instance.retrieveDynamicLink();
    final Uri deepLink = data?.link;

    if (deepLink != null) {
      print(deepLink.pathSegments);
    }
  }

  @override
  void initState() {
    super.initState();
    //_retrieveDynamicLink();
  }

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
