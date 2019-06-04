import 'dart:convert';
import 'dart:async';
import 'package:http/http.dart' as http;
import 'package:twic_app/api/session.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

Future<Map<String, dynamic>> request(
    {String cmd, Map<String, dynamic> params = const {}}) async {
  Map<String, String> headers = {'content-type': 'application/json'};
  Session session = Session.instance;
  if (null != session) {
    headers["Authorization"] = "Bearer ${session.token}";
  }
  http.Response response = await http.post("${DotEnv().env['API_URL']}/" + cmd,
      headers: headers, body: json.encode(params));
  Map<String, dynamic> data = json.decode(response.body);
  return data;
}

