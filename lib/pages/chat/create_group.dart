import 'package:flutter/material.dart';
import 'package:twic_app/pages/root_page.dart';
import 'package:twic_app/style/style.dart';
import 'package:twic_app/shared/form/form.dart';
import 'package:twic_app/api/models/models.dart';
import 'package:twic_app/pages/chat/conversation.dart';
import 'package:twic_app/api/services/conversations.dart';
import 'package:twic_app/shared/components/round_picture.dart';
import 'package:twic_app/shared/users/avatar.dart';
import 'package:twic_app/api/services/upload_service.dart' as upload_service;
import 'package:image_picker/image_picker.dart';
import 'dart:io';

class CreateGroup extends StatefulWidget {
  final List<User> users;

  CreateGroup({this.users});

  @override
  State<StatefulWidget> createState() => CreateGroupState();
}

class CreateGroupState extends State<CreateGroup> {
  String name = "";
  TwicFile picture;
  TextEditingController _nameController = TextEditingController();
  bool uploading = false;
  bool creating = false;

  @override
  void initState() {
    super.initState();
    _nameController.addListener(() => setState(() {
          name = _nameController.text;
        }));
  }

  @override
  Widget build(BuildContext context) {
    Size mediaSize = MediaQuery.of(context).size;
    return Scaffold(
        body: RootPage(
            child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      height: 80,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          IconButton(
                              icon: Icon(
                                Icons.arrow_back,
                                color: Style.lightGrey,
                              ),
                              onPressed: () => Navigator.pop(context)),
                          SizedBox(
                            width: 40,
                          ),
                          Text("New Group", style: Style.largeText),
                          Conversations.create(
                              onCompleted: (dynamic data) {
                                creating = false;
                                if (null != data) {
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (BuildContext context) =>
                                              ConversationPage(
                                                conversation:
                                                    Conversation.fromJson(data[
                                                        'addConversation']),
                                              )));
                                }
                              },
                              builder: (RunMutation create,
                                      QueryResult result) =>
                                  Padding(
                                    child: !creating
                                        ? Button(
                                            text: 'Create',
                                            height: 40,
                                            width: 90,
                                            disabled: name.isEmpty || uploading,
                                            onPressed: () {
                                              if (creating) return;
                                              setState(() {
                                                creating = true;
                                              });
                                              create({
                                                'name': name,
                                                'users': widget.users
                                                    .map((User u) => u.id)
                                                    .toList(),
                                                'picture': picture?.toJson()
                                              });
                                            })
                                        : Container(
                                            width: 90,
                                            alignment: Alignment(0, 0),
                                            child: CircularProgressIndicator()),
                                    padding: EdgeInsets.symmetric(
                                        vertical: 10, horizontal: 20),
                                  ))
                        ],
                      ),
                    ),
                    Input(
                        controller: _nameController,
                        before: !uploading
                            ? Button(
                                height: 35,
                                width: 35,
                                padding: EdgeInsets.all(0),
                                child: null == picture
                                    ? Icon(
                                        Icons.camera_alt,
                                        color: Colors.white,
                                      )
                                    : RoundPicture(
                                        height: 35,
                                        width: 35,
                                        radius: 17.5,
                                        fit: BoxFit.cover,
                                        picture: picture.href(),
                                      ),
                                onPressed: () => ImagePicker.pickImage(
                                            source: ImageSource.camera)
                                        .then((File file) {
                                      if (null != file) {
                                        setState(() {
                                          uploading = true;
                                        });
                                        upload_service.upload(file: file).then(
                                            (Map<String, dynamic> fileData) {
                                          setState(() {
                                            uploading = false;
                                            picture =
                                                TwicFile.fromJson(fileData);
                                          });
                                        });
                                      }
                                    }))
                            : CircularProgressIndicator()),
                    SizedBox(
                      height: 20,
                    ),
                    Text(
                      '${widget.users.length.toString()} participant${widget.users.length > 1 ? "s" : ""}',
                      textAlign: TextAlign.start,
                      style: Style.text,
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Container(
                        width: mediaSize.width,
                        height: 70,
                        child: ListView.builder(
                          scrollDirection: Axis.horizontal,
                          itemCount: widget.users.length,
                          itemBuilder: (BuildContext context, int index) =>
                              Padding(
                                  padding: EdgeInsets.only(right: 10),
                                  child: Column(children: <Widget>[
                                    Avatar(
                                      size: 50,
                                      href: widget.users[index].avatar?.href(),
                                    ),
                                    Text(widget.users[index].firstname,
                                        style: Style.smallLightText)
                                  ])),
                        ))
                  ],
                ))));
  }
}
