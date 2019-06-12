import 'package:flutter/material.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:twic_app/api/services/api_graphql.dart' as api;
import 'package:share/receive_share_state.dart';
import 'package:share/share.dart';
import 'package:twic_app/pages/posts/create.dart';

class RootPage extends StatefulWidget {
  final Widget child;
  final Function builder;
  final bool scrollable;
  final Color backgroundColor;
  static ScrollController scroll = ScrollController();

  RootPage(
      {this.child, this.builder, this.backgroundColor, this.scrollable = true});

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
                        child: widget.scrollable
                            ? SingleChildScrollView(
                                controller: RootPage.scroll,
                                child: SafeArea(
                                    child: widget.child ?? widget.builder()))
                            : Container(
                                child: SafeArea(
                                    child:
                                        widget.child ?? widget.builder()))))))
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
