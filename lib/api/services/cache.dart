import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:twic_app/api/services/users.dart';
import 'package:twic_app/api/services/hashtags.dart';
import 'package:twic_app/api/services/conversations.dart';
import 'package:twic_app/api/services/abstract_service.dart';
import 'package:twic_app/api/models/models.dart';
import 'package:flutter/material.dart';

class AppCache {
  static Cache instance;
  static Map<Type, ApiService> services = {
    User: Users(),
    Hashtag: Hashtags(),
    Conversation: Conversations(),
  };

  static Future<List<int>> getId<T>(
      {Map<String, dynamic> params, bool cache = true, Function onCompleted}) {
    return services[T]
        .getId(params: params, cache: cache, onCompleted: onCompleted);
  }

  static Widget getWidget<T>(
      {Map<String, dynamic> params,
      bool cache = true,
      Function onCompleted,
      Widget Function(List<int>) builder}) {
    return services[T].widget(
        params: params,
        cache: cache,
        onCompleted: onCompleted,
        builder: builder);
  }

  static T getModel<T>(int id) {
    return services[T].list[id] as T;
  }

  static void loadModel<T>(int id, {Function callback}) async {
    if (null != services[T].list[id]) {
      callback();
    } else {
      services[T].load(params: {
        "id": [id]
      }, loadModel: true, onCompleted: callback);
    }
  }

  static Cache get() {
    if (null == instance) {
      instance = InMemoryCache();
    }
    return instance;
  }
}
