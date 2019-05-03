import 'package:flutter/material.dart';
import 'package:twic_app/api/services/conversations.dart';
import 'package:twic_app/api/models/conversation.dart';
import 'package:twic_app/shared/chat/conversationlist.dart';
import 'package:twic_app/shared/hashtags/hashtaglist.dart';
import 'package:twic_app/shared/schools/schoollist.dart';
import '../root_page.dart';
import 'package:twic_app/style/style.dart';
import 'package:twic_app/shared/form/input.dart';
import 'package:twic_app/shared/form/button.dart';
import 'package:twic_app/shared/components/tabs.dart';
import 'package:twic_app/shared/components/bottom_menu.dart';
import 'package:twic_app/api/session.dart';

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
                            width: 50.0,
                            padding: EdgeInsets.all(0.0),
                            child: Icon(
                              Icons.add,
                              color: Style.genZPurple,
                            ),
                            onPressed: () {})
                      ],
                    ),
                  ),
                  Form(
                    key: _formKey,
                    child: Container(
                        width: mediaSize.width - 40,
                        child: Input(
                          height: 40.0,
                          color: Style.veryLightGrey,
                          shadow: false,
                          icon: Icons.search,
                          controller: controller,
                          placeholder: "Search",
                        )),
                  ),
                  SizedBox(height: 10.0,),
                  Tabs(tabs: [
                    Text(
                      'My Messages',
                      textAlign: TextAlign.center,
                    ),
                    Text('Groups', textAlign: TextAlign.center),
                    Text('Channels', textAlign: TextAlign.center),
                  ], tabsContent: [
                    Conversations.getList(
                        builder: (List<Conversation> conversations) =>
                            ConversationList(list: conversations)),
                    Container(),
                    Container()
                  ])
                ])),
        bottomNavigationBar: BottomMenu(
          current: ButtonEnum.Chat,
          refresh: setState,
        ));
  }
}
