import 'abstract_model.dart';
import 'package:twic_app/api/models/user.dart';

class Message extends AbstractModel {
  int id;
  String text;
  User user;
  DateTime createdAt;

  Message.fromJson(Map<String, dynamic> data) {
    id = data['id'] is int ? data['id'] : int.parse(data['id']);
    text = data['text'];
    if(null != data['createdAt']){
      createdAt = DateTime.parse(data['createdAt']).toLocal();
    }
    if (null != data['user']) {
      user = User.fromJson(data['user']);
    }
  }
}
