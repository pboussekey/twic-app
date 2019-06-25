import 'dart:io';
import 'package:mime/mime.dart';
import 'package:http_parser/http_parser.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:async';
import 'package:camera_utils/camera_utils.dart';
import 'package:path_provider/path_provider.dart';



import 'package:twic_app/api/session.dart';
import 'package:twic_app/api/services/api_rest.dart' as api;

String url = "https://us-central1-twicapp-5d95f.cloudfunctions.net/upload";

Future<Map<String, dynamic>> upload({ File file, bool stopOnFailure : false }) async{

  final mimeType = lookupMimeType(file.path).split('/');
  final fileUploadReq = http.MultipartRequest('POST', Uri.parse(url));
  final multipartFile = await http.MultipartFile.fromPath('file', file.path, contentType: MediaType(mimeType[0], mimeType[1]));

  fileUploadReq.files.add(multipartFile);

  Session session = Session.instance;
  fileUploadReq.headers['Authorization'] = 'Bearer ${session.fbtoken}';
  fileUploadReq.headers['user'] = session.user.id.toString();

  try{
    http.StreamedResponse stream = await fileUploadReq.send();
    final response = await http.Response.fromStream(stream);
    Map<String, dynamic> data = json.decode(response.body);
    print(['RESPONSE?', response.statusCode, data]);
    if(response.statusCode != 200 && response.statusCode != 201){
      print(["WRONG STATUS", data["error"]]);
      if(!stopOnFailure && data["error"]["code"] == "auth/invalid-custom-token"){
        print("GET NEW TOKEN");
        Map<String, dynamic> data = await api.request(cmd: 'fbtoken');
        session.fbtoken = data['fbtoken'];
        Session.set(session.toJson());

        return upload(file : file, stopOnFailure:true);
      }
      else{
        return null;
      }
    }
    print(["???",data]);
    if(data['type'].toString().startsWith('video')){
      var appDocDir = await getApplicationDocumentsDirectory();
      print(["!!!",appDocDir.path, file.path]);
      final folderPath = appDocDir.path;
      print(["ALLO?!",folderPath]);
        String thumb = await  CameraUtils.getThumbnail(file.path);
        print(['THUMB', thumb]);
        Map<String, dynamic> preview = await upload(file: File(thumb), stopOnFailure: true);
        data['preview'] = preview;
        print(["preview", preview]);
        return data;
    }
    else{
      return data;
    }


  }
  catch(error){
      return null;
  }
}