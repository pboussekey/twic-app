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
import 'package:twic_app/api/services/api_rest.dart' as api;
import 'package:flutter/services.dart';
import 'dart:async';

bool firstTime = false;

void main() async {
  await DotEnv().load('conf.env');
  await Session.init();

  await translations.init();

  firstTime = await Session.isFirstTime();
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);
  return runApp(TwicApp());
}

class TwicApp extends StatefulWidget {
  static restartApp(BuildContext context) {
    final _TwicApp state =
        context.ancestorStateOfType(const TypeMatcher<_TwicApp>());
    state.restartApp();
  }

  @override
  State<StatefulWidget> createState() => _TwicApp();
}

class _TwicApp extends State<TwicApp> {
  Timer timer;

  Future<void> checkRequest(BuildContext context) async {
    if (null != timer) {
      timer.cancel();
    }
    if (null != Session.instance) return;
    int time = 0;
    timer = new Timer.periodic(Duration(seconds: 1), (Timer timer) async {
      time++;
      String requestToken = await Session.getRequest();
      if (time == 1 && null != requestToken && requestToken.isNotEmpty) {
        Map<String, dynamic> data = await api
            .request(cmd: 'login', params: {'request_token': requestToken});
        if (null != data['token'] || null != Session.instance) {
          timer.cancel();
          Session.setRequest('');
          await Session.set(data);
          restartApp();
        }
      }
      _retrieveDynamicLink(context);
      if(time == 5){
        time = 0;
      }
    });
  }

  Key _key = new UniqueKey();

  void restartApp() {
    setState(() {
      _key = new UniqueKey();
    });
  }

  Widget _getHome() {
    Session session = Session.instance;
    if (null != session) {
      if (firstTime) {
        firstTime = false;
        return Presentation(
          onDone: session.user.isActive == true ? Home() : Onboarding(),
        );
      } else {
        return session.user.isActive == true ? Home() : Onboarding();
      }
    } else {
      return firstTime
          ? Presentation(
              onDone: Welcome(),
            )
          : Welcome();
    }
  }

  Future<void> _retrieveDynamicLink(BuildContext context) async {
    final PendingDynamicLinkData data =
        await FirebaseDynamicLinks.instance.retrieveDynamicLink();
    final Uri deepLink = data?.link;
    if (null != deepLink && null != deepLink.queryParameters['token']) {
      print(deepLink.queryParameters['token']);
      final Map<String, dynamic> data = await api.request(
          cmd: 'login',
          params: {'magic_token': deepLink.queryParameters['token']});

      if (null != data['token']) {
        await Session.set(data);
        Session.setRequest('');
        restartApp();
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    checkRequest(context);
    return MaterialApp(
        key: _key,
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
        home: _getHome());
  }
}
