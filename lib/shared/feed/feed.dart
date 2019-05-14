import 'package:flutter/material.dart';

import 'post.dart';
import 'package:twic_app/api/models/post.dart';
import 'package:twic_app/api/services/posts.dart';
import 'package:twic_app/shared/components/infinite_scroll.dart';

class Feed extends StatefulWidget {
  final int hashtag_id;
  final int user_id;

  Feed({this.hashtag_id, this.user_id});

  @override
  State<Feed> createState() => FeedState();
}

class FeedState extends State<Feed> {
  int page = 0;
  bool loading = false;
  final List<Post> posts = [];

  void _fetch() async {
    if(loading) return;
    loading = true;
    Posts.loadPosts(
            hashtag_id: widget.hashtag_id,
            user_id: widget.user_id,
            page: page,
            count: 3)
        .then((List<Post> _posts) {
      posts.addAll(_posts);
      print(posts);
      loading = false;
      setState(() {});
    });
    page++;
  }


  @override
  Widget build(BuildContext context) => InfiniteScroll(
    fetch: _fetch,
    builder: (BuildContext context, int index) => PostWidget(post: posts[index]),
    count: posts.length,
  );
}
