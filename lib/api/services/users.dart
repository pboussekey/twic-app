import 'package:twic_app/api/services/api_graphql.dart' as api;
import 'package:twic_app/api/models/models.dart';
import 'package:flutter/material.dart';

export 'package:twic_app/api/services/api_graphql.dart';

class Users {
  static Map<int, User> list = {};

  static Widget get({int id, Function builder}) {
    return api.query<User>(
        query: """      
         query user(\$id : ID) {
          user(id : \$id){
                id
                firstname
                lastname
                followed
                nbFollowers
                nbFollowings
                nbPosts
                classYear
                description
                degree
                avatar{ id name bucketname token }
                major{ id name }
                minor{ id name }
                school { id name  logo { name bucketname token }  }
                university{ id name logo { name bucketname token } }
              }
          }
          """,
        onComplete: (dynamic data) => User.fromJson(data['user']),
        params: {'id': id},
        builder: builder);
  }

  static Widget getList(
      {int school_id,
      int university_id,
      String search,
      bool follower,
      bool following,
      int user_id,
      int major_id,
      int minor_id,
      int hashtag_id,
      int class_year,
      Function onCompleted,
      bool cache = true,
      List<int> exclude_school,
      Function builder}) {
    return api.query<int>(
        query: """      
         query users(
            \$follower: Boolean, 
            \$following: Boolean, 
            \$search : String, 
            \$school_id : ID, 
            \$university_id : ID, 
            \$user_id : ID, 
            \$major_id : ID, 
            \$minor_id : ID,
            \$hashtag_id : ID, 
            \$class_year : Int, 
            \$id : [ID]
          ) {
          users(
            follower: \$follower, 
            following: \$following, 
            search: \$search, 
            school_id : \$school_id,  
            university_id : \$university_id, 
            user_id : \$user_id, 
            major_id : \$major_id, 
            minor_id : \$minor_id, 
            hashtag_id : \$hashtag_id, 
            class_year : \$class_year, 
            id : \$id
          ){
                
                 id
               
              }
          }
          """,
        cache: cache,
        onComplete: (dynamic data) {
          List<int> ids = (list as List<dynamic>)
              .map((dynamic json) => int.parse(json['id']))
              .toList();
          load(id: ids, onCompleted: onCompleted);
          return ids;
        },
        params: {
          'school_id': school_id,
          'search': search,
          'follower': follower,
          'following': following,
          'user_id': user_id,
          'major_id': major_id,
          'minor_id': minor_id,
          'hashtag_id': hashtag_id,
          'class_year': class_year,
          'exclude_school': exclude_school,
        },
        builder: builder);
  }

  static api.Mutation update(
      {Function builder, Function update, Function onCompleted}) {
    return api.mutation(query: """      
         mutation updateUser(
         \$minor_id: ID, 
         \$major_id: ID, 
         \$school_id: ID, 
         \$classYear: Int, 
         \$isActive: Boolean,
         \$avatar: FileInputDef,
         \$degree: String,
         \$firstname: String,
         \$lastname: String,
         \$description: String) {
          updateUser(
            minor_id: \$minor_id, 
            major_id: \$major_id, 
            school_id: \$school_id, 
            classYear: \$classYear, 
            isActive: \$isActive, 
            avatar : \$avatar,
            degree : \$degree,
            firstname : \$firstname,
            lastname : \$lastname,
            description : \$description){
                 id
                firstname
                lastname
                followed
                nbFollowers,
                avatar{ name bucketname token }
                school { id name logo { name bucketname token }  }
                university{ id name logo { name bucketname token } }
                minor{ id name }
                major{ id name }
                classYear
                isActive
                degree
              }
          }
          """, builder: builder, update: update, onCompleted: onCompleted);
  }

