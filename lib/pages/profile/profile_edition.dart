import 'package:flutter/material.dart';
import 'package:twic_app/pages/root_page.dart';
import 'package:twic_app/style/style.dart';
import 'package:twic_app/api/session.dart';
import 'package:twic_app/api/models/school.dart';
import 'package:twic_app/api/models/field.dart';
import 'package:twic_app/api/services/upload_service.dart' as upload_service;
import 'package:image_picker/image_picker.dart';
import 'package:twic_app/api/models/twic_file.dart';
import 'dart:io';
import 'package:twic_app/shared/form/button.dart';
import 'package:twic_app/shared/form/textarea.dart';
import 'package:twic_app/shared/form/input.dart';
import 'package:twic_app/shared/form/dropdown.dart';
import 'package:twic_app/shared/users/avatar.dart';
import 'package:twic_app/shared/components/bottom_menu.dart';

class ProfileEdition extends StatefulWidget {
  @override
  ProfileEditionState createState() => ProfileEditionState();
}

class ProfileEditionState extends State<ProfileEdition> {
  String firstname = Session.instance.user.firstname;
  String lastname = Session.instance.user.lastname;
  String description = Session.instance.user.description;
  School school = Session.instance.user.school;
  Field major = Session.instance.user.major;
  Field minor = Session.instance.user.minor;
  TwicFile avatar = Session.instance.user.avatar;
  String classYear = Session.instance.user.classYear.toString();
  bool editingPicture = false;
  bool uploading = false;

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    Size mediaSize = MediaQuery.of(context).size;
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.white,
          elevation: 1,
          leading: IconButton(
              icon: Icon(
                Icons.clear,
                color: Style.lightGrey,
              ),
              onPressed: () => Navigator.pop(context)),
          title: Text(
            "Edit profile",
            style: Style.smallTitle,
            textAlign: TextAlign.center,
          ),
          centerTitle: true,
          actions: <Widget>[
            Padding(padding: EdgeInsets.all(10), child: Button(text: "Done"))
          ],
        ),
        body: RootPage(
          scrollable: false,
          child: Stack(
            children: [
              SingleChildScrollView(
                  child: Container(
                      width: mediaSize.width,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          SizedBox(
                            height: 10,
                          ),
                          Center(
                              child: Button(
                            background: Colors.transparent,
                            child: Column(
                              children: <Widget>[
                                !uploading
                                    ? Avatar(
                                        file: avatar,
                                        size: 80,
                                      )
                                    : CircularProgressIndicator(),
                                SizedBox(
                                  height: 10,
                                ),
                                Text("Update", style: Style.smallLightText)
                              ],
                            ),
                            onPressed: () =>
                                setState(() => editingPicture = true),
                          )),
                          SizedBox(height: 10,),
                          Padding(
                              padding: EdgeInsets.symmetric(horizontal: 20),
                              child : Form(
                            key: _formKey,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                Text("Personal", style: Style.titleStyle, textAlign: TextAlign.start,),
                                SizedBox(height: 10,),
                                Input(
                                  label: "Firstname",
                                  controller: TextEditingController(text: firstname),
                                  shadow: false,
                                  height: 60,
                                  color: Style.veryLightGrey,
                                  onSaved: (String value) => firstname = value,
                                ),
                                SizedBox(height: 10,),
                                Input(
                                  label: "Lastname",
                                  shadow: false,
                                  controller: TextEditingController(text: lastname),
                                  color: Style.veryLightGrey,
                                  onSaved: (String value) => lastname = value,
                                )
                              ],
                            ),
                          ))
                        ],
                      ))),
              editingPicture
                  ? BottomMenu(
                      actions: [
                        {
                          'text': "From  camera",
                          "onPressed": () =>
                              ImagePicker.pickImage(source: ImageSource.camera)
                                  .then((File file) {
                                if (null != file) {
                                  setState(() {
                                    uploading = true;
                                    editingPicture = false;
                                  });
                                  upload_service
                                      .upload(file: file)
                                      .then((Map<String, dynamic> fileData) {
                                    setState(() {
                                      uploading = false;
                                      editingPicture = false;
                                      avatar = TwicFile.fromJson(fileData);
                                    });
                                  });
                                }
                              }),
                        },
                        {
                          'text': "From  gallery",
                          "onPressed": () =>
                              ImagePicker.pickImage(source: ImageSource.gallery)
                                  .then((File file) {
                                if (null != file) {
                                  setState(() => uploading = true);
                                  editingPicture = false;
                                  upload_service
                                      .upload(file: file)
                                      .then((Map<String, dynamic> fileData) {
                                    setState(() {
                                      uploading = false;
                                      editingPicture = false;
                                      avatar = TwicFile.fromJson(fileData);
                                    });
                                  });
                                }
                              }),
                        }
                      ],
                      onCancel: () => editingPicture = false,
                    )
                  : Container()
            ],
          ),
        ));
  }
}
