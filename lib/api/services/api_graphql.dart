import 'package:flutter/material.dart';
import 'dart:async';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:twic_app/api/session.dart';
import 'package:twic_app/api/models/abstract_model.dart';
import 'cache.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

export 'package:graphql_flutter/graphql_flutter.dart';

ValueNotifier<GraphQLClient> _client;

Future<ValueNotifier<GraphQLClient>> getClient() async {
  if (null != _client) return _client;
  Session session = Session.instance;
  HttpLink httpLink = HttpLink(uri: '${DotEnv().env['API_URL']}/api');

  final AuthLink authLink = AuthLink(getToken: () => 'Bearer ${session.token}');

  final Link link = authLink.concat(httpLink as Link);
  _client = ValueNotifier<GraphQLClient>(
    GraphQLClient(
      link: link,
      cache: AppCache.get(),
    ),
  );
  return _client;
}

Future<dynamic> execute(String query, Map<String, dynamic> params) async {
  return getClient().then(
    (ValueNotifier<GraphQLClient> client) {
      print(client);
      return client.value
          .query(QueryOptions(document: query, variables: params));
    },
  ).then((QueryResult result) => result.data);
}

Widget query<T extends AbstractModel>(
    {String query,
    Map<String, dynamic> params,
    Function onComplete,
    bool cache: true,
    Widget whileLoading,
    Function builder}) {
  return Query(
      options: QueryOptions(
          document: query.replaceAll('\n', ' '),
          variables: params,
          fetchPolicy: cache ? FetchPolicy.cacheFirst : FetchPolicy.noCache),
      builder: (QueryResult result, {VoidCallback refetch}) {
        print(params);
        if (result.loading) {
          return whileLoading ?? Container();
        }
        dynamic _data = onComplete(result.data);
        return builder(_data);
      });
}

Mutation mutation(
    {String query,
    Map<String, dynamic> params,
    Function onCompleted,
    Function update,
    Function builder}) {
  return Mutation(
      options: MutationOptions(
        document: query.replaceAll('\n', ' '),
      ),
      update: update,
      onCompleted: onCompleted,
      builder: (
        RunMutation runMutation,
        QueryResult result,
      ) {
        return builder(runMutation, result);
      });
}
