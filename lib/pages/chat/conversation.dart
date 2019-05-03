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

class ConversationPage extends StatefulWidget {
  String search;
  final Conversation conversation;

  ConversationPage({this.conversation});

  @override
  State createState() => ConversationPageState();
}

class ConversationPageState extends State<ConversationPage> {
  @override
  Widget build(BuildContext context) {
    final Size mediaSize = MediaQuery.of(context).size;
    User user = widget.conversation.users[0];
    return Scaffold(
        body: RootPage(
            builder: () => Column(
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
                            child:
                                Icon(Icons.arrow_back, color: Style.lightGrey),
                            onPressed: () => Navigator.pop(context),
                          ),
                          Avatar(
                            file: user.avatar,
                          ),
                          SizedBox(
                            width: 50.0,
                          )
                        ],
                      ),
                      Text("${user.firstname} ${user.lastname}",
                          style: Style.text),
                      SizedBox(
                        height: 10.0,
                      ),
                      Container(
                          width: mediaSize.width,
                          height: mediaSize.height - 130,
                          color: Style.greyBackground,
                          padding: EdgeInsets.all(20.0),
                          child: Messages.getList(
                            conversation_id: widget.conversation.id,
                            builder: (List<Message> messages) =>
                                MessageList(list: messages),
                          ))
                    ])),
        bottomNavigationBar: Container(
          height: 70.0,
          width: mediaSize.width,
          color: Style.greyBackground,
          child: Padding(
            padding: EdgeInsets.only(left: 20.0, right: 20.0, bottom: 10.0),
            child: Input(
              placeholder: "Type a message",
              after: Button(
                background: Colors.transparent,
                child: Icon(Icons.arrow_forward, color: Style.lightGrey),
              ),
            ),
          ),
        ));
  }
}
