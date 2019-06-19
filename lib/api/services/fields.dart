import 'package:twic_app/api/services/api_graphql.dart' as api;
import 'package:twic_app/api/models/models.dart';
import 'package:flutter/material.dart';

class Fields {
  static Widget getList({int school_id, String search, Function builder}) {
    return api.query<Field>( """      
         query fields(\$school_id: ID, \$search : String) {
          fields(school_id: \$school_id, search: \$search){
                id 
                name
              }
          }
          """,
        {'school_id': school_id, 'search': search},
        onComplete: (dynamic data) => (data['fields'] as List<dynamic>)
            .map((dynamic field) => Field.fromJson(field))
            .toList(),
        builder: builder,);
  }
}
