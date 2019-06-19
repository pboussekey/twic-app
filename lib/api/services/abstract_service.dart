import 'package:twic_app/api/services/api_graphql.dart' as api;
import 'package:twic_app/api/models/models.dart';
import 'package:flutter/material.dart';

export 'package:twic_app/api/services/api_graphql.dart';

abstract class ApiService<T extends AbstractModel> {
  Map<int, T> list = {};
  String methodName;
  String queryFields;
  Map<String, String> queryParams;
  AbstractModel Function(dynamic json) map;

  ApiService({this.methodName, this.queryFields, this.queryParams, this.map});

  String _buildQuery([bool loadModel = false]) {
    String query = "query ${methodName}(\n";
    int index = 0;
    queryParams.forEach((String name, String type) {
      query +=
          "\t\$$name : $type${queryParams.length - 1 == index ? '' : ','}\n";
      index++;
    });
    query += "){\n ${methodName} (";
    index = 0;
    queryParams.forEach((String name, String type) {
      query +=
          "\t$name : \$$name${queryParams.length - 1 == index ? '' : ','}\n";
      index++;
    });
    query += "){\n ${loadModel ? queryFields : 'id'}\n}\n}";
    return query;
  }

  List<int> requesting = [];
  List<Function> _onCompleted = [];

  Future<List> _load(
      {Map<String, dynamic> params,
      bool loadModel = false,
      bool cache = true,
      Function onCompleted}) {
    if (loadModel) {
      if (null != onCompleted && !_onCompleted.contains(onCompleted)) {
        _onCompleted.add(onCompleted);
      }
      requesting.addAll(params["id"] ?? []);
    }
    return api
        .execute(_buildQuery(loadModel), params, cache: cache)
        .then((dynamic data) {
      List<dynamic> _list = data[methodName] as List<dynamic>;
      if (loadModel) {
        _list
            .forEach((dynamic json) => list[int.parse(json['id'])] = map(json));
        requesting
            .removeWhere((int id) => (params["id"] ?? []).indexOf(id) >= 0);

        if (_onCompleted.length > 0 && requesting.length == 0) {
          _onCompleted.forEach((Function onCompleted) => onCompleted());
          _onCompleted = [];
        }
      }
      return _list;
    });
  }

  Widget widget(
      {Map<String, dynamic> params,
      bool loadModel = false,
      Widget Function(List<int> ids) builder,
      Function onCompleted,
      bool cache = true}) {
    return api.query<int>(
        _buildQuery(loadModel),
        Map.fromIterable(queryParams.keys,
            key: (dynamic key) => key.toString(),
            value: (dynamic key) => params[key.toString()]),
        cache: cache,
        builder: builder, onComplete: (dynamic data) {
      List<dynamic> _list = data[methodName] as List<dynamic>;
      List<int> ids =
          _list.map((dynamic json) => int.parse(json['id'])).toList();
      List<int> toLoad = ids
          .where((int id) => null == list[id] && -1 == requesting.indexOf(id))
          .toList();
      if (toLoad.length > 0) {
        _load(
            params: Map.fromIterable(queryParams.keys,
                key: (dynamic key) => key.toString(),
                value: (dynamic key) => key.toString() == 'id' ? toLoad : null),
            loadModel: true,
            onCompleted: onCompleted,
            cache: false);
      }
      return ids;
    });
  }

  Future<List<int>> getId(
      {Map<String, dynamic> params,
      bool cache = true,
      Function onCompleted}) async {
    return _load(
            params: Map.fromIterable(queryParams.keys,
                key: (dynamic key) => key.toString(),
                value: (dynamic key) => params[key.toString()]),
            cache: cache)
        .then((List<dynamic> _list) {
      List<int> ids =
          _list.map((dynamic json) => int.parse(json['id'])).toList();
      List<int> toLoad = ids.where((int id) => null == list[id]).toList();
      if (toLoad.length > 0) {
        print(["LOAD", toLoad]);
        _load(
            params: Map.fromIterable(queryParams.keys,
                key: (dynamic key) => key.toString(),
                value: (dynamic key) => key.toString() == 'id' ? toLoad : null),
            loadModel: true,
            onCompleted: onCompleted,
            cache: false);
      }
      return ids;
    });
  }
}
