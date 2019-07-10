import 'dart:convert';
import 'dart:async';
import 'package:http/http.dart' as http;
import 'package:twic_app/api/session.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:twic_app/api/services/firebase.dart';
import 'package:twic_app/api/services/users.dart';

class ApiRest {

  static final  FirebaseMessaging _fcm = FirebaseMessaging();
  static Future<void> login({ String magicToken, String requestToken, Function onLogged, Function onError}) async {
    final Map<String, dynamic> data =
        await request(cmd: 'login', params: {'magic_token': magicToken, 'request_token' : requestToken});

    if (null != data['token']) {
      await Session.set(data);
      Session.setRequest('');
      Firebase.instance.requestNotificationPermissions(IosNotificationSettings(
        sound: true,
        alert: true,
        badge: true,
      ));
      _fcm.onIosSettingsRegistered.listen((IosNotificationSettings settings) {
        print('IOS SETTINGS REGISTERED');
      });
      await Users.registerFcmToken(await Firebase.instance.getToken());
      onLogged();
    }
    else if(null != onError){
      onError();
    }
  }

  static Future<Map<String, dynamic>> request(
      {String cmd, Map<String, dynamic> params = const {}}) async {
    Map<String, String> headers = {'content-type': 'application/json'};
    Session session = Session.instance;
    if (null != session) {
      headers["Authorization"] = "Bearer ${session.token}";
    }
    http.Response response = await http.post(
        "${DotEnv().env['API_URL']}/" + cmd,
        headers: headers,
        body: json.encode(params));
    Map<String, dynamic> data = json.decode(response.body);
    return data;
  }
}
