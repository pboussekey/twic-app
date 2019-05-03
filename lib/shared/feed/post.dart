import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import 'package:twic_app/style/style.dart';

import 'package:twic_app/shared/utils/round_picture.dart';
import 'package:twic_app/api/models/post.dart';
import 'package:twic_app/api/models/twic_file.dart';

RichText postText(String content) {
  RegExp exp = new RegExp(r"#[A-Za-z0-9\-\.]+");
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
      text: TextSpan(text: first.text, style: first.style, children: children));
}

Widget _renderPictures(List<TwicFile> files) {
  List<Widget> pictures = [];
  files.forEach((file) => pictures.add(RoundPicture(
        picture: file.href(),
        fit: BoxFit.fitWidth,
        radius: 8.0,
      )));
  return Column(children: pictures);
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

class PostWidget extends StatelessWidget {
  final Post post;

  PostWidget({Key key, this.post}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
        color: Colors.white,
        margin: EdgeInsets.only(left: 20.0, right: 20.0, bottom: 20.0),
        child: Column(
          children: <Widget>[
            Container(
              padding: const EdgeInsets.symmetric(vertical: 10.0),
              child: Flex(
                direction: Axis.horizontal,
                children: <Widget>[
                  null != post.user.avatar
                      ? RoundPicture(picture: post.user.avatar.href())
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
                                post.user.firstname + " " + post.user.lastname,
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
                                post.user.university.name,
                                style: Style.lightText,
                                textAlign: TextAlign.start,
                              ),
                            )),
                      ],
                    ),
                  ),
                  Text(
                    _renderDate(post.createdAt),
                    style: Style.lightText,
                  )
                ],
              ),
            ),
            null != post.files ? _renderPictures(post.files) : Container(),
            Container(
              padding: const EdgeInsets.symmetric(vertical: 10.0),
              child: postText(post.content),
            ),
            Row(
              children: <Widget>[
                Container(
                  padding: const EdgeInsets.only(right: 5.0),
                  child: Icon(
                    post.isLiked ? Icons.favorite : Icons.favorite_border,
                    color: Style.red,
                  ),
                ),
                Container(
                  padding: const EdgeInsets.only(right: 5.0),
                  child: Text(
                    post.nbLikes.toString(),
                    style: Style.text,
                  ),
                ),
                Container(
                  padding: const EdgeInsets.only(right: 5.0),
                  child: Icon(
                    Icons.mode_comment,
                    color: Style.blue,
                  ),
                ),
                Container(
                  padding: const EdgeInsets.only(right: 5.0),
                  child: Text(post.nbComments.toString(), style: Style.text),
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
              ],
            )
          ],
        ));
  }
}
