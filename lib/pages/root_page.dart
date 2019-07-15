import 'package:flutter/material.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:twic_app/api/services/api_graphql.dart' as api;
import 'package:twic_app/api/models/models.dart';
import 'package:share/receive_share_state.dart';
import 'package:share/share.dart';
import 'package:twic_app/pages/posts/create.dart';
import 'package:twic_app/api/services/messages.dart';
import 'package:twic_app/api/services/notifications.dart';
import 'package:twic_app/api/services/cache.dart';
import 'package:twic_app/api/session.dart';
import 'package:twic_app/api/services/firebase.dart';
import 'package:twic_app/pages/chat/conversation.dart';
import 'package:twic_app/shared/components/bottom_nav.dart';
import 'package:audioplayers/audio_cache.dart';
import 'dart:convert';

class RootPage extends StatefulWidget {
  final Widget child;
  final Function builder;
  final bool scrollable;
  final Color backgroundColor;
  static ScrollController scroll;
  final Widget appBar;
  final Widget bottomBar;
  final ButtonEnum navBar;
  final resizable;

  RootPage({this.child,
    this.builder,
    this.backgroundColor,
    this.scrollable = true,
    this.appBar,
    this.bottomBar,
    this.navBar,
    this.resizable = true,
    Key key})
      : super(key: key);

  @override
  State createState() => _RootPageState();
}

class _RootPageState extends ReceiveShareState<RootPage> {
  ValueNotifier<GraphQLClient> _client;
  UniqueKey _navKey = UniqueKey();
  UniqueKey _contentKey = UniqueKey();
  AudioCache audioCache = AudioCache();
  bool hasUnread = false;

  @override
  void initState() {
    super.initState();
    enableShareReceiving();
    api.getClient().then((client) {
      setState(() {
        _client = client;
      });
    });
    Messages.loadUnread(() =>
        setState(() {
          hasUnread = Messages.unread['MESSAGE'] > 0 ||
              Messages.unread['GROUP'] > 0 ||
              Messages.unread['CHANNEL'] > 0;
        }));
    Firebase.instance.configure(
      onMessage: (Map<String, dynamic> _msg) {
        try {
          FcmMessage fcmMessage = FcmMessage(
              type: _msg['data']['type'],
              data: json.decode(_msg['data']['data']));
          switch (fcmMessage.type) {
            case FcmMessage.Message:
              Message message = Message.fromJson(fcmMessage.data);
              Conversation conversation =
              AppCache.getModel<Conversation>(message.conversation_id);
              if (null != conversation) {
                conversation.unread++;
                conversation.last = message.text;
                conversation.lastId = message.id;
                conversation.lastDate = message.createdAt;
              }
              if (message.user.id != Session.instance.user.id) {
                Messages.unread[message.type]++;
                audioCache.play('ntf.mp3');
                if (null != Messages.messages[message.conversation_id]) {
                  Messages.messages[message.conversation_id].insert(0, message);
                }
              }
              if (mounted) {
                if (null != Messages.refresh) {
                  Messages.refresh();
                }
                setState(() {
                  _navKey = UniqueKey();
                  hasUnread = Messages.unread['MESSAGE'] > 0 ||
                      Messages.unread['GROUP'] > 0 ||
                      Messages.unread['CHANNEL'] > 0;
                });
              }

              break;
            default:
              setState(() {
                _navKey = UniqueKey();
                Notifications.hasNotification = true;
              });
              break;
          }
        } catch (error) {
          print(error);
        }
        return null;
      },
      onLaunch: (Map<String, dynamic> _msg) {
        FcmMessage fcmMessage = FcmMessage.fromJson(_msg['data']);
        print(['ON LAUNCH', fcmMessage.toJson()]);
        switch (fcmMessage.type) {
          case FcmMessage.Message:
            Message message = Message.fromJson(fcmMessage.data);
            AppCache.loadModel(message.conversation_id, callback: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (BuildContext context) =>
                          ConversationPage(
                              conversation:
                              AppCache.getModel(message.conversation_id))));
            });
            break;
          default:
            break;
        }
        return;
      },
      onResume: (Map<String, dynamic> _msg) {
        FcmMessage fcmMessage = FcmMessage.fromJson(_msg['data']);
        print(['ON RESUME', fcmMessage.toJson()]);
        switch (fcmMessage.type) {
          case FcmMessage.Message:
            Message message = Message.fromJson(fcmMessage.data);
            AppCache.loadModel(message.conversation_id, callback: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (BuildContext context) =>
                          ConversationPage(
                              conversation:
                              AppCache.getModel(message.conversation_id))));
            });
            break;
          default:
            break;
        }
        return;
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    print("BUILD ROOT PAGE");
    final Size mediaSize = MediaQuery
        .of(context)
        .size;
    RootPage.scroll = ScrollController();
    return null != _client
        ? GestureDetector(
        onTap: () {
          FocusScope.of(context).requestFocus((FocusNode()));
        },
        child: Container(
            height: mediaSize.height,
            width: mediaSize.width,
            key: _contentKey,
            color: widget.backgroundColor ?? Colors.white,
            child: GraphQLProvider(
                client: _client,
                child: CacheProvider(
                    child: Scaffold(
                        resizeToAvoidBottomInset: widget.resizable,
                        backgroundColor: Colors.white,
                        appBar: widget.appBar,
                        body: widget.scrollable
                            ? SingleChildScrollView(
                            controller: RootPage.scroll,
                            child: SafeArea(
                                child:
                                widget.child ?? widget.builder()))
                            : Container(
                            child: SafeArea(
                                child:
                                widget.child ?? widget.builder())),
                        bottomNavigationBar: null != widget.navBar
                            ? BottomNav(
                          current: widget.navBar,
                          refresh: setState,
                          hasUnread: hasUnread,
                          hasNotification: Notifications.hasNotification,
                          key: _navKey,
                        )
                            : widget.bottomBar)))))
        : SafeArea(child: CircularProgressIndicator());
  }

  @override
  void receiveShare(Share shared) {
    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (BuildContext context) =>
                CreatePost(
                  share: shared.text,
                )));
  }
}
