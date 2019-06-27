import 'package:flutter/material.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:twic_app/api/services/api_graphql.dart' as api;
import 'package:twic_app/api/models/models.dart';
import 'package:share/receive_share_state.dart';
import 'package:share/share.dart';
import 'package:twic_app/pages/posts/create.dart';
import 'package:twic_app/api/services/messages.dart';
import 'package:twic_app/api/services/cache.dart';
import 'package:twic_app/api/session.dart';

class RootPage extends StatefulWidget {
  final Widget child;
  final Function builder;
  final bool scrollable;
  final Color backgroundColor;
  static ScrollController scroll;
  final Widget appBar;
  final Widget bottomBar;
  final resizable;

  RootPage(
      {this.child, this.builder, this.backgroundColor, this.scrollable = true, this.appBar, this.bottomBar, this.resizable = true});

  @override
  State createState() => _RootPageState();
}

class _RootPageState extends ReceiveShareState<RootPage> {
  ValueNotifier<GraphQLClient> _client;

  _RootPageState();

  @override
  void initState() {
    super.initState();
    enableShareReceiving();
    api.getClient().then((client) {
      setState(() {
        _client = client;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    final Size mediaSize = MediaQuery.of(context).size;
    RootPage.scroll = ScrollController();
    return null != _client
        ? GestureDetector(
            onTap: () {
              FocusScope.of(context).requestFocus((FocusNode()));
            },
            child: Container(
                height: mediaSize.height,
                width: mediaSize.width,
                color: widget.backgroundColor ?? Colors.white,
                child: GraphQLProvider(
                    client: _client,
                    child: CacheProvider(
                        child: Messages.getUnread(
                            context: context,
                            builder: (Map<String, dynamic> unread) {
                              return Messages.onMessage(builder: ({
                                dynamic error,
                                bool loading,
                                dynamic payload,
                              }) {
                                if (null != payload && !loading) {
                                  Message message =
                                      Message.fromJson(payload['onMessage']);
                                  if (message.user.id !=
                                      Session.instance.user.id) {
                                    if(null == Messages.lastMessage || Messages.lastMessage < message.id){
                                      Messages.unread[message.type]++;
                                      Messages.lastMessage = message.id;
                                    }
                                    Conversation conversation =
                                        AppCache.getModel<Conversation>(
                                            message.conversation_id);
                                    if (null != conversation && conversation.lastId < message.id) {
                                      conversation.unread++;
                                      conversation.last = message.text;
                                      conversation.lastId = message.id;
                                      conversation.lastDate = message.createdAt;
                                    }
                                  }
                                }
                                return Scaffold(
                                  resizeToAvoidBottomInset: widget.resizable,
                                    backgroundColor: Colors.white,
                                    appBar: widget.appBar,
                                body:widget.scrollable
                                    ? SingleChildScrollView(
                                        controller: RootPage.scroll,
                                        child: SafeArea(
                                            child: widget.child ??
                                                widget.builder()))
                                    : Container(
                                        child: SafeArea(
                                            child: widget.child ??
                                                widget.builder()))
                                ,
                                bottomNavigationBar:widget.bottomBar);
                              });
                            })))))
        : SafeArea(child: CircularProgressIndicator());
  }

  @override
  void receiveShare(Share shared) {
    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (BuildContext context) => CreatePost(
                  share: shared.text,
                )));
  }
}
