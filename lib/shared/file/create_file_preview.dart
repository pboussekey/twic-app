import 'package:flutter/material.dart';
import 'package:twic_app/api/models/models.dart';
import 'package:twic_app/style/style.dart';
import 'package:twic_app/shared/components/round_picture.dart';

class CreateFilePreview extends StatelessWidget {
  final TwicFile file;

  CreateFilePreview({this.file});

  @override
  Widget build(BuildContext context) {
    Size mediaSize = MediaQuery.of(context).size;
    Widget content;
    if (null == file.type || file.type.startsWith('image/')) {
      content = RoundPicture(
        picture : file.href(),
        radius: 6,
        fit: BoxFit.fitWidth,
      );
    }
    else{
      content = Icon(Icons.insert_drive_file, color : Style.genZBlue, size:  mediaSize.width / 3 - 40,);
    }

    return Container(
      child: content,
      alignment: Alignment(0, 0),
      width: mediaSize.width / 3 - 40,
      decoration:
          BoxDecoration(borderRadius: BorderRadius.all(Radius.circular(6))),
    );
  }
}
