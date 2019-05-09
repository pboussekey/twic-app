import 'package:flutter/material.dart';

import 'package:twic_app/style/style.dart';

import 'package:twic_app/api/session.dart';
import '../root_page.dart';
import 'package:twic_app/shared/form/dropdown.dart';
import 'package:twic_app/shared/form/textarea.dart';
import 'package:twic_app/api/models/post.dart';
import 'package:twic_app/shared/form/button.dart';
import 'package:twic_app/api/services/upload_service.dart' as upload_service;
import 'package:image_picker/image_picker.dart';
import 'package:file_picker/file_picker.dart';
import 'package:twic_app/api/models/twic_file.dart';
import 'package:twic_app/shared/file/create_file_preview.dart';
import 'package:twic_app/api/services/posts.dart';
import 'package:twic_app/pages/home.dart';
import 'dart:io';
import 'package:share/share.dart';

class CreatePost extends StatefulWidget {
  final String share;

  CreatePost({this.share});

  @override
  State createState() =>
      CreatePostState(privacy: "PUBLIC", content: share ?? "", files: []);
}

class CreatePostState extends State<CreatePost> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  String privacy;
  String content;
  List<TwicFile> files;
  TextEditingController _controller;
  bool uploading = false;

  CreatePostState({this.privacy, this.content, this.files}) {
    _controller = TextEditingController(text: content);
    _controller.addListener(() => setState(() => content = _controller.text));
  }

  Widget _renderFiles() {
    List<Widget> rows = [];
    List<Widget> row = [];
    int index = 0;
    files.forEach((TwicFile file) {
      row.add(Stack(children: [
        Container(
            padding: EdgeInsets.only(top: 15, left: 15, right: 10),
            child: CreateFilePreview(file: file)),
        Button(
          color: Style.border,
          border: Border.all(color: Style.border),
          height: 30,
          width: 30,
          background: Colors.white,
          padding: EdgeInsets.all(0),
          child: Icon(Icons.close, color: Style.border),
          onPressed: () => setState(() => files.remove(file)),
        )
      ]));
      //files.add(Container(height: 20, width: 20, color : Colors.red));
      if (row.length == 3 || index == files.length - 1) {
        rows.add(Row(
            children: row));
        row = [];
      }
      index++;
    });
    if (uploading) {
      row.add(Container(
          padding: EdgeInsets.all(15.0), child: CircularProgressIndicator()));
      if (row.length == 1) {
        rows.add(Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween, children: row));
      }
    }
    return Column(
      children: rows,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: RootPage(
            builder: () => Column(
                  children: <Widget>[
                    Padding(
                        padding: EdgeInsets.only(left: 10.0, right: 10.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            IconButton(
                                icon: Icon(Icons.clear, color: Style.grey),
                                onPressed: () => Navigator.pop(context)),
                            content.isEmpty && files.length == 0
                                ? Container()
                                : Padding(
                                    padding: EdgeInsets.only(
                                        top: 5, bottom: 5, right: 10),
                                    child: Posts.create(
                                        builder: (RunMutation runMutation,
                                                QueryResult result){
                                          print(files.map((TwicFile f) => f.toJson()).toList());
                                            return Button(
                                              text: "Post",
                                              onPressed: () {
                                                runMutation({
                                                  'content': content,
                                                  'privacy': privacy,
                                                  'files': files.map((TwicFile f) => f.toJson()).toList()
                                                });
                                              },
                                            );},
                                        onCompleted: (dynamic result) => Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                                builder:
                                                    (BuildContext context) =>
                                                        Home())))),
                          ],
                        )),
                    Text("Create a post", style: Style.titleStyle),
                    Padding(
                      padding: EdgeInsets.all(20.0),
                      child: Column(
                        children: <Widget>[
                          Dropdown<String>(
                            shadow: [],
                            border: Border.all(
                                color: Style.border,
                                width: 1,
                                style: BorderStyle.solid),
                            items: [
                              DropdownMenuItem(
                                child: Container(
                                    child: Row(
                                  children: <Widget>[
                                    Icon(
                                      Icons.remove_red_eye,
                                      color: Style.grey,
                                    ),
                                    SizedBox(
                                      width: 10.0,
                                    ),
                                    Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: <Widget>[
                                        Text(
                                          "Public Post",
                                          style: Style.text,
                                        ),
                                        Text(
                                          "Everyone can view this post",
                                          style: Style.greyText,
                                        ),
                                      ],
                                    )
                                  ],
                                )),
                                value: "PUBLIC",
                              ),
                              DropdownMenuItem(
                                child: Container(
                                    child: Row(
                                  children: <Widget>[
                                    Icon(
                                      Icons.account_balance,
                                      color: Style.grey,
                                    ),
                                    SizedBox(
                                      width: 10.0,
                                    ),
                                    Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: <Widget>[
                                        Text(
                                          "My University",
                                          style: Style.text,
                                        ),
                                        Text(
                                          "Only members at your university",
                                          style: Style.greyText,
                                        ),
                                      ],
                                    )
                                  ],
                                )),
                                value: "UNIVERSITY",
                              ),
                              DropdownMenuItem(
                                child: Container(
                                    child: Row(
                                  children: <Widget>[
                                    Icon(
                                      Icons.school,
                                      color: Style.grey,
                                    ),
                                    SizedBox(
                                      width: 10.0,
                                    ),
                                    Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: <Widget>[
                                        Text(
                                          "Graduation Year",
                                          style: Style.text,
                                        ),
                                        Text(
                                          "Class of ${Session.instance.user.classYear.toString()} only",
                                          style: Style.greyText,
                                        ),
                                      ],
                                    )
                                  ],
                                )),
                                value: "GRADUATION",
                              ),
                              DropdownMenuItem(
                                child: Container(
                                    child: Row(
                                  children: <Widget>[
                                    Icon(
                                      Icons.star,
                                      color: Style.grey,
                                    ),
                                    SizedBox(
                                      width: 10.0,
                                    ),
                                    Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: <Widget>[
                                        Text(
                                          "My Fellow Peers",
                                          style: Style.text,
                                        ),
                                        Text(
                                          "Users with the same major or minor",
                                          style: Style.greyText,
                                        ),
                                      ],
                                    )
                                  ],
                                )),
                                value: "PEER",
                              ),
                              DropdownMenuItem(
                                child: Container(
                                    child: Row(
                                  children: <Widget>[
                                    Icon(
                                      Icons.language,
                                      color: Style.grey,
                                    ),
                                    SizedBox(
                                      width: 10.0,
                                    ),
                                    Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: <Widget>[
                                        Text(
                                          "Worldwide Peers",
                                          style: Style.text,
                                        ),
                                        Text(
                                          "Everyone from other universities",
                                          style: Style.greyText,
                                        ),
                                      ],
                                    )
                                  ],
                                )),
                                value: "OTHERS",
                              ),
                              DropdownMenuItem(
                                child: Container(
                                    child: Row(
                                  children: <Widget>[
                                    Icon(
                                      Icons.lock,
                                      color: Style.grey,
                                    ),
                                    SizedBox(
                                      width: 10.0,
                                    ),
                                    Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: <Widget>[
                                        Text(
                                          "Private",
                                          style: Style.text,
                                        ),
                                        Text(
                                          "Only people I tag can see this post",
                                          style: Style.greyText,
                                        ),
                                      ],
                                    )
                                  ],
                                )),
                                value: "PRIVATE",
                              ),
                            ],
                            onChanged: (String value) =>
                                setState(() => privacy = value),
                            value: privacy,
                          ),
                          SizedBox(
                            height: 10.0,
                          ),
                          Form(
                              key: _formKey,
                              child: Textarea(
                                  maxLength: 300,
                                  color: Style.veryLightGrey,
                                  controller: _controller)),
                          SizedBox(
                            height: 10,
                          ),
                          _renderFiles()
                        ],
                      ),
                    )
                  ],
                )),
        bottomNavigationBar: Container(
            color: Colors.white,
            child: Padding(
                padding: EdgeInsets.only(top: 10.0, bottom: 10.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: <Widget>[
                    Button(
                      background: Style.genZPurple.withAlpha(40),
                      radius: 25.0,
                      padding: EdgeInsets.all(0),
                      width: 50.0,
                      child: Icon(
                        Icons.camera_alt,
                        size: 24.0,
                        color: Style.genZPurple,
                      ),
                      onPressed: () =>
                          ImagePicker.pickImage(source: ImageSource.camera)
                              .then((File file) {
                            if (null != file) {
                              setState(() => uploading = true);
                              upload_service
                                  .upload(file: file)
                                  .then((Map<String, dynamic> fileData) {
                                setState(() {
                                  uploading = false;
                                  files = List.from(files)
                                    ..add(TwicFile.fromJson(fileData));
                                });
                              });
                            }
                          }),
                    ),
                    Button(
                      background: Style.genZYellow.withAlpha(40),
                      radius: 25.0,
                      padding: EdgeInsets.all(0),
                      width: 50.0,
                      child: Icon(
                        Icons.play_arrow,
                        size: 24.0,
                        color: Style.genZYellow,
                      ),
                      onPressed: () =>
                          ImagePicker.pickVideo(source: ImageSource.camera)
                              .then((File file) {
                            if (null != file) {
                              setState(() => uploading = true);
                              upload_service
                                  .upload(file: file)
                                  .then((Map<String, dynamic> fileData) {
                                setState(() {
                                  uploading = false;
                                  files = List.from(files)
                                    ..add(TwicFile.fromJson(fileData));
                                });
                              });
                            }
                          }),
                    ),
                    Button(
                      background: Style.genZGreen.withAlpha(40),
                      radius: 25.0,
                      padding: EdgeInsets.all(0),
                      width: 50.0,
                      child: Icon(
                        Icons.library_add,
                        size: 24.0,
                        color: Style.genZGreen,
                      ),
                      onPressed: () =>
                          FilePicker.getFilePath(type: FileType.ANY)
                              .then((String path) {
                            File file = File(path);
                            if (null != file) {
                              setState(() => uploading = true);
                              upload_service
                                  .upload(file: file)
                                  .then((Map<String, dynamic> fileData) {
                                setState(() {
                                  uploading = false;
                                  files = List.from(files)
                                    ..add(TwicFile.fromJson(fileData));
                                });
                              });
                            }
                          }),
                    ),
                  ],
                ))));
  }
}
