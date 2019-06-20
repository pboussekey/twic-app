import 'package:flutter/material.dart';

import 'post.dart';
import 'package:twic_app/api/models/models.dart';
import 'package:twic_app/api/services/posts.dart';
import 'package:twic_app/shared/components/infinite_scroll.dart';

class Feed extends StatefulWidget {
  final int hashtag_id;
  final int school_id;
  final int user_id;
  final bool hideHeaders;
  final Widget placeholder;
  final ScrollController scroll;

  Feed(
      {this.hashtag_id,
      this.user_id,
      this.hideHeaders = false,
      this.placeholder,
      this.school_id,
      this.scroll });

  @override
  State<Feed> createState() => FeedState();
}

class FeedState extends State<Feed> {
  int page = 0;
  bool loading = false;
  bool initialized = false;
  final List<Post> posts = [];

  void _fetch() async {
    if (loading) return;
    loading = true;
    initialized = true;
    Posts.loadPosts(
            hashtag_id: widget.hashtag_id,
            user_id: widget.user_id,
            page: page,
            count: 5)
        .then((List<Post> _posts) {
      posts.addAll(_posts);
      loading = false;
      if (mounted) {
        setState(() {});
      }
    });
    page++;
  }

  @override
  Widget build(BuildContext context) =>
      posts.length > 0 || null == widget.placeholder || !initialized
          ? InfiniteScroll(
              fetch: _fetch,
              scroll: widget.scroll,
              builder: (BuildContext context, int index) => PostWidget(
                    post: posts[index],
                    hideHeader: widget.hideHeaders,
                  ),
              count: posts.length,
            )
          : widget.placeholder;
}
