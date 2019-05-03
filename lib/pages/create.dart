import 'package:flutter/material.dart';

import 'package:twic_app/style/style.dart';

import 'package:twic_app/api/session.dart';
import 'root_page.dart';
import 'package:twic_app/shared/form/dropdown.dart';
import 'package:twic_app/shared/form/textarea.dart';
import 'package:twic_app/shared/form/button.dart';
import 'package:twic_app/api/services/upload_service.dart' as upload_service;
import 'package:image_picker/image_picker.dart';
import 'package:twic_app/api/models/twic_file.dart';
import 'dart:io';

class Create extends StatefulWidget {
  String privacy = "PUBLIC";

  @override
  State createState() => CreateState();
}

class CreateState extends State<Create> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.white,
          centerTitle: true,
          elevation: 0,
          leading: IconButton(
              icon: Icon(Icons.clear, color: Style.grey),
              onPressed: () => Navigator.pop(context)),
        ),
        body: RootPage(
            child: Column(
          children: <Widget>[
            Text("Create a post", style: Style.titleStyle),
            Padding(
              padding: EdgeInsets.all(20.0),
              child: Column(
                children: <Widget>[
                  Dropdown<String>(
                    shadow : [],
                    border: Border.all(color: Style.border, width: 1, style: BorderStyle.solid),
                    items: [
                      DropdownMenuItem(
                        child: Container(
                            color: Colors.white,
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
                                  crossAxisAlignment: CrossAxisAlignment.start,
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
                            color: Colors.white,
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
                                  crossAxisAlignment: CrossAxisAlignment.start,
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
                            color: Colors.white,
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
                                  crossAxisAlignment: CrossAxisAlignment.start,
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
                            color: Colors.white,
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
                                  crossAxisAlignment: CrossAxisAlignment.start,
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
                            color: Colors.white,
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
                                  crossAxisAlignment: CrossAxisAlignment.start,
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
                            color: Colors.white,
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
                                  crossAxisAlignment: CrossAxisAlignment.start,
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
                    onChanged: (String value) => widget.privacy = value,
                    value: widget.privacy,
                  ),
                  SizedBox(
                    height: 10.0,
                  ),
                  Textarea(
                    maxLength: 300,
                    color: Style.grey,
                    controller: TextEditingController(),
                  )
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
                      background: Style.purple,
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
                              upload_service
                                  .upload(file: file)
                                  .then((Map<String, dynamic> fileData) {
                                TwicFile ufile = TwicFile.fromJson(fileData);
                              });
                            }
                          }),
                    ),
                    Button(
                      background: Style.genZGreen,
                      radius: 25.0,
                      padding: EdgeInsets.all(0),
                      width: 50.0,
                      child: Icon(
                        Icons.photo_library,
                        size: 24.0,
                        color: Colors.green,
                      ),
                      onPressed: () =>
                          ImagePicker.pickImage(source: ImageSource.gallery)
                              .then((File file) {
                            if (null != file) {
                              upload_service
                                  .upload(file: file)
                                  .then((Map<String, dynamic> fileData) {
                                TwicFile ufile = TwicFile.fromJson(fileData);
                              });
                            }
                          }),
                    ),
                  ],
                ))));
  }
}
