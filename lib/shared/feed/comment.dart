import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import 'package:twic_app/style/style.dart';

import 'package:twic_app/shared/utils/round_picture.dart';
import 'package:twic_app/api/models/post.dart';
import 'package:twic_app/api/models/twic_file.dart';

class CommentWidget extends StatefulWidget {
  final Post post;

  CommentWidget({Key key, this.post}) : super(key: key);

  @override
  CommentWidgetState createState() => CommentWidgetState();
}

class CommentWidgetState extends State<CommentWidget>
{


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
    Size mediaSize = MediaQuery.of(context).size;
    return Container(
        color: Style.lightGrey.withAlpha(25),
        margin: EdgeInsets.only(bottom: 10.0),
        child: Column(
          children: <Widget>[
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Flex(
                direction: Axis.horizontal,
                children: <Widget>[
                  null != widget.post.user.avatar
                      ? RoundPicture(
                          picture: widget.post.user.avatar.href(),
                          height: 25,
                          width: 25,
                        )
                      : Icon(
                          Icons.account_circle,
                          color: Style.grey,
                          size: 25.0,
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
                                widget.post.user.university.name,
                                style: Style.lightText,
                                textAlign: TextAlign.start,
                              ),
                            )),
                      ],
                    ),
                  ),
                  IconButton(
                    icon: Icon(
                      widget.post.isLiked
                          ? Icons.favorite
                          : Icons.favorite_border,
                      color: Style.red,
                      size: 12.5,
                    ),
                  )
                ],
              ),
            ),
            Container(
              padding: EdgeInsets.symmetric(
                horizontal: 20,
              ),
              child: postText(widget.post.content),
            ),
            Row(
              children: <Widget>[
                Container(
                  padding: const EdgeInsets.only(right: 5.0, left: 50),
                  child: Icon(
                    Icons.flag,
                    color: Style.lightGrey,
                  ),
                ),
                Container(
                  padding: const EdgeInsets.only(right: 5.0),
                  child: Text(
                    widget.post.nbLikes.toString(),
                    style: Style.lightText,
                  ),
                ),
                Container(
                  padding: const EdgeInsets.only(right: 5.0),
                  child: Text(
                    _renderDate(widget.post.createdAt),
                    style: Style.lightText,
                  ),
                ),
                Container(
                  padding: const EdgeInsets.only(right: 5.0),
                  child: Text(
                      '${widget.post.nbLikes.toString()} like${widget.post.nbLikes > 1 ? "s" : ""}',
                      style: Style.lightText),
                ),
                Container(
                  padding: const EdgeInsets.only(right: 5.0),
                  child: Text('reply', style: Style.lightText),
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
