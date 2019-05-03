import 'package:twic_app/api/services/api_graphql.dart' as api;
import 'package:twic_app/api/models/field.dart';
import 'package:flutter/material.dart';

class Fields {
  static Widget getList({Function builder}) {
    return api.query<Field>(
        query: "query{fields{id name}}",
        onComplete: (dynamic data) => (data['fields'] as List<dynamic>)
            .map((dynamic field) => Field.fromJson(field)).toList(),
        builder: builder);
  }
}
