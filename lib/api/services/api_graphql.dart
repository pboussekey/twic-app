import 'package:flutter/material.dart';
import 'dart:async';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:twic_app/api/session.dart';
import 'package:twic_app/api/models/abstract_model.dart';
import 'cache.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

export 'package:graphql_flutter/graphql_flutter.dart';

Future<ValueNotifier<GraphQLClient>> getClient() async {
  Session session = Session.instance;
  HttpLink link = HttpLink(
      uri: '${DotEnv().env['API_URL']}/api',
      headers: <String, String>{'Authorization': 'Bearer ${session.token}'});
  return ValueNotifier<GraphQLClient>(
    GraphQLClient(
      link: link,
      cache: AppCache.get(),
    ),
  );
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
      builder: (QueryResult result) {
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
    Function builder}) {
  return Mutation(
      options: MutationOptions(
        document: query.replaceAll('\n', ' '),
      ),
      onCompleted: onCompleted != null ? (QueryResult result) => onCompleted(result) : null,
      builder: (
        RunMutation runMutation,
        QueryResult result,
      ) {
        return builder(runMutation, result);
      });
}
