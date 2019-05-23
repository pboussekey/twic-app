import 'package:twic_app/api/services/api_graphql.dart' as api;
import 'package:twic_app/api/models/models.dart';
import 'package:flutter/material.dart';

export 'package:twic_app/api/services/api_graphql.dart';

class Hashtags {
  static Widget getList({bool followed, String search, Function builder, bool cache = true}) {
    return api.query<Hashtag>(
        query: """      
         query hashtags(\$followed: Boolean, \$search : String) {
          hashtags(followed: \$followed, search: \$search){
                id
                name
                followed
                nbfollowers
              }
          }
          """,
        cache: search == null && cache,
        params: {'followed': followed, 'search': search},
        onComplete: (dynamic data) =>
            ((data['hashtags'] ?? []) as List<dynamic>)
                .map((dynamic hashtag) => Hashtag.fromJson(hashtag))
                .toList(),
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

  static List<Hashtag> _suggestions;

  static Widget suggestions({force: false, Function builder}) {
    if (null == _suggestions || force) {
      return getList(
          cache: false,
          followed: false,
          builder: (List<Hashtag> hashtags) {
            _suggestions = hashtags;
            return builder(_suggestions);
          });
    }
    return builder(_suggestions);
  }

  static List<Hashtag> _followed;

  static Widget followed({force: false, Function builder}) {
    if (null == _followed || force) {
      return getList(
          cache: false,
          followed: true,
          builder: (List<Hashtag> hashtags) {
            _followed = hashtags;
            return builder(_followed);
          });
    }
    return builder(_followed);
  }

}
