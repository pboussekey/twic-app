import 'abstract_model.dart';
import 'package:twic_app/api/models/user.dart';

class Conversation extends AbstractModel {
  int id;
  String name;
  String last;
  List<User> users = [];
  DateTime lastDate;

  Conversation.fromJson(Map<String, dynamic> data) {
    id = data['id'] is int ? data['id'] : int.parse(data['id']);
    name = data['name'];
    last = data['last'];
    if(null != data['lastDate']){
      lastDate = DateTime.parse(data['lastDate']);
    }
    if(null != data['users']){
      data['users'].forEach((user) => users.add(User.fromJson(user)));
    }
  }
}
