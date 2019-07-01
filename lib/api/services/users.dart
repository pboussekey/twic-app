import 'package:twic_app/api/services/api_graphql.dart' as api;
import 'package:twic_app/api/models/models.dart';
import 'package:flutter/material.dart';
import 'package:twic_app/api/services/abstract_service.dart';

export 'package:twic_app/api/services/api_graphql.dart';

class Users extends ApiService<User> {
  Users()
      : super(
            methodName: 'users',
            queryParams: {
              "follower": "Boolean",
              "following": "Boolean",
              "search": "String",
              "school_id": "ID",
              "university_id": "ID",
              "user_id": "ID",
              "major_id": "ID",
              "minor_id": "ID",
              "hashtag_id": "ID",
              "class_year": "Int",
              "id": "[ID]"
            },
            queryFields: """
                id
                firstname
                lastname
                followed
                nbFollowers
                avatar{ name bucketname token }
                school { id name logo { name bucketname token }  }
                university{ id name logo { name bucketname token } }
                minor{ id name }
                major{ id name }
                classYear
                isActive
                degree
            """,
            map: (dynamic json) => User.fromJson(json));

  static Widget get({int id, Function builder}) {
    return api.query<User>("""      
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
          """, {'id': id},
        onComplete: (dynamic data) => User.fromJson(data['user']),
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

  static api.Mutation follow({Function builder}) {
    return api.mutation(query: """      
         mutation followUser(\$user_id: ID!) {
          followUser(user_id: \$user_id){
                success
              }
          }
          """, builder: builder);
  }

  static Future<bool> registerFcmToken(String token) {
    api.execute("""      
         mutation registerFcmToken(\$token: String!) {
          registerFcmToken(token: \$token){
                success
              }
          }
          """, {"token": token}).then((dynamic data) => true);
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
