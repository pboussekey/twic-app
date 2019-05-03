import 'package:flutter/material.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:twic_app/api/services/api_graphql.dart' as api;

class RootPage extends StatefulWidget {
  final Widget child;
  final Function builder;
  static final ScrollController scroll = ScrollController();

  RootPage({this.child, this.builder});

  @override
  State createState() => _RootPageState(child: this.child);
}

class _RootPageState extends State<RootPage> {
  ValueNotifier<GraphQLClient> _client;
  Widget child;

  _RootPageState({this.child});

  @override
  void initState() {
    super.initState();
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
}
