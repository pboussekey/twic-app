import 'package:twic_app/api/models/user.dart';
import 'abstract_model.dart';
import 'twic_file.dart';

class Post extends AbstractModel{
  int id;
  String content;
  DateTime createdAt;
  int nbComments;
  int nbLikes;
  bool isLiked;
  User user;
  List<TwicFile> files = [];


  Post.fromJson(Map<String, dynamic> data) {
    id = data['id'];
    content = data['content'];
    nbComments = data['nbComments'];
    nbLikes = data['nbLikes'];
    isLiked = data['isLiked'] == 1;
    if(null != data['createdAt']){
      createdAt = DateTime.parse(data['createdAt']).toLocal();
    }
    if (null != data['user']) {
      user = User.fromJson(data['user']);
    }
    if(null != data['files']){
      data['files'].forEach((file) => this.files.add(TwicFile.fromJson(file)));
    }
  }
}
