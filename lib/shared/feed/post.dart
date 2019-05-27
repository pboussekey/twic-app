import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import 'package:twic_app/style/style.dart';

import 'package:twic_app/shared/components/round_picture.dart';
import 'package:twic_app/api/models/models.dart';
import 'package:twic_app/shared/components/slider.dart';
import 'package:twic_app/shared/form/form.dart';
import 'package:twic_app/pages/posts/post_view.dart';
import 'package:twic_app/api/services/posts.dart';

class PostWidget extends StatefulWidget {
  final Post post;

  PostWidget({Key key, this.post}) : super(key: key);

  @override
  PostWidgetState createState() => PostWidgetState();
}

class PostWidgetState extends State<PostWidget>
    with SingleTickerProviderStateMixin {
  TabController _controller;
  int index = 0;
  bool dragging = false;

  @override
  void initState() {
    super.initState();

    _controller = new TabController(
        length: widget.post.files.length, vsync: this, initialIndex: 0);
  }

  RichText postText(String content) {
    RegExp exp = new RegExp(r"#[A-Za-z0-9]+");
    Iterable<Match> matches = exp.allMatches(content);
    List<TextSpan> children = [];

    int idx = 0;
    matches.forEach((hashtag) {
      String text = content.substring(idx, hashtag.start);
      String hash = content.substring(hashtag.start, hashtag.end);
      children.add(TextSpan(text: text, style: Style.text));
      children.add(TextSpan(text: ' ' + hash + ' ', style: Style.hashtagStyle));
      idx = hashtag.end;
    });
    children.add(TextSpan(text: content.substring(idx), style: Style.text));
    TextSpan first = children.removeAt(0);
    return RichText(
        text:
            TextSpan(text: first.text, style: first.style, children: children));
  }

  String _renderDate(DateTime date) {
    Duration since = DateTime.now().difference(date);

    if (since.inSeconds < 60) {
      return '${since.inSeconds}s';
    } else if (since.inMinutes < 60) {
      return '${since.inMinutes}m';
    } else if (since.inHours < 24) {
      return '${since.inHours}h';
    } else if (since.inDays < 30) {
      return '${since.inDays}d';
    }

    return DateFormat.yMMMd().format(new DateTime.now());
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    print(widget.post.user.toJson());
    return Container(
        color: Colors.white,
        margin: EdgeInsets.only(bottom: 20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Container(
              padding:
                  const EdgeInsets.symmetric(vertical: 10.0, horizontal: 20),
              child: Flex(
                direction: Axis.horizontal,
                children: <Widget>[
                  null != widget.post.user.avatar
                      ? RoundPicture(
                          picture: widget.post.user.avatar.href(),
                          height: 40,
                          width: 40,
                        )
                      : Icon(
                          Icons.account_circle,
                          color: Style.grey,
                          size: 40.0,
                        ),
                  Expanded(
                    child: Column(
                      children: <Widget>[
                        Align(
                            alignment: Alignment.centerLeft,
                            child: Container(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 10.0),
                              child: Text(
                                widget.post.user.firstname +
                                    " " +
                                    widget.post.user.lastname,
                                style: Style.titleStyle,
                                textAlign: TextAlign.start,
                              ),
                            )),
                        Align(
                            alignment: Alignment.centerLeft,
                            child: Container(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 10.0),
                              child: Text(
                                widget.post.user.institution.name,
                                style: Style.lightText,
                                textAlign: TextAlign.start,
                              ),
                            )),
                      ],
                    ),
                  ),
                  Text(
                    _renderDate(widget.post.createdAt),
                    style: Style.lightText,
                  )
                ],
              ),
            ),
            null != widget.post.files && widget.post.files.length > 0
                ? FileSlider(
                    files: widget.post.files,
                    builder: (TwicFile f) => Container(
                        padding: EdgeInsets.symmetric(horizontal: 20.0),
                        child: RoundPicture(
                          picture: f.href(),
                          fit: BoxFit.cover,
                          width: width - 40,
                          height: width * 0.4,
                          radius: 8.0,
                        )),
                  )
                : Container(),
            null != widget.post.content && widget.post.content.isNotEmpty
                ? Container(
                    padding: const EdgeInsets.symmetric(
                        vertical: 10.0, horizontal: 20),
                    child: postText(widget.post.content),
                  )
                : Container(),
            Row(
              children: <Widget>[
                Container(
                    padding: const EdgeInsets.only(right: 5.0, left: 20),
                    child: widget.post.isLiked
                        ? Posts.unlike(
                            builder: (RunMutation runMutation,
                                    QueryResult result) =>
                                Button(
                                  background: Colors.transparent,
                                  padding: const EdgeInsets.all(0),
                                  width: 25,
                                  height: 25,
                                  child: Icon(
                                    Icons.favorite,
                                    color: Style.red,
                                  ),
                                  onPressed: () {
                                    runMutation({'post_id': widget.post.id});
                                    widget.post.isLiked = false;
                                    widget.post.nbLikes--;
                                    setState(() {});
                                  },
                                ))
                        : Posts.like(
                            builder: (RunMutation runMutation,
                                    QueryResult result) =>
                                Button(
                                  background: Colors.transparent,
                                  padding: const EdgeInsets.all(0),
                                  width: 25,
                                  height: 25,
                                  child: Icon(
                                    Icons.favorite_border,
                                    color: Style.red,
                                  ),
                                  onPressed: () {
                                    runMutation({'post_id': widget.post.id});
                                    widget.post.isLiked = true;
                                    widget.post.nbLikes++;
                                    setState(() {});
                                  },
                                ))),
                Container(
                  padding: const EdgeInsets.only(right: 5.0),
                  child: Text(
                    widget.post.nbLikes.toString(),
                    style: Style.text,
                  ),
                ),
                Button(
                  padding: EdgeInsets.all(0),
                  background: Colors.transparent,
                  height: 30,
                  child: Row(children: [
                    Icon(
                      Icons.mode_comment,
                      color: Style.blue,
                    ),
                    SizedBox(
                      width: 5,
                    ),
                    Text(widget.post.nbComments.toString(), style: Style.text),
                    SizedBox(
                      width: 5,
                    )
                  ]),
                  onPressed: () => Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (BuildContext context) => PostView(
                                post: widget.post,
                              ))),
                ),
                Expanded(
                  child: Align(
                    alignment: Alignment.centerRight,
                    child: Icon(
                      Icons.more_horiz,
                      color: Style.lightGrey,
                    ),
                  ),
                ),
                SizedBox(
                  width: 20,
                )
              ],
            )
          ],
        ));
  }
}
