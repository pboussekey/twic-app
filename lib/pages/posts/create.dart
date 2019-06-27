import 'package:flutter/material.dart';

import 'package:twic_app/style/style.dart';

import '../root_page.dart';
import 'package:twic_app/shared/form/form.dart';
import 'package:twic_app/api/services/upload_service.dart' as upload_service;
import 'package:image_picker/image_picker.dart';
import 'package:file_picker/file_picker.dart';
import 'package:twic_app/api/models/models.dart';
import 'package:twic_app/shared/file/create_file_preview.dart';
import 'package:twic_app/api/services/posts.dart';
import 'package:twic_app/pages/home.dart';
import 'package:twic_app/style/twic_font_icons.dart';
import 'package:twic_app/shared/users/userlist.dart';
import 'package:twic_app/shared/hashtags/hashtaglist.dart';
import 'dart:math';
import 'dart:io';

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
  List<Hashtag> hashtags = [];
  List<User> mentions = [];
  TextEditingController _controller;
  bool uploading = false;
  bool mentionning = false;
  bool searching = false;
  int searchIndex;
  int line = 1;
  String search;
  UniqueKey _searchingKey = UniqueKey();

  void _listener() => setState(() {
        int i = max(_controller.selection.start, 0);
        if (content.isEmpty || (null != searchIndex && i < searchIndex)) {
          searching = false;
          mentionning = false;
          searchIndex = null;
        }

        if (searching || mentionning) {
          search = _controller.text.substring(searchIndex, i);
          _searchingKey = UniqueKey();
        }
        int changeLength = _controller.text.length - content.length;
        content = _controller.text;
        if (changeLength != 1) return;

        if (content.isEmpty) return;
        line = (i <= _controller.text.length
                ? '\n'.allMatches(_controller.text.substring(0, i)).length
                : 0) +
            1;
        String lastChar = _controller.text.substring(i - 1, i);
        if ("@" == lastChar) {
          searching = false;
          mentionning = true;
          searchIndex = i;
        } else if ("#" == lastChar) {
          searching = true;
          mentionning = false;
          searchIndex = i;
        }
      });

  CreatePostState({this.privacy, this.content, this.files}) {
    _controller = TextEditingController(text: content);
    _controller.addListener(_listener);
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
        rows.add(Row(children: row));
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
    Size mediaSize = MediaQuery.of(context).size;
    return RootPage(
      builder: () => Stack(children: [
            Container(height: mediaSize.height - 40),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Padding(
                    padding: EdgeInsets.only(left: 6.0, right: 10.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        IconButton(
                            icon: Icon(Icons.clear, color: Style.lightGrey),
                            onPressed: () => Navigator.pop(context)),
                        content.isEmpty && files.length == 0
                            ? Container()
                            : Padding(
                                padding: EdgeInsets.only(
                                    top: 5, bottom: 5, right: 10),
                                child: Posts.create(
                                    builder: (RunMutation runMutation,
                                            QueryResult result) =>
                                        Button(
                                          text: "Post",
                                          onPressed: () {
                                            runMutation({
                                              'content': content,
                                              'privacy': privacy,
                                              'mentions': mentions
                                                  .where((User user) =>
                                                      content.indexOf(
                                                          "@${user.firstname}${user.lastname}") >=
                                                      0)
                                                  .map((User user) => user.id)
                                                  .toList(),
                                              'files': files
                                                  .map((TwicFile f) =>
                                                      f.toJson())
                                                  .toList()
                                            });
                                          },
                                        ),
                                    onCompleted: (dynamic result) =>
                                        Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                                builder:
                                                    (BuildContext context) =>
                                                        Home())))),
                      ],
                    )),
                Padding(
                    padding: EdgeInsets.symmetric(horizontal: 20),
                    child: Text(
                      "Create a post",
                      style: Style.titleStyle,
                      textAlign: TextAlign.start,
                    )),
                Padding(
                  padding: EdgeInsets.all(20.0),
                  child: Column(
                    children: <Widget>[
                      Dropdown<String>(
                        shadow: [],
                        size: mediaSize.width - 40,
                        background: Colors.white,
                        border: Border.all(
                            color: Style.border,
                            width: 1,
                            style: BorderStyle.solid),
                        items: [
                          DropdownMenuItem(
                            child: Container(
                                width: mediaSize.width - 40,
                                color: Colors.white,
                                child: Row(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: <Widget>[
                                    Container(
                                        width: 30,
                                        height: 30,
                                        padding: EdgeInsets.all(5),
                                        decoration: BoxDecoration(
                                            color: Style.veryLightGrey,
                                            borderRadius: BorderRadius.all(
                                                Radius.circular(6))),
                                        child: Icon(
                                          TwicFont.eye,
                                          color: privacy == "PUBLIC"
                                              ? Style.mainColor
                                              : Style.lightGrey,
                                          size: 18,
                                        )),
                                    SizedBox(
                                      width: 10.0,
                                    ),
                                    Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: <Widget>[
                                        Text(
                                          "Public Post",
                                          style: Style.largeText,
                                        ),
                                        Text(
                                          "Everyone can view this post",
                                          style: Style.smallGreyText,
                                        ),
                                      ],
                                    )
                                  ],
                                )),
                            value: "PUBLIC",
                          ),
                          DropdownMenuItem(
                            child: Container(
                                color: Colors.white,
                                child: Row(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: <Widget>[
                                    Container(
                                        width: 30,
                                        height: 30,
                                        padding: EdgeInsets.all(5),
                                        decoration: BoxDecoration(
                                            color: Style.veryLightGrey,
                                            borderRadius: BorderRadius.all(
                                                Radius.circular(6))),
                                        child: Icon(
                                          TwicFont.private,
                                          color: privacy == "PRIVATE"
                                              ? Style.mainColor
                                              : Style.lightGrey,
                                          size: 18,
                                        )),
                                    SizedBox(
                                      width: 10.0,
                                    ),
                                    Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: <Widget>[
                                        Text(
                                          "Private",
                                          style: Style.largeText,
                                        ),
                                        Text(
                                          "Only people I tag can see this post",
                                          style: Style.smallGreyText,
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
            ),
            searching || mentionning
                ? Positioned(
                    top: 200.0 + line * 20.0,
                    left: 40,
                    right: 40,
                    height: 500,
                    child: mentionning
                        ? Container(
                            color: Colors.white,
                            child: UserList(
                              key: _searchingKey,
                              search: search,
                              renderAction: (User user) => Container(),
                              onClick: (User user) {
                                int i = searchIndex;
                                _controller.text = _controller.text
                                    .replaceFirst(
                                        new RegExp(r'@' + search),
                                        "@${user.firstname}${user.lastname} ",
                                        i - 1);
                                i += user.firstname.length +
                                    user.lastname.length +
                                    1;
                                _controller.selection = TextSelection(
                                    baseOffset: i, extentOffset: i);
                                searchIndex = null;
                                mentionning = false;
                                searching = false;
                                if (!mentions.contains(user)) {
                                  mentions.add(user);
                                }
                              },
                            ))
                        : Container(
                            color: Colors.white,
                            child: HashtagList(
                              key: _searchingKey,
                              search: search,
                              renderAction: (Hashtag hashtag) => Container(),
                              onClick: (Hashtag hashtag) {
                                int i = searchIndex;
                                _controller.text = _controller.text
                                    .replaceFirst(new RegExp(r'#' + search),
                                        "#${hashtag.name} ", i - 1);
                                i += hashtag.name.length + 1;
                                _controller.selection = TextSelection(
                                    baseOffset: i, extentOffset: i);
                                searchIndex = null;
                                mentionning = false;
                                searching = false;
                                if (!hashtags.contains(hashtag)) {
                                  hashtags.add(hashtag);
                                }
                              },
                            )))
                : Container()
          ]),
      bottomBar: Container(
          color: Colors.white,
          child: Padding(
              padding: EdgeInsets.symmetric(vertical: 10.0, horizontal: 20.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: <Widget>[
                  Button(
                    background: Style.mainColor.withAlpha(40),
                    radius: BorderRadius.all(Radius.circular(25.0)),
                    padding: EdgeInsets.only(right: 4),
                    width: 50.0,
                    child: Icon(
                      TwicFont.dessin,
                      size: 14.0,
                      color: Style.mainColor,
                    ),
                    onPressed: () => ImagePicker.pickImage(
                                source: ImageSource.camera,
                                maxHeight: 480,
                                maxWidth: 640)
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
                    radius: BorderRadius.all(Radius.circular(25.0)),
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
                                print(["UPLOADED", fileData]);
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
                    radius: BorderRadius.all(Radius.circular(25.0)),
                    padding: EdgeInsets.all(0),
                    width: 50.0,
                    child: Icon(
                      TwicFont.library_icon,
                      size: 15.0,
                      color: Style.genZGreen,
                    ),
                    onPressed: () => FilePicker.getFilePath(type: FileType.ANY)
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
              ))),
    );
  }
}
