import 'abstract_model.dart';
import 'package:json_annotation/json_annotation.dart';
part 'twic_file.g.dart';

@JsonSerializable()
class TwicFile extends AbstractModel {
  String name;
  String bucketname;
  String type;
  String token;
  TwicFile preview;

  TwicFile({id, this.name, this.bucketname, this.token, this.type})
      : super(id: id);

  factory TwicFile.fromJson(Map<String, dynamic> json) =>
      _$TwicFileFromJson(json);

  Map<String, dynamic> toJson() => _$TwicFileToJson(this);

  String href() {
    return 'https://firebasestorage.googleapis.com/v0/b/twicapp-5d95f.appspot.com/o/${bucketname}?alt=media&token=' +
        token;
  }

  String getPreview() {
    if (type.startsWith('video/') && null != preview) {
      return preview.href();
    }
    if (type.startsWith('image/')) {
      return href();
    }
    Map<String, String> types = {
      'application/vnd.google-apps.document':
          'assets/files/icon-document-googledoc.png',
      'application/vnd.oasis.opendocument.text':
          'assets/files/icon-document-googledoc.png',
      'application/vnd.openxmlformats-officedocument.wordprocessingml.document':
          'assets/files/icon-document-microsoftword.png',
      'application/vnd.google-apps.drawing':
          'assets/files/icon-document-googledrawings.png',
      'application/vnd.google-apps.spreadsheet':
          'assets/files/icon-document-googlesheets.png',
      'application/vnd.oasis.opendocument.spreadsheet':
          'assets/files/icon-document-googlesheets.png',
      'application/vnd.openxmlformats-officedocument.spreadsheetml.sheet':
          'assets/files/icon-document-microsoftexcel.png',
      'application/vnd.ms-excel': 'assets/files/icon-document-microsoftexcel.png',
      'application/vnd.google-apps.presentation':
          'assets/files/icon-document-googleslides.png',
      'application/vnd.oasis.opendocument.presentation':
          'assets/files/icon-document-googleslides.png',
      'application/vnd.openxmlformats-officedocument.presentationml.presentation':
          'assets/files/icon-document-microsoftpowerpoint.png',
      'application/vnd.openxmlformats-officedocument.presentationml.presentation':
          'assets/files/icon-document-microsoftpowerpoint.png',
      'application/vnd.google-apps.form':
          'assets/files/icon-document-googleforms.png',
      'application/pdf': 'assets/files/icon-document-pdf.png'
    };
    if (null != types[type]) {
      return types[type];
    }
    return 'assets/files/icon-document-generic.png';
  }
}
