import 'package:flutter/material.dart';
import 'package:twic_app/api/services/messages.dart';
import 'package:twic_app/shared/chat/messagelist.dart';
import 'package:twic_app/api/models/models.dart';
import 'package:twic_app/shared/users/avatar.dart';
import '../root_page.dart';
import 'package:twic_app/style/style.dart';
import 'package:twic_app/shared/form/form.dart';
import 'package:twic_app/api/services/upload_service.dart' as upload_service;
import 'package:image_picker/image_picker.dart';
import 'package:file_picker/file_picker.dart';
import 'dart:io';
import 'package:twic_app/api/session.dart';


String _printUsers(List<User> users) {
  if (users.length == 1) {
    return "${users[0].firstname} ${users[0].lastname}";
  }
  String name = "You";
  users
      .forEach((User user) => name += ", ${user.firstname}");
  return name;
}


class ConversationPage extends StatefulWidget {
  Conversation conversation;
  final User user;

  ConversationPage({this.conversation, this.user});

  @override
  State<ConversationPage> createState() => ConversationPageState();
}

class ConversationPageState extends State<ConversationPage> {
  List<Message> _messages;

  void onNewMessage(Message message) {
    _messages.add(message);
  }


  @override
  Widget build(BuildContext context) {
    User user =
        null != widget.conversation ? widget.conversation.users[0] : null;
    return Scaffold(
        resizeToAvoidBottomPadding: true,
        resizeToAvoidBottomInset: true,
        body: RootPage(
            child:
            null != widget.conversation ? Messages.getList(conversation_id: widget.conversation.id, builder: (List<Message> messages){
              _messages = messages;
              return _ConversationPage(conversation: widget.conversation, messages: _messages, onNewMessage: onNewMessage,);
            }) : _ConversationPage(user: widget.user,)
        ));
  }
}

class _ConversationPage extends StatefulWidget {
  final Conversation conversation;
  final User user;
  final List<Message> messages;
  final Function onNewMessage;



  _ConversationPage({this.conversation, this.messages, this.onNewMessage, this.user});

  @override
  State<StatefulWidget> createState() => null != conversation ? _ConversationPageState() : _BeforeConversationPageState();
}

class _ConversationPageState extends State<_ConversationPage> {


  bool addingFiles = false;
  bool uploading = false;
  TwicFile attachment;
  TextEditingController _controller = TextEditingController();



