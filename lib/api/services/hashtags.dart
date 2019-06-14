import 'package:twic_app/api/services/api_graphql.dart' as api;
import 'package:twic_app/api/models/models.dart';
import 'package:flutter/material.dart';

export 'package:twic_app/api/services/api_graphql.dart';

class Hashtags {
  static Widget get({int id, Function builder}) {
    return api.query<Hashtag>(
        query: """      
         query hashtag(\$id : ID) {
          hashtag(id : \$id){
                id
                name
                followed
                nbfollowers
              }
          }
          """,
        onComplete: (dynamic data) => Hashtag.fromJson(data['hashtag']),
        params: {'id': id},
        builder: builder);
  }

  static Widget getList(
      {bool followed,
      String search,
      int user_id,
      int  university_id,
      int count,
      int page,
      Function builder,
      bool cache = true}) {
    return api.query<Hashtag>(
        query: """      
         query hashtags(
            \$followed: Boolean, 
            \$search : String, 
            \$user_id : ID, 
            \$university_id : ID, 
            \$page : Int, 
            \$count : Int) {
          hashtags(
            followed: \$followed, 
            search: \$search, 
            user_id : \$user_id, 
            university_id : \$university_id, 
            count : \$count, 
            page :  \$page){
                id
                name
                followed
                nbfollowers
              }
          }
          """,
        cache: search == null && cache,
        params: {
          'followed': followed,
          'search': search,
          'user_id': user_id,
          'university_id': university_id,
          'count': count,
          'page': page
        },
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

  static Future<List<Hashtag>> load(
      {bool followed,
      String search,
      int user_id,
      university_id,
      int count,
      int page,
      Function builder,
      bool cache = true}) {
    return api.execute("""  
        query hashtags(
          \$followed: Boolean, 
          \$search : String, 
          \$user_id : ID, 
          \$university_id : ID, 
          \$page : Int, 
          \$count : Int) {
          hashtags(
            followed: \$followed, 
            search: \$search, 
            user_id : \$user_id, 
            university_id : \$university_id, 
            count : \$count, 
            page :  \$page){
                id
                name
                followed
                nbfollowers
              }
          }
          """, {
      'user_id': user_id,
      'search': search,
      'followed': followed,
      'university_id': university_id,
      'count': count,
      'page': page
    }, cache: false).then((dynamic data) {
      return (data['hashtags'] as List<dynamic>)
          .map((dynamic hashtag) => Hashtag.fromJson(hashtag))
          .toList();
    });
  }
}
