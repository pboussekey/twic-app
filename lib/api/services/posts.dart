import 'package:twic_app/api/services/api_graphql.dart' as api;
import 'package:twic_app/api/models/post.dart';
import 'package:flutter/material.dart';

export 'package:twic_app/api/services/api_graphql.dart';

class Posts {
  static Widget getList(
      {int hashtag_id, int user_id, int parent_id, Function builder}) {
    return api.query<Post>(
        query: """      
         query posts( \$hashtag_id : ID, \$user_id : ID, \$parent_id : ID) {
            posts(user_id: \$user_id, hashtag_id : \$hashtag_id, parent_id : \$parent_id){
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
        cache: false,
        onComplete: (dynamic data) => (data['posts'] as List<dynamic>)
            .map((dynamic post) => Post.fromJson(post))
            .toList(),
        params: {
          'hashtag_id': hashtag_id,
          'user_id': user_id,
          'parent_id': parent_id
        },
        builder: builder);
  }

  static api.Mutation create({Function builder, Function onCompleted}) {
    return api.mutation(query: """      
         mutation addPost(\$content: String, \$privacy : String,  \$files : [FileInputDef]) {
          addPost(content: \$content, privacy: \$privacy, files: \$files){
              id
            }
          }
          """, builder: builder, onCompleted: onCompleted);
  }
}