  Mutation _renderMessageInput(BuildContext context, Size mediaSize) {
    return Messages.send(
        builder: (RunMutation send, QueryResult result) =>
            Positioned(
                bottom: 0,
                left: 0,
                right: 0,
                child: Container(
                  height: 70.0,
                  width: mediaSize.width,
                  color: Colors.white,
                  child: Padding(
                    padding:
                    EdgeInsets.only(left: 20.0, right: 20.0),
                    child: !addingFiles
                        ? Row(children: [
                      !uploading
                          ? Button(
                        padding: EdgeInsets.all(0),
                        height: 20,
                        width: 20,
                        child: Icon(
                          Icons.add,
                          color: Colors.white,
                          size: 15,
                        ),
                        onPressed: () => setState(
                                () => addingFiles = true),
                        color: Style.mainColor,
                      )
                          : CircularProgressIndicator(),
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
                            onSubmitted:  (String message) {
                              if (_controller.text.isEmpty)
                                return;
                              sendMessage({
                                "conversation_id":
                                widget.conversation.id,
                                "text": _controller.text
                              }, send);
                              _controller.text = "";
                            },
                            after: Button(
                              padding: EdgeInsets.all(0),
                              width: 50,
                              background: Style.veryLightGrey,
                              child: Icon(Icons.arrow_forward,
                                  color: Style.lightGrey),
                              onPressed: () {
                                if (_controller.text.isEmpty)
                                  return;
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
                          onPressed: () => setState(
                                  () => addingFiles = false),
                          background: Style.lightGrey,
                        ),
                        SizedBox(
                          width: 10,
                        ),
                        Button(
                          background:
                          Style.mainColor.withAlpha(40),
                          radius: BorderRadius.all(
                              Radius.circular(25.0)),
                          padding: EdgeInsets.all(0),
                          width: 50.0,
                          child: Icon(
                            Icons.camera_alt,
                            size: 24.0,
                            color: Style.mainColor,
                          ),
                          onPressed: () => ImagePicker
                              .pickImage(
                              source:
                              ImageSource.camera)
                              .then((File file) =>
                              onFileUpload(file, send)),
                        ),
                        SizedBox(
                          width: 10,
                        ),
                        Button(
                          background:
                          Style.genZYellow.withAlpha(40),
                          radius: BorderRadius.all(
                              Radius.circular(25.0)),
                          padding: EdgeInsets.all(0),
                          width: 50.0,
                          child: Icon(
                            Icons.play_arrow,
                            size: 24.0,
                            color: Style.genZYellow,
                          ),
                          onPressed: () => ImagePicker
                              .pickVideo(
                              source:
                              ImageSource.camera)
                              .then((File file) =>
                              onFileUpload(file, send)),
                        ),
                        SizedBox(
                          width: 10,
                        ),
                        Button(
                          background:
                          Style.genZGreen.withAlpha(40),
                          radius: BorderRadius.all(
                              Radius.circular(25.0)),
                          padding: EdgeInsets.all(0),
                          width: 50.0,
                          child: Icon(
                            Icons.library_add,
                            size: 24.0,
                            color: Style.genZGreen,
                          ),
                          onPressed: () =>
                              FilePicker.getFilePath(
                                  type: FileType.ANY)
                                  .then((String path) {
                                File file = File(path);
                                onFileUpload(file, send);
                              }),
                        )
                      ],
                    ),
                  ),
                )));
  }

  void sendMessage(Map<String, dynamic> params, Function send) {
    send(params);
    params["user"] = Session.instance.user.toJson();
    params["createdAt"] = DateTime.now().toIso8601String();
    widget.onNewMessage(Message.fromJson(params));
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
    return Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          SizedBox(
            height: 20,
          ),Padding(
              padding: EdgeInsets.only(right: 20),
              child: widget.conversation.users.length == 1
                  ? Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Button(
                    background: Colors.transparent,
                    width: 50.0,
                    child: Icon(Icons.arrow_back,
                        color: Style.lightGrey),
                    onPressed: () => Navigator.pop(context),
                  ),
                  Container(
                      width: mediaSize.width - 120,
                      height: 70,
                      child: Column(children: [
                        Avatar(
                          href:  widget.conversation.users[0].avatar?.href(),
                        ),
                        SizedBox(
                          height: 5,
                        ),
                        Flexible(
                            child: Text(_printUsers(widget.conversation.users),
                                overflow: TextOverflow.ellipsis,
                                style: Style.text)),
                      ])),
                  SizedBox(
                    width: 50.0,
                  )
                ],
              )
                  : Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Button(
                      background: Colors.transparent,
                      width: 50.0,
                      child: Icon(Icons.arrow_back,
                          color: Style.lightGrey),
                      onPressed: () => Navigator.pop(context),
                    ),
                    Container(
                        width: mediaSize.width - 140,
                        height: 50,
                        child: Column(
                          children: <Widget>[
                            Flexible(
                                child: Text(
                                    widget.conversation.name,
                                    overflow:
                                    TextOverflow.ellipsis,
                                    style: Style.largeText)),
                            SizedBox(
                              height: 5,
                            ),
                            Flexible(
                                child: Text(_printUsers(widget.conversation.users),
                                    overflow:
                                    TextOverflow.ellipsis,
                                    style: Style.text)),
                          ],
                        )),
                    (null != widget.conversation.picture
                        ? Avatar(
                        href: widget.conversation.picture
                            .href())
                        : Container(
                      width: 50,
                      height: 50,
                      alignment: Alignment(0, 0),
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.all(
                              Radius.circular(25)),
                          color: Style.darkGrey),
                      child: Text(
                          (widget.conversation.users
                              .length +
                              1)
                              .toString(),
                          style: Style.whiteTitle),
                    )),
                  ]))
            ,
          SizedBox(
            height: 10.0,
          ),
          Stack(children: [
            Container(
                width: mediaSize.width,
                height: mediaSize.height - 120,
                color: Style.greyBackground,
                padding: EdgeInsets.only(left: 20.0, right: 20.0, top: 0),
                child: Messages.onMessage(
                          conversation_id: widget.conversation.id,
                          builder: ({
                            dynamic error,
                            bool loading,
                            dynamic payload,
                          }) {
                            if (null != payload && !loading) {
                              Message message = Message.fromJson(payload['onMessage']);
                              if (message.user.id != Session.instance.user.id) {
                                widget.onNewMessage(message);
                              }
                            }
                            return MessageList(list: widget.messages);
                          })),
            _renderMessageInput(context, mediaSize)
          ])
        ]);
  }
}



class _BeforeConversationPageState extends State<_ConversationPage> {

  bool addingFiles = false;
  bool uploading = false;
  TwicFile attachment;
  TextEditingController _controller = TextEditingController();



