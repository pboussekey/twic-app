import 'package:twic_app/api/services/api_graphql.dart' as api;
import 'package:twic_app/api/models/models.dart';
import 'package:flutter/material.dart';
import 'package:twic_app/api/services/abstract_service.dart';

export 'package:twic_app/api/services/api_graphql.dart';

class Hashtags extends ApiService<Hashtag> {
  Hashtags()
      : super(
            methodName: 'hashtags',
            queryParams: {
              "followed": "Boolean",
              "search": "String",
              "user_id": "ID",
              "university_id": "ID",
              "page": "Int",
              "count": "Int",
              "id" : "[ID]"
            },
            queryFields: """
                id
                name
                followed
                nbfollowers
            """,
            map: (dynamic json) => Hashtag.fromJson(json));

  static Widget get({int id, Function builder}) {
    return api.query<Hashtag>("""      
         query hashtag(\$id : ID) {
          hashtag(id : \$id){
                id
                name
                followed
                nbfollowers
              }
          }
          """,
        {'id': id},
        onComplete: (dynamic data) => Hashtag.fromJson(data['hashtag']),
        builder: builder);
  }


  static api.Mutation follow({Function builder}) {
    return api.mutation(query: """      
         mutation followHashtag(\$hashtag_id: ID!) {
          followHashtag(hashtag_id: \$hashtag_id){
                success
              }
          }
          """, builder: builder);
  }

  static api.Mutation unfollow({Function builder}) {
    return api.mutation(query: """      
         mutation unfollowHashtag(\$hashtag_id: ID!) {
          unfollowHashtag(hashtag_id: \$hashtag_id){
                success
              }
          }
          """, builder: builder);
  }

}
