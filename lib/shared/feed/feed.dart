import 'package:flutter/material.dart';

import 'post.dart';
import 'package:twic_app/api/models/post.dart';
import 'package:twic_app/api/services/posts.dart';

class Feed extends StatelessWidget {

  final int hashtag_id;
  final int user_id;

  Feed({this.hashtag_id, this.user_id});

  @override
  Widget build(BuildContext context) {
    return Posts.getList(
        hashtag_id: hashtag_id,
        user_id: user_id,
        builder: (List posts) {
          return ListView.builder(
            shrinkWrap: true,
            physics: NeverScrollableScrollPhysics(),
            itemBuilder: (BuildContext context, int index) {
              Post post = posts[0];
              return new PostWidget(post: post);
            },
            itemCount: 10,
          );
        });
  }
}
