import 'package:flutter/material.dart';
import 'package:twic_app/api/models/post.dart';
import 'package:twic_app/shared/feed/comment.dart';

class CommentsList extends StatelessWidget {
  final List<Post> comments;
  final int commentCount;

  CommentsList({this.comments, this.commentCount}){
    print("BUILD COMMENTS ${comments.length}");
  }

  @override
  Widget build(BuildContext context) => ListView.builder(
      shrinkWrap: true,
      physics: NeverScrollableScrollPhysics(),
      itemCount: comments.length,
      itemBuilder: (BuildContext context, int index) => CommentWidget(
            post: comments[index],
          ));
}
