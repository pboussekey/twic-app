import 'package:flutter/material.dart';
import 'package:twic_app/api/services/conversations.dart';
import 'package:twic_app/api/models/models.dart';
import 'package:twic_app/shared/chat/conversationlist.dart';
import '../root_page.dart';
import 'package:twic_app/style/style.dart';
import 'package:twic_app/shared/form/form.dart';
import 'package:twic_app/shared/components/tabs.dart';
import 'package:twic_app/shared/components/bottom_nav.dart';
import 'package:twic_app/pages/chat/create_conversation.dart';

class ConversationsList extends StatefulWidget {
  String search;

  @override
  State createState() => ConversationsState();
}

class ConversationsState extends State<ConversationsList> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final controller = TextEditingController();

  ConversationsState() {
    controller.addListener(() {
      if (controller.text.isEmpty) {
        setState(() {
          widget.search = "";
        });
      } else {
        setState(() {
          widget.search = controller.text;
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final Size mediaSize = MediaQuery.of(context).size;
    return Scaffold(
        body: RootPage(
            builder: () => Column(children: [
                  SizedBox(
                    height: 20,
                  ),
                  Padding(
                    padding: EdgeInsets.only(left: 20.0, right: 20.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        Text('Conversations', style: Style.titleStyle),
                        Button(
                            background: Colors.transparent,
                            width: 25.0,
                            padding: EdgeInsets.all(0.0),
                            child: Icon(
                              Icons.add,
                              color: Style.mainColor,
                            ),
                            onPressed: () => Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (BuildContext context) =>
                                        CreateConversation())))
                      ],
                    ),
                  ),
                  Form(
                    key: _formKey,
                    child: Container(
                        width: mediaSize.width - 40,
                        child: Input(
                          height: 50.0,
                          color: Style.veryLightGrey,
                          shadow: false,
                          icon: Icons.search,
                          controller: controller,
                          placeholder: "Search",
                        )),
                  ),
                  SizedBox(
                    height: 10.0,
                  ),
                  Tabs(tabs: [
                    Text(
                      'My Messages',
                      textAlign: TextAlign.center,
                    ),
                    Text('Groups', textAlign: TextAlign.center),
                    Text('Channels', textAlign: TextAlign.center),
                  ], tabsContent: [
                    Conversations.getList(
                        search: controller.text,
                        type: 'MESSAGE',
                        builder: (List<Conversation> conversations) =>
                            ConversationList(list: conversations)),
                    Conversations.getList(
                        search: controller.text,
                        type: 'GROUP',
                        builder: (List<Conversation> conversations) =>
                            ConversationList(list: conversations)),
                    Conversations.getList(
                        search: controller.text,
                        type: 'CHANNEL',
                        builder: (List<Conversation> conversations) =>
                            ConversationList(list: conversations)),
                  ])
                ])),
        bottomNavigationBar: BottomNav(
          current: ButtonEnum.Chat,
          refresh: setState,
        ));
  }
}
