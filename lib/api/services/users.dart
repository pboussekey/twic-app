import 'package:twic_app/api/services/api_graphql.dart' as api;
import 'package:twic_app/api/models/models.dart';
import 'package:flutter/material.dart';

export 'package:twic_app/api/services/api_graphql.dart';

class Users {
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
                degree
                avatar{ id name bucketname token }
                major{ id name }
                minor{ id name }
                school { id name  logo { name bucketname token } university{ id name logo { name bucketname token } } }
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
      List<int> exclude_school,
      Function builder}) {
    return api.query<User>(
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
            \$exclude_school : [ID]
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
            exclude_school : \$exclude_school
          ){
                id
                firstname
                lastname
                followed
                nbFollowers,
                avatar{ name bucketname token }
                school { id name  logo { name bucketname token } university{ id name logo { name bucketname token } } }
              }
          }
          """,
        onComplete: (dynamic data) => (data['users'] as List<dynamic>)
            .map((dynamic user) => User.fromJson(user))
            .toList(),
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

  static api.Mutation update({Function builder, Function update, Function onCompleted}) {
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
                school { id name logo { name bucketname token } university{ id name logo { name bucketname token } } }
                minor{ id name }
                major{ id name }
                classYear
                isActive
                degree
              }
          }
          """, builder: builder, update: update, onCompleted: onCompleted);
  }
}
