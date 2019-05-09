import 'package:flutter/material.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:twic_app/api/services/api_graphql.dart' as api;
import 'package:share/receive_share_state.dart';
import 'package:share/share.dart';
import 'package:twic_app/pages/posts/create.dart';

class RootPage extends StatefulWidget {
  final Widget child;
  final Function builder;
  static final ScrollController scroll = ScrollController();

  RootPage({this.child, this.builder});

  @override
  State createState() => _RootPageState(child: this.child);
}

class _RootPageState extends ReceiveShareState<RootPage> {
  ValueNotifier<GraphQLClient> _client;
  Widget child;

  _RootPageState({this.child});

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
    return null != _client
        ? Container(
            height: mediaSize.height,
            width: mediaSize.width,
            color: Colors.white,
            child: SingleChildScrollView(
              controller: RootPage.scroll,
              child: GraphQLProvider(
                  client: _client,
                  child: CacheProvider(child: SafeArea(child: child ?? widget.builder()))),
            ))
        : SafeArea(child: CircularProgressIndicator());
  }

  @override
  void receiveShare(Share shared) {
      Navigator.push(context, MaterialPageRoute(builder: (BuildContext context) => CreatePost(share: shared.text,)));
  }
}
