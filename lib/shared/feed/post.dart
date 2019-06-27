import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import 'package:twic_app/style/style.dart';
import 'package:twic_app/style/twic_font_icons.dart';

import 'package:twic_app/shared/components/round_picture.dart';
import 'package:twic_app/shared/users/avatar.dart';
import 'package:twic_app/api/models/models.dart';
import 'package:twic_app/shared/components/slider.dart';
import 'package:twic_app/shared/form/form.dart';
import 'package:twic_app/pages/posts/post_view.dart';
import 'package:twic_app/pages/profile/hashtag.dart';
import 'package:twic_app/pages/profile/profile.dart';
import 'package:twic_app/api/services/posts.dart';
import 'package:flutter/gestures.dart';
import 'package:chewie/chewie.dart';
import 'package:video_player/video_player.dart';

class PostWidget extends StatefulWidget {
  final Post post;
  final bool hideHeader;

  PostWidget({Key key, this.post, this.hideHeader = false}) : super(key: key);

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
    RegExp exp = new RegExp(r"[#@][^\s\\]+");
    Iterable<Match> matches = exp.allMatches(content);
    List<TextSpan> children = [];

    int idx = 0;
    matches.forEach((_match) {
      String text = content.substring(idx, _match.start);
      String match = content.substring(_match.start, _match.end);
      children.add(TextSpan(text: text, style: Style.text));
      children.add(TextSpan(
          text: ' ' + match,
          style: Style.hashtagStyle,
          recognizer: new TapGestureRecognizer()
            ..onTap = () {
              if (match.startsWith(("#"))) {
                Hashtag hashtag = widget.post.hashtags.firstWhere((Hashtag h) =>
                    h.name.toLowerCase() ==
                    match.replaceAll("#", "").toLowerCase());
                if (null != hashtag) {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (BuildContext context) => HashtagProfile(
                                hashtag_id: hashtag.id,
                              )));
                }
              } else {
                User user = widget.post.mentions.firstWhere((User u) =>
                    (u.firstname + u.lastname).toLowerCase() ==
                    match.replaceAll("@", "").toLowerCase());
                if (null != user) {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (BuildContext context) => Profile(
                                user_id: user.id,
                              )));
                }
              }
            }));
      idx = _match.end;
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
                  !widget.hideHeader
                      ? Avatar(
                          href: widget.post.user?.avatar?.href(),
                          size: 40,
                        )
                      : Container(),
                  !widget.hideHeader
                      ? Expanded(
                          child: Column(
                            children: <Widget>[
                              Align(
                                  alignment: Alignment.centerLeft,
                                  child: Container(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 10.0),
                                    child: Text(
                                      widget.post.user.firstname +
                                          " " +
                                          widget.post.user.lastname,
                                      style: Style.largeText,
                                      textAlign: TextAlign.start,
                                    ),
                                  )),
                              Align(
                                  alignment: Alignment.centerLeft,
                                  child: Container(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 10.0),
                                    child: Text(
                                      widget.post.user.institution.name,
                                      style: Style.lightText,
                                      textAlign: TextAlign.start,
                                    ),
                                  )),
                            ],
                          ),
                        )
                      : Container(),
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
                    builder: (TwicFile f) {
                      return Container(
                          padding: EdgeInsets.symmetric(horizontal: 20.0),
                          child: f.type.startsWith('image')
                              ? RoundPicture(
                                  picture: f.getPreview(),
                                  fit: BoxFit.cover,
                                  width: width - 40,
                                  height: width * 0.4,
                                  radius: 8.0,
                                )
                              : ((f.type.startsWith('video') &&
                                      null != f.preview)
                                  ? Chewie(
                                      controller: ChewieController(
                                      videoPlayerController:
                                          VideoPlayerController.network(
                                              f.href()),
                                      autoPlay: true,
                                      looping: true,
                                      placeholder: null != f.preview
                                          ?
                                                  RoundPicture(
                                                    picture: f.getPreview(),
                                                    fit: BoxFit.cover,
                                                    width: width - 40,
                                                    height: width * 0.4,
                                                    radius: 0,
                                                  )
                                          : Container(),
                                    ))
                                  : Container(
                                      width: width - 40,
                                      height: width * 0.4,
                                      alignment: Alignment(0, 0),
                                      decoration: BoxDecoration(
                                          border:
                                              Border.all(color: Style.border),
                                          borderRadius: BorderRadius.all(
                                              Radius.circular(8.0))),
                                      child: Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: <Widget>[
                                          RoundPicture(
                                            picture: f.getPreview(),
                                            fit: BoxFit.cover,
                                            width: 40,
                                            height: 40,
                                            radius: 0,
                                          ),
                                          null != f.name
                                              ? SizedBox(
                                                  height: 10,
                                                )
                                              : Container(),
                                          null != f.name
                                              ? Text(f.name,
                                                  style: Style.largeText)
                                              : Container()
                                        ],
                                      ),
                                    )));
                    },
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
                                    TwicFont.plain_heart,
                                    color: Style.red,
                                    size: 14,
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
                                    TwicFont.empty_heart,
                                    color: Style.red,
                                    size: 14,
                                  ),
                                  onPressed: () {
                                    runMutation({'post_id': widget.post.id});
                                    widget.post.isLiked = true;
                                    widget.post.nbLikes++;
                                    setState(() {});
                                  },
                                ))),
                Container(
                  width: 20,
                  padding: const EdgeInsets.only(right: 5.0),
                  child: Text(widget.post.nbLikes.toString(),
                      style: Style.get(
                          color: Style.darkGrey,
                          fontSize: 14,
                          fontWeight: FontWeight.w600)),
                ),
                Button(
                  padding: EdgeInsets.all(0),
                  background: Colors.transparent,
                  height: 30,
                  child: Row(children: [
                    Icon(
                      TwicFont.comment,
                      color: Style.blue,
                      size: 18,
                    ),
                    SizedBox(
                      width: 5,
                    ),
                    Text(widget.post.nbComments.toString(),
                        style: Style.get(
                            color: Style.darkGrey,
                            fontSize: 14,
                            fontWeight: FontWeight.w600)),
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
