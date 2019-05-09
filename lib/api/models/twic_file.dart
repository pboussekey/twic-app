import 'abstract_model.dart';
import 'package:json_annotation/json_annotation.dart';


part 'twic_file.g.dart';

@JsonSerializable()
class TwicFile extends AbstractModel {
  String name;
  String bucketname;
  String type;
  String token;

  TwicFile({id, this.name, this.bucketname, this.token, this.type}) : super(id : id);

  factory TwicFile.fromJson(Map<String, dynamic> json) => _$TwicFileFromJson(json);
  Map<String, dynamic> toJson() => _$TwicFileToJson(this);

  String href() {
    return 'https://firebasestorage.googleapis.com/v0/b/twicfiles-ccf31.appspot.com/o/${bucketname}?alt=media&token=' +
        token;
  }
}