  static Future<List> _load({
    int school_id,
    int university_id,
    String search,
    bool follower,
    bool following,
    int user_id,
    int major_id,
    int minor_id,
    int hashtag_id,
    int class_year,
    int count,
    int page,
    List<int> id,
    bool cache = true,
    bool getModel = false,
  }) {
    String fields = getModel
        ? """   
      id
      firstname
      lastname
      followed
      nbFollowers,
      avatar{ name bucketname token }
      school { id name  logo { name bucketname token }  }
      university{ id name logo { name bucketname token } }
      """
        : "id";
    return api.execute("""      
         query users(
            \$follower: Boolean, 
            \$following: Boolean, 
            \$search : String, 
            \$school_id : ID, 
            \$university_id : ID, 
            \$user_id : ID, 
            \$major_id : ID, 
            \$minor_id : ID,
            \$hashtag_id : ID, 
            \$class_year : Int, 
            \$id : [ID], 
            \$count : Int,  
            \$page : Int
          ) {
          users(
            follower: \$follower, 
            following: \$following, 
            search: \$search, 
            school_id : \$school_id,  
            university_id : \$university_id, 
            user_id : \$user_id, 
            major_id : \$major_id, 
            minor_id : \$minor_id, 
            hashtag_id : \$hashtag_id, 
            class_year : \$class_year, 
            id : \$id,
            count : \$count,
            page : \$page
          ){
              ${fields}
            }
          }
          """, {
      'hashtag_id': hashtag_id,
      'user_id': user_id,
      'school_id': school_id,
      'university_id': university_id,
      'major_id': major_id,
      'minor_id': minor_id,
      'class_year': class_year,
      'follower': follower,
      'following': following,
      'search' : search,
      'id': id,
      'count': count,
      'page': page
    }, cache: cache).then((dynamic list) {
      return list['users'] as List<dynamic>;
    });
  }

  static void load(
      {int school_id,
      int university_id,
      String search,
      bool follower,
      bool following,
      int user_id,
      int major_id,
      int minor_id,
      int hashtag_id,
      int class_year,
      int count,
      int page,
      List<int> id,
      bool cache = true,
      Function onCompleted}) {
    _load(
            school_id: school_id,
            university_id: university_id,
            search: search,
            follower: follower,
            following: following,
            user_id: user_id,
            major_id: major_id,
            minor_id: minor_id,
            hashtag_id: hashtag_id,
            class_year: class_year,
            page: page,
            count: count,
            id: id,
            cache: cache,
            getModel: true)
        .then((List<dynamic> _list) {
      _list.forEach(
          (dynamic json) => list[int.parse(json['id'])] = User.fromJson(json));
      if (null != onCompleted) {
        onCompleted();
      }
    });
  }

  static Future<List<int>> getId(
      {int school_id,
      int university_id,
      String search,
      bool follower,
      bool following,
      int user_id,
      int major_id,
      int minor_id,
      int hashtag_id,
      int class_year,
      int count,
      int page,
      List<int> id,
      Function onCompleted}) {
    return _load(
            school_id: school_id,
            university_id: university_id,
            search: search,
            follower: follower,
            following: following,
            user_id: user_id,
            major_id: major_id,
            minor_id: minor_id,
            hashtag_id: hashtag_id,
            class_year: class_year,
            page: page,
            count: count,
            id: id,
            getModel: false)
        .then((dynamic list) {
      List<int> ids = (list as List<dynamic>)
          .map((dynamic json) => int.parse(json['id']))
          .toList();
      List<int> toLoad = ids.where((int id) => null == Users.list[id]).toList();
      if(toLoad.length > 0) {
        load(id: toLoad, cache: false, onCompleted: onCompleted);
      }
      return ids;
    });
  }

  static api.Mutation follow({Function builder}) {
    return api.mutation(query: """      
         mutation followUser(\$user_id: ID!) {
          followUser(user_id: \$user_id){
                success
              }
          }
          """, builder: builder);
  }

  static api.Mutation unfollow({Function builder}) {
    return api.mutation(query: """      
         mutation unfollowUser(\$user_id: ID!) {
          unfollowUser(user_id: \$user_id){
                success
              }
          }
          """, builder: builder);
  }
}
