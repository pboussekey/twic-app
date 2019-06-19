import 'package:twic_app/api/services/api_graphql.dart' as api;
import 'package:twic_app/api/models/models.dart';
import 'package:flutter/material.dart';

class Schools {

  static Widget get({int id, Function builder}) {
    return api.query<School>( """      
         query school(\$id : ID) {
          school(id : \$id){
                id
                name
              logo{ name bucketname token }
              }
          }
          """,
        {'id': id},
        onComplete: (dynamic data) => School.fromJson(data['school']),
        builder: builder);
  }

  static Widget getList({int university_id, String degree, String search, Function builder}) {
    return api.query<School>("""      
         query schools(\$university_id: ID, \$search : String, \$degree : String) {
            schools(university_id: \$university_id, search : \$search, degree : \$degree){
              id 
              name 
              logo{ name bucketname token }
              university{ id name logo{ name bucketname token }}
            }
          }
        """,
         {
          'university_id': university_id,
          'search' : search,
          'degree' : degree
        },
        onComplete: (dynamic data) => (data['schools'] as List<dynamic>)
            .map((dynamic school) => School.fromJson(school)).toList(),
        builder: builder);
  }
}
