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
import 'package:twic_app/api/services/schools.dart';
import 'package:twic_app/api/services/fields.dart';
import 'package:twic_app/api/services/users.dart';

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
  bool saving = false;
  bool avatarChanged = false;

  TextEditingController firstnameController =
      TextEditingController(text: Session.instance.user.firstname);
  TextEditingController lastnameController =
      TextEditingController(text: Session.instance.user.lastname);
  TextEditingController descriptionController =
      TextEditingController(text: Session.instance.user.description);
  TextEditingController classYearController =
      TextEditingController(text: Session.instance.user.classYear.toString());

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    Size mediaSize = MediaQuery.of(context).size;
    return Scaffold(
        body: RootPage(
            scrollable: false,
            child: GestureDetector(
                onTap: () {
                  FocusScope.of(context).requestFocus((FocusNode()));
                },
                child: Stack(children: [
                  SingleChildScrollView(
                      child: Container(
                    width: mediaSize.width,
                    padding: EdgeInsets.only(
                        left: 10, right: 10, top: 70, bottom: 20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Center(
                            child: Button(
                          background: Colors.transparent,
                          child: Column(
                            children: <Widget>[
                              !uploading
                                  ? Avatar(
                                      href: avatar?.href(),
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
                        SizedBox(
                          height: 10,
                        ),
                        Padding(
                            padding: EdgeInsets.symmetric(horizontal: 20),
                            child: Form(
                                key: _formKey,
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: <Widget>[
                                    Text(
                                      "Personal",
                                      style: Style.titleStyle,
                                      textAlign: TextAlign.start,
                                    ),
                                    SizedBox(
                                      height: 10,
                                    ),
                                    Input(
                                      label: "Firstname",
                                      controller: firstnameController,
                                      shadow: false,
                                      height: 60,
                                      color: Style.veryLightGrey,
                                      onSaved: (String value) =>
                                          firstname = value,
                                    ),
                                    SizedBox(
                                      height: 10,
                                    ),
                                    Input(
                                      label: "Lastname",
                                      shadow: false,
                                      controller: lastnameController,
                                      color: Style.veryLightGrey,
                                      onSaved: (String value) =>
                                          lastname = value,
                                    ),
                                    SizedBox(
                                      height: 10,
                                    ),
                                    Textarea(
                                      label: "Bio",
                                      controller: descriptionController,
                                      color: Style.veryLightGrey,
                                      onSaved: (String value) =>
                                          description = value,
                                    ),
                                    SizedBox(
                                      height: 10,
                                    ),
                                    Text(
                                      "Education",
                                      style: Style.titleStyle,
                                      textAlign: TextAlign.start,
                                    ),
                                    SizedBox(
                                      height: null !=
                                              Session.instance.user.university
                                          ? 10
                                          : 0,
                                    ),
                                    null != Session.instance.user.university
                                        ? Schools.getList(
                                            university_id: Session
                                                .instance.user.university.id,
                                            degree:
                                                Session.instance.user.degree,
                                            builder: (List<School> schools) =>
                                                schools.length > 0
                                                    ? Dropdown<School>(
                                                        value: Session.instance
                                                            .user.school,
                                                        size: double.maxFinite,
                                                        label: 'UNDERGRADUATE' ==
                                                                Session.instance
                                                                    .user.degree
                                                            ? "Residential college"
                                                            : "Graduate school",
                                                        items: schools
                                                            .map<
                                                                    DropdownMenuItem<
                                                                        School>>(
                                                                (School value) =>
                                                                    DropdownMenuItem(
                                                                      child: Text(
                                                                          value
                                                                              .name),
                                                                      value:
                                                                          value,
                                                                    ))
                                                            .toList(),
                                                        onChanged: (School s) =>
                                                            setState(() {
                                                              school = s;
                                                            }),
                                                      )
                                                    : CircularProgressIndicator())
                                        : Container(),
                                    'UNDERGRADUATE' ==
                                            Session.instance.user.degree
                                        ? Fields.getList(
                                            builder:
                                                (List<Field> fields) => Column(
                                                      children: <Widget>[
                                                        SizedBox(
                                                          height: 10,
                                                        ),
                                                        Dropdown<Field>(
                                                          value: major,
                                                          size:
                                                              double.maxFinite,
                                                          label: 'Major',
                                                          items: fields
                                                              .map<
                                                                      DropdownMenuItem<
                                                                          Field>>(
                                                                  (Field value) =>
                                                                      DropdownMenuItem(
                                                                        child: Text(
                                                                            value.name),
                                                                        value:
                                                                            value,
                                                                      ))
                                                              .toList(),
                                                          onChanged:
                                                              (Field f) =>
                                                                  setState(() {
                                                                    major = f;
                                                                  }),
                                                        ),
                                                        SizedBox(
                                                          height: 10,
                                                        ),
                                                        Dropdown<Field>(
                                                          value: minor,
                                                          size:
                                                              double.maxFinite,
                                                          label: 'Minor',
                                                          items: fields
                                                              .map<
                                                                      DropdownMenuItem<
                                                                          Field>>(
                                                                  (Field value) =>
                                                                      DropdownMenuItem(
                                                                        child: Text(
                                                                            value.name),
                                                                        value:
                                                                            value,
                                                                      ))
                                                              .toList(),
                                                          onChanged:
                                                              (Field f) =>
                                                                  setState(() {
                                                                    minor = f;
                                                                  }),
                                                        )
                                                      ],
                                                    ))
                                        : Container(),
                                    SizedBox(
                                      height: 10,
                                    ),
                                    Input(
                                      label: "Year of graduation",
                                      controller: classYearController,
                                      shadow: false,
                                      height: 60,
                                      color: Style.veryLightGrey,
                                      inputType: TextInputType.number,
                                      validator: (String classYear) {
                                        if (!RegExp(r'[1-2][0-9]{3}$')
                                            .hasMatch(classYear)) {
                                          return "Invalid class year";
                                        }
                                      },
                                      onSaved: (String value) =>
                                          classYear = value,
                                    )
                                  ],
                                ))),
                      ],
                    ),
                  )),
                  Container(
                      decoration: BoxDecoration(
                          color: Colors.white,
                          border:
                              Border(bottom: BorderSide(color: Style.border))),
                      child: Flex(direction: Axis.horizontal, children: [
                        IconButton(
                            icon: Icon(
                              Icons.clear,
                              color: Style.lightGrey,
                            ),
                            onPressed: () => Navigator.pop(context)),
                        SizedBox(
                          width: 60,
                        ),
                        Expanded(
                          child: Text(
                            "Edit profile",
                            style: Style.smallTitle,
                            textAlign: TextAlign.center,
                          ),
                        ),
                        Padding(
                            padding: EdgeInsets.all(10),
                            child: Users.update(
                              onCompleted: (dynamic result){
                                print(["RESULT", result]);
                                if(null != result){
                                  Session.update({
                                    'major': major.toJson(),
                                    'minor': minor.toJson(),
                                    'school': school.toJson(),
                                    'avatar': avatar.toJson(),
                                    'classYear': int.parse(classYear),
                                    'firstname': firstname,
                                    'lastname': lastname,
                                    'description': description
                                  });
                                  Navigator.pop(context, {
                                    'major': major.name,
                                    'minor': minor.name,
                                    'school': school.name,
                                    'university':
                                    school.university?.name,
                                    'firstname': firstname,
                                    'lastname': lastname,
                                    'description': description,
                                    'classYear': int.parse(classYear),
                                    'avatar': avatar.href(),
                                    'university_logo':
                                    (school.university ?? school)
                                        .logo.href()
                                  });
                                }
                              },
                                builder: (RunMutation runMutation,
                                        QueryResult result) =>
                                    Button(
                                        width: 80,
                                        height: 40,
                                        disabled: uploading,
                                        text: "Done",
                                        onPressed: () {
                                          if (!saving &&
                                              _formKey.currentState
                                                  .validate()) {
                                            _formKey.currentState.save();
                                            runMutation({
                                              'major_id': major.id,
                                              'minor_id': minor.id,
                                              'school_id': school.id,
                                              'classYear': int.parse(classYear),
                                              'firstname': firstname,
                                              'lastname': lastname,
                                              'avatar': null == avatar.id
                                                  ? avatar.toJson()
                                                  : null,
                                              'description': description
                                            });

                                          }
                                        })))
                      ])),
                  editingPicture
                      ? BottomMenu(
                          actions: [
                            {
                              'text': "From  camera",
                              "onPressed": () => ImagePicker.pickImage(
                                          source: ImageSource.camera)
                                      .then((File file) {
                                    if (null != file) {
                                      setState(() {
                                        uploading = true;
                                        editingPicture = false;
                                      });
                                      upload_service.upload(file: file).then(
                                          (Map<String, dynamic> fileData) {
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
                              "onPressed": () => ImagePicker.pickImage(
                                          source: ImageSource.gallery)
                                      .then((File file) {
                                    if (null != file) {
                                      setState(() => uploading = true);
                                      editingPicture = false;
                                      upload_service.upload(file: file).then(
                                          (Map<String, dynamic> fileData) {
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
                          onCancel: () => setState(() => editingPicture = false),
                        )
                      : Container()
                ]))));
  }
}
