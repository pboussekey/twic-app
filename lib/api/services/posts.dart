import 'package:twic_app/api/services/api_graphql.dart' as api;
import 'package:twic_app/api/models/post.dart';
import 'package:flutter/material.dart';

class Posts {
  static Widget getList(
      {int hashtag_id, int user_id, Function builder}) {
    return api.query<Post>(
        query: """      
         query posts( \$hashtag_id : ID, \$user_id : ID) {
            posts(user_id: \$user_id, hashtag_id : \$hashtag_id){
              content 
              createdAt 
              nbComments 
              nbLikes 
              isLiked 
              user{ 
                id
                firstname 
                lastname 
                school { id name university{ id name } } 
                avatar{ name bucketname token } 
              }
              files{ name bucketname token }
            }
          }
          """,
        onComplete: (dynamic data) => (data['posts'] as List<dynamic>)
            .map((dynamic post) => Post.fromJson(post))
            .toList(),
        params: {
          'hashtag_id': hashtag_id,
          'user_id': user_id
        },
        builder: builder);
  }
}
