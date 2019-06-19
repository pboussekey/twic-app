import 'package:twic_app/api/services/api_graphql.dart' as api;
import 'package:twic_app/api/models/models.dart';
import 'package:flutter/material.dart';

export 'package:twic_app/api/services/api_graphql.dart';

class Posts {
  static Widget getList(
      {int hashtag_id, int user_id, int parent_id, int count, int page, Function builder}) {
    return api.query<Post>("""      
         query posts( \$hashtag_id : ID, \$user_id : ID, \$parent_id : ID, \$count : Int,  \$page : Int) {
            posts(user_id: \$user_id, hashtag_id : \$hashtag_id, parent_id : \$parent_id, count : \$count, page : \$page){
              id
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
        {
          'hashtag_id': hashtag_id,
          'user_id': user_id,
          'parent_id': parent_id,
          'count': count,
          'page': page
        },
        cache: false,
        onComplete: (dynamic data){ return (data['posts'] as List<dynamic>)
            .map((dynamic post) => Post.fromJson(post))
            .toList(); },
        builder: builder);
  }

  static Future<List<Post>> loadPosts(
      {int hashtag_id, int user_id, int parent_id, int count, int page}){
    return api.execute("""      
         query posts( \$hashtag_id : ID, \$user_id : ID, \$parent_id : ID, \$count : Int,  \$page : Int) {
            posts(user_id: \$user_id, hashtag_id : \$hashtag_id, parent_id : \$parent_id, count : \$count, page : \$page){
              id
              content 
              createdAt 
              nbComments 
              nbLikes 
              isLiked 
              hashtags{ id name }
              user{ 
                id
                firstname 
                lastname 
                school { id name  } 
                university{ id name }
                avatar{ name bucketname token } 
              }
              files{ name bucketname token }
            }
          }
          """, {
      'hashtag_id': hashtag_id,
      'user_id': user_id,
      'parent_id': parent_id,
      'count': count,
      'page': page
    }, cache: false).then((dynamic data){ return (data['posts'] as List<dynamic>)
        .map((dynamic post) => Post.fromJson(post))
        .toList(); });

  }

  static api.Mutation create({Function builder, Function onCompleted, Function update}) {
    return api.mutation(query: """      
         mutation addPost(\$content: String, \$privacy : String,  \$files : [FileInputDef], \$parent_id : ID) {
          addPost(content: \$content, privacy: \$privacy, files: \$files, parent_id : \$parent_id){
              id
            }
          }
          """, builder: builder, onCompleted: onCompleted, update: update);
  }



  static api.Mutation like({Function builder}) {
    return api.mutation(query: """      
         mutation likePost(\$post_id: ID!) {
          likePost(post_id: \$post_id){
                success
              }
          }
          """, builder: builder);
  }

  static api.Mutation unlike({Function builder}) {
    return api.mutation(query: """      
         mutation unlikePost(\$post_id: ID!) {
          unlikePost(post_id: \$post_id){
                success
              }
          }
          """, builder: builder);
  }
}
