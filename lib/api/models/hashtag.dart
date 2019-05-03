import 'abstract_model.dart';
import 'package:twic_app/api/models/twic_file.dart';

class Hashtag extends AbstractModel {
  int id;
  String name;
  int nbfollowers;
  bool followed;
  TwicFile picture;

  Hashtag.fromJson(Map<String, dynamic> data) {
    id = int.parse(data['id']);
    nbfollowers = data['nbfollowers'] ?? 0;
    name = data['name'];
    followed = data['followed'] ?? false;
    if (null != data['picture']) {
      picture = TwicFile.fromJson(data['picture']);
    }
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'followed': followed,
        'nbfollowers': nbfollowers,
        'picture': null != picture ? picture.toJson() : null,
      };
}