  Mutation _renderMessageInput(BuildContext context, Size mediaSize) {
    return Messages.send(
        onCompleted: (dynamic data) {
            Message message = Message.fromJson(data['sendMessage']);
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (BuildContext context) =>
                        ConversationPage(
                          conversation: Conversation.fromJson({
                            "users": [widget.user.toJson()],
                            "id": message.conversation_id
                          }),
                        )));
        },
        builder: (RunMutation send, QueryResult result) =>
            Positioned(
                bottom: 0,
                left: 0,
                right: 0,
                child: Container(
                  height: 70.0,
                  width: mediaSize.width,
                  color: Colors.white,
                  child: Padding(
                    padding:
                    EdgeInsets.only(left: 20.0, right: 20.0),
                    child: !addingFiles
                        ? Row(children: [
                      !uploading
                          ? Button(
                        padding: EdgeInsets.all(0),
                        height: 20,
                        width: 20,
                        child: Icon(
                          Icons.add,
                          color: Colors.white,
                          size: 15,
                        ),
                        onPressed: () => setState(
                                () => addingFiles = true),
                        color: Style.mainColor,
                      )
                          : CircularProgressIndicator(),
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
                            onSubmitted:  (String message) {
                              if (_controller.text.isEmpty)
                                return;
                              sendMessage({
                                "users": [widget.user.id],
                                "text": _controller.text
                              }, send);
                              _controller.text = "";
                            },
                            after: Button(
                              padding: EdgeInsets.all(0),
                              width: 50,
                              background: Style.veryLightGrey,
                              child: Icon(Icons.arrow_forward,
                                  color: Style.lightGrey),
                              onPressed: () {
                                if (_controller.text.isEmpty)
                                  return;
                                sendMessage({
                                  "users": [widget.user.id],
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
                          onPressed: () => setState(
                                  () => addingFiles = false),
                          background: Style.lightGrey,
                        ),
                        SizedBox(
                          width: 10,
                        ),
                        Button(
                          background:
                          Style.mainColor.withAlpha(40),
                          radius: BorderRadius.all(
                              Radius.circular(25.0)),
                          padding: EdgeInsets.all(0),
                          width: 50.0,
                          child: Icon(
                            Icons.camera_alt,
                            size: 24.0,
                            color: Style.mainColor,
                          ),
                          onPressed: () => ImagePicker
                              .pickImage(
                              source:
                              ImageSource.camera)
                              .then((File file) =>
                              onFileUpload(file, send)),
                        ),
                        SizedBox(
                          width: 10,
                        ),
                        Button(
                          background:
                          Style.genZYellow.withAlpha(40),
                          radius: BorderRadius.all(
                              Radius.circular(25.0)),
                          padding: EdgeInsets.all(0),
                          width: 50.0,
                          child: Icon(
                            Icons.play_arrow,
                            size: 24.0,
                            color: Style.genZYellow,
                          ),
                          onPressed: () => ImagePicker
                              .pickVideo(
                              source:
                              ImageSource.camera)
                              .then((File file) =>
                              onFileUpload(file, send)),
                        ),
                        SizedBox(
                          width: 10,
                        ),
                        Button(
                          background:
                          Style.genZGreen.withAlpha(40),
                          radius: BorderRadius.all(
                              Radius.circular(25.0)),
                          padding: EdgeInsets.all(0),
                          width: 50.0,
                          child: Icon(
                            Icons.library_add,
                            size: 24.0,
                            color: Style.genZGreen,
                          ),
                          onPressed: () =>
                              FilePicker.getFilePath(
                                  type: FileType.ANY)
                                  .then((String path) {
                                File file = File(path);
                                onFileUpload(file, send);
                              }),
                        )
                      ],
                    ),
                  ),
                )));
  }

  void sendMessage(Map<String, dynamic> params, Function send) {
    send(params);
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
            "user_id": [widget.user.id],
            "attachment": attachment.toJson()
          }, send);
        });
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    Size mediaSize = MediaQuery.of(context).size;
    return Column(
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
                child: Icon(Icons.close, color: Style.lightGrey),
                onPressed: () => Navigator.pop(context),
              ),
              Text('New Message', style: Style.largeText),
              SizedBox(
                width: 50.0,
              )
            ],
          ),
          SizedBox(
            height: 10.0,
          ),
          Stack(children: [
            Positioned(
              top: 20,
              left: 20,
              right: 20,
              child: Container(
                height: 50,
                padding: EdgeInsets.symmetric(horizontal: 10),
                decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius:
                    BorderRadius.all(Radius.circular(8))),
                child: Row(
                  children: <Widget>[
                    Text('To: ',
                        style: Style.get(
                            fontSize: 17, color: Style.lightGrey)),
                    Text(
                        ' ${widget.user.firstname} ${widget.user.lastname}',
                        style: Style.largeText)
                  ],
                ),
              ),
            ),
            _renderMessageInput(context, mediaSize)
          ])
        ]);
  }
}
