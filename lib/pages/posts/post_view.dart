import 'package:flutter/material.dart';
import 'package:twic_app/shared/feed/post.dart';
import 'package:twic_app/shared/feed/comment.dart';
import 'package:twic_app/api/models/post.dart';
import 'package:twic_app/api/services/posts.dart';
import 'package:twic_app/style/style.dart';
import 'package:twic_app/pages/root_page.dart';
import 'package:twic_app/shared/form/input.dart';
import 'package:twic_app/shared/form/button.dart';

class PostView extends StatefulWidget {
  Post post;

  PostView({@required this.post});

  @override
  State<PostView> createState() => PostViewState();
}

class PostViewState extends State<PostView> {
  Widget _renderComments(List<Post> posts) {
    return Container(
      color: Style.lightGrey.withAlpha(25),
      child: Column(
        children: <Widget>[
          SizedBox(
            height: 20,
          ),
          Text("Comments", style: Style.lightTitle),
          SizedBox(
            height: 20,
          ),
          Column(
              children: posts
                  .map((Post p) => CommentWidget(
                        post: p,
                      ))
                  .toList())
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final Size mediaSize = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
      ),
        body: RootPage(
            builder: () => Column(
                  children: <Widget>[
                    PostWidget(
                      post: widget.post,
                    ),
                    Posts.getList(
                        parent_id: widget.post.id,
                        builder: (List<Post> posts) => _renderComments(posts))
                  ],
                )),
        bottomNavigationBar: Container(
          height: 70.0,
          width: mediaSize.width,
          color: Style.greyBackground,
          child: Padding(
            padding: EdgeInsets.only(left: 20.0, right: 20.0, bottom: 10.0),
            child: Input(
              placeholder: "Type a message",
              after: Button(
                background: Colors.transparent,
                child: Icon(Icons.arrow_forward, color: Style.lightGrey),
              ),
            ),
          ),
        ));
  }
}
