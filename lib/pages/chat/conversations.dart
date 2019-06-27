import 'package:flutter/material.dart';
import 'package:twic_app/api/services/cache.dart';
import 'package:twic_app/api/models/models.dart';
import 'package:twic_app/shared/chat/conversationlist.dart';
import '../root_page.dart';
import 'package:twic_app/style/style.dart';
import 'package:twic_app/shared/form/form.dart';
import 'package:twic_app/shared/components/tabs.dart';
import 'package:twic_app/shared/components/bottom_nav.dart';
import 'package:twic_app/pages/chat/create_conversation.dart';
import 'package:twic_app/api/services/messages.dart';

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

  void _reload() {
    if (this.mounted) {
      setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) {
    final Size mediaSize = MediaQuery.of(context).size;
    return RootPage(
      builder: () => Column(children: [
            SizedBox(
              height: 20,
            ),
            Padding(
              padding: EdgeInsets.only(left: 20.0, right: 20.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Text('Conversations', style: Style.hugeTitle),
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
                    placeholder: "Search for chats or people",
                  )),
            ),
            SizedBox(
              height: 10.0,
            ),
            Tabs(
                tabs: [
                  Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                    Text(
                      'My messages',
                      textAlign: TextAlign.center,
                    ),
                    SizedBox(
                      width: 0 != Messages.unread['MESSAGE'] ? 5 : 0,
                    ),
                    0 != Messages.unread['MESSAGE']
                        ? Container(
                            height: 16,
                            width: 16,
                            alignment: Alignment(0, 0),
                            decoration: BoxDecoration(
                                color: Style.mainColor,
                                borderRadius:
                                    BorderRadius.all(Radius.circular(8))),
                            child: Text(Messages.unread['MESSAGE'].toString(),
                                textAlign: TextAlign.center,
                                style: Style.smallWhiteText))
                        : Container()
                  ]),
                  Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                    Text(
                      'Groups',
                      textAlign: TextAlign.center,
                    ),
                    SizedBox(
                      width: 0 != Messages.unread['GROUP'] ? 5 : 0,
                    ),
                    0 != Messages.unread['GROUP']
                        ? Container(
                            height: 16,
                            width: 16,
                            alignment: Alignment(0, 0),
                            decoration: BoxDecoration(
                                color: Style.mainColor,
                                borderRadius:
                                    BorderRadius.all(Radius.circular(8))),
                            child: Text(Messages.unread['GROUP'].toString(),
                                textAlign: TextAlign.center,
                                style: Style.smallWhiteText))
                        : Container()
                  ]),
                  Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                    Text(
                      'Channels',
                      textAlign: TextAlign.center,
                    ),
                    SizedBox(
                      width: 0 != Messages.unread['CHANNEL'] ? 5 : 0,
                    ),
                    0 != Messages.unread['CHANNEL']
                        ? Container(
                            height: 16,
                            width: 16,
                            alignment: Alignment(0, 0),
                            decoration: BoxDecoration(
                                color: Style.mainColor,
                                borderRadius:
                                    BorderRadius.all(Radius.circular(8))),
                            child: Text(Messages.unread['CHANNEL'].toString(),
                                textAlign: TextAlign.center,
                                style: Style.smallWhiteText))
                        : Container()
                  ]),
                ],
                contentHeight: mediaSize.height - 50,
                tabsContent: [
                  AppCache.getWidget<Conversation>(
                      params: {
                        'search': controller.text,
                        'type': 'MESSAGE',
                      },
                      onCompleted: _reload,
                      builder: (List<int> conversations) =>
                          ConversationList(list: conversations)),
                  AppCache.getWidget<Conversation>(
                      params: {
                        'search': controller.text,
                        'type': 'GROUP',
                      },
                      onCompleted: _reload,
                      builder: (List<int> conversations) =>
                          ConversationList(list: conversations)),
                  AppCache.getWidget<Conversation>(
                      params: {
                        'search': controller.text,
                        'type': 'CHANNEL',
                      },
                      onCompleted: _reload,
                      builder: (List<int> conversations) =>
                          ConversationList(list: conversations)),
                ])
          ]),
      bottomBar: BottomNav(
        current: ButtonEnum.Chat,
        refresh: setState,
      ),
    );
  }
}
