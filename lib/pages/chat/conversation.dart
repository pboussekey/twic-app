import 'package:flutter/material.dart';
import 'package:twic_app/api/services/messages.dart';
import 'package:twic_app/shared/chat/messagelist.dart';
import 'package:twic_app/api/models/conversation.dart';
import 'package:twic_app/api/models/message.dart';
import 'package:twic_app/api/models/user.dart';
import 'package:twic_app/shared/users/avatar.dart';
import '../root_page.dart';
import 'package:twic_app/style/style.dart';
import 'package:twic_app/shared/form/input.dart';
import 'package:twic_app/shared/form/button.dart';
import 'package:twic_app/api/services/upload_service.dart' as upload_service;
import 'package:image_picker/image_picker.dart';
import 'package:file_picker/file_picker.dart';
import 'package:twic_app/api/models/twic_file.dart';
import 'dart:io';
import 'package:twic_app/api/session.dart';

class ConversationPage extends StatefulWidget {
  final Conversation conversation;

  ConversationPage({this.conversation});

  @override
  State<ConversationPage> createState() => ConversationPageState();
}

class ConversationPageState extends State<ConversationPage> {
  List<Message> _messages;
  bool addingFiles = false;
  bool uploading = false;
  TwicFile attachment;

  void onNewMessage(Message message) {
    if(message.user.id == Session.instance.user.id) return;
    _messages.add(message);
  }

  void sendMessage(Map<String, dynamic> params, Function send) {
    send(params);
    params["user"] = Session.instance.user.toJson();
    params["createdAt"] = DateTime.now().toIso8601String();
    onNewMessage(Message.fromJson(params));
  }

