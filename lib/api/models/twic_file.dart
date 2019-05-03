import 'abstract_model.dart';

class TwicFile extends AbstractModel{
  int id;
  String name;
  String bucketname;
  String token;

  TwicFile.fromJson(Map<String, dynamic> data) {
    id = data['id'];
    name = data['name'];
    bucketname = data['bucketname'];
    token = data['token'];
  }


  Map<String, dynamic> toJson() => {'id': id, 'name': name, 'bucketname': bucketname, 'token' : token};

  String href(){
    return 'https://firebasestorage.googleapis.com/v0/b/twicfiles-ccf31.appspot.com/o/${bucketname}?alt=media&token=' +token;
  }
}
