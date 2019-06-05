import 'package:twic_app/api/models/user.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import 'dart:async';


class Session{

  static Session instance;
  static void set(Map<String, dynamic> data) async{
      final SharedPreferences prefs = await SharedPreferences.getInstance();
      await prefs.setString('session', json.encode(data));
      Session.instance = await Session.init();
  }

  static Future<bool> isFirstTime() async{
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    bool firstTime = prefs.getBool('firstTime');
    prefs.setBool('firstTime', true);
    return firstTime != true;
  }

  static Future<void> setRequest(String requestToken) async{
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString('requestToken', requestToken);
  }


  static Future<String> getRequest() async{
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString('requestToken');
  }


  static void update(Map<String, dynamic> data){
    Map<String, dynamic> session = Session.instance.toJson();
    session['user'].addAll(data);
    Session.instance = Session.fromJson(session);
    Session.set(session);
  }

  static Future<Session> init() async{
    if(null == Session.instance) {
      final SharedPreferences prefs = await SharedPreferences.getInstance();
      String _session = prefs.getString('session');
      if (null != _session) {
        Session.instance = Session.fromJson(json.decode(_session));
        return Session.instance;
      }
    }
    return Session.instance;

  }

  User user;
  String token;
  String fbtoken;

  Session.fromJson(Map<String, dynamic> data){
      this.token = data['token'];
      this.fbtoken = data['fbtoken'];
      this.user = User.fromJson(data['user']);
  }


  Map<String, dynamic> toJson() => {
    'token': token,
    'fbtoken': fbtoken,
    'user': user.toJson()
  };
}