  void onFileUpload(File file, Function send) {
    if (null != file) {
      setState(() {
        uploading = true;
        addingFiles = false;
      });
      upload_service.upload(file: file).then((Map<String, dynamic> fileData) {
        setState(() {
          uploading = false;
          TwicFile attachment = TwicFile.fromJson(fileData);

          sendMessage({
            "conversation_id": widget.conversation.id,
            "attachment": attachment.toJson()
          }, send);
        });
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final Size mediaSize = MediaQuery.of(context).size;
    User user = widget.conversation.users[0];
    TextEditingController _controller = TextEditingController();
    return Scaffold(
        body: RootPage(
            child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
          SizedBox(
            height: 20,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Button(
                background: Colors.transparent,
                width: 50.0,
                child: Icon(Icons.arrow_back, color: Style.lightGrey),
                onPressed: () => Navigator.pop(context),
              ),
              widget.conversation.users.length == 1 ? Avatar(
                href: user.avatar?.href(),
              ) : (
                null != widget.conversation.picture ? Avatar(href : widget.conversation.picture.href()) :
                    Container(
                      color : Style.darkGrey,
                      child: Text((widget.conversation.users.length + 1).toString(), style : Style.whiteTitle),
                    )
              ),
              SizedBox(
                width: 50.0,
              )
            ],
          ),
          Text("${user.firstname} ${user.lastname}", style: Style.text),
          SizedBox(
            height: 10.0,
          ),
          Stack(children: [
            Container(
                width: mediaSize.width,
                height: mediaSize.height - 120,
                color: Style.greyBackground,
                padding: EdgeInsets.only(left: 20.0, right: 20.0, top: 0),
                child: Messages.getList(
                    conversation_id: widget.conversation.id,
                    builder: (List<Message> messages) {
                      _messages = messages;
                      return ConversationContent(
                          conversation_id: widget.conversation.id,
                          messages: _messages,
                          onNewMessage: onNewMessage);
                    })),
            Messages.send(
                builder: (RunMutation send, QueryResult result) => Positioned(
                    bottom: 0,
                    left: 0,
                    right: 0,
                    child: Container(
                      height: 70.0,
                      width: mediaSize.width,
                      color: Colors.white,
                      child: Padding(
                        padding: EdgeInsets.only(
                            left: 20.0, right: 20.0, bottom: 10.0, top: 10.0),
                        child: !addingFiles
                            ? Row(children: [
                                !uploading ? Button(
                                        padding: EdgeInsets.all(0),
                                        height: 20,
                                        width: 20,
                                        child: Icon(
                                          Icons.add,
                                          color: Colors.white,
                                          size: 15,
                                        ),
                                        onPressed: () =>
                                            setState(() => addingFiles = true),
                                        color: Style.genZPurple,
                                      ) : CircularProgressIndicator(),
                                SizedBox(
                                  width: 10,
                                ),
                                Expanded(
                                    child: Input(
                                  placeholder: "Type a message",
                                  color: Style.veryLightGrey,
                                  controller: _controller,
                                  shadow: false,
                                  height: 50,
                                  after: Button(
                                    padding: EdgeInsets.all(0),
                                    width: 50,
                                    background: Style.veryLightGrey,
                                    child: Icon(Icons.arrow_forward,
                                        color: Style.lightGrey),
                                    onPressed: () {
                                      if (_controller.text.isEmpty) return;
                                      sendMessage({
                                        "conversation_id":
                                            widget.conversation.id,
                                        "text": _controller.text
                                      }, send);
                                      _controller.text = "";
                                    },
                                  ),
                                ))
                              ])
                            : Row(
                                children: [
                                  Button(
                                    padding: EdgeInsets.all(0),
                                    height: 20,
                                    width: 20,
                                    child: Icon(
                                      Icons.close,
                                      color: Colors.white,
                                      size: 15,
                                    ),
                                    onPressed: () =>
                                        setState(() => addingFiles = false),
                                    background: Style.lightGrey,
                                  ),
                                  SizedBox(
                                    width: 10,
                                  ),
                                  Button(
                                    background: Style.genZPurple.withAlpha(40),
                                    radius:
                                        BorderRadius.all(Radius.circular(25.0)),
                                    padding: EdgeInsets.all(0),
                                    width: 50.0,
                                    child: Icon(
                                      Icons.camera_alt,
                                      size: 24.0,
                                      color: Style.genZPurple,
                                    ),
                                    onPressed: () => ImagePicker.pickImage(
                                            source: ImageSource.camera)
                                        .then((File file) =>
                                            onFileUpload(file, send)),
                                  ),
                                  SizedBox(
                                    width: 10,
                                  ),
                                  Button(
                                    background: Style.genZYellow.withAlpha(40),
                                    radius:
                                        BorderRadius.all(Radius.circular(25.0)),
                                    padding: EdgeInsets.all(0),
                                    width: 50.0,
                                    child: Icon(
                                      Icons.play_arrow,
                                      size: 24.0,
                                      color: Style.genZYellow,
                                    ),
                                    onPressed: () => ImagePicker.pickVideo(
                                                source: ImageSource.camera)
                                        .then((File file) =>
                                        onFileUpload(file, send)),
                                  ),
                                  SizedBox(
                                    width: 10,
                                  ),
                                  Button(
                                    background: Style.genZGreen.withAlpha(40),
                                    radius:
                                        BorderRadius.all(Radius.circular(25.0)),
                                    padding: EdgeInsets.all(0),
                                    width: 50.0,
                                    child: Icon(
                                      Icons.library_add,
                                      size: 24.0,
                                      color: Style.genZGreen,
                                    ),
                                    onPressed: () => FilePicker.getFilePath(
                                                type: FileType.ANY)
                                            .then((String path) {
                                          File file = File(path);
                                          onFileUpload(file, send);
                                        }),
                                  )
                                ],
                              ),
                      ),
                    )))
          ])
        ])));
  }
}

class ConversationContent extends StatefulWidget {
  final int conversation_id;
  final List<Message> messages;
  final Function onNewMessage;

  ConversationContent({this.conversation_id, this.messages, this.onNewMessage});

  @override
  State<StatefulWidget> createState() => ConversationContentState();
}

class ConversationContentState extends State<ConversationContent> {
  @override
  Widget build(BuildContext context) {
    return Messages.onMessage(
        conversation_id: widget.conversation_id,
        builder: ({
          dynamic error,
          bool loading,
          dynamic payload,
        }) {
          if (null != payload && !loading) {
            widget.onNewMessage(Message.fromJson(payload['onMessage']));
          }
          return MessageList(list: widget.messages);
        });
  }
}
