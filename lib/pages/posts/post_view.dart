import 'package:flutter/material.dart';
import 'package:twic_app/shared/feed/comment.dart';
import 'package:twic_app/api/models/models.dart';
import 'package:twic_app/api/services/posts.dart';
import 'package:twic_app/style/style.dart';
import 'package:twic_app/pages/root_page.dart';
import 'package:twic_app/shared/form/form.dart';
import 'package:twic_app/shared/components/slider.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:twic_app/shared/components/round_picture.dart';
import 'package:twic_app/shared/feed/comments_list.dart';
import 'package:intl/intl.dart';
import 'package:twic_app/api/session.dart';

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
      text: TextSpan(text: first.text, style: first.style, children: children));
}

class PostView extends StatefulWidget {
  Post post;

  PostView({@required this.post});

  @override
  State<PostView> createState() => PostViewState();
}

class PostViewState extends State<PostView> {
  @override
  Widget build(BuildContext context) {
    return RootPage(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
        actions: <Widget>[
          IconButton(
            icon: Icon(
              Icons.more_horiz,
              color: Style.lightGrey,
            ),
          )
        ],
      ),
      backgroundColor: Style.lightGrey.withAlpha(25),
      scrollable: false,
      child: Posts.create(
          builder: (RunMutation runMutation, QueryResult result) =>
              Posts.getList(
                parent_id: widget.post.id,
                builder: (List<Post> comments) {
                  return _PostView(
                    post: widget.post,
                    comments: comments,
                    addComment: runMutation,
                  );
                },
              )),
    );
  }
}

class _PostView extends StatefulWidget {
  final Post post;
  final Function addComment;
  final List<Post> comments;

  _PostView({this.post, this.comments, this.addComment});

  @override
  State<StatefulWidget> createState() => _PostViewState(comments: comments);
}

class _PostViewState extends State<_PostView> {
  final controller = TextEditingController();
  final List<Post> comments;
  String content = "";
  bool sending = false;

  _PostViewState({this.comments}) {
    controller.addListener(() {
      if (controller.text.isEmpty) {
        setState(() {
          content = "";
        });
      } else {
        setState(() {
          content = controller.text;
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final Size mediaSize = MediaQuery.of(context).size;
    return Stack(children: [
      SingleChildScrollView(
          child:
              Column(crossAxisAlignment: CrossAxisAlignment.start, children: <
                  Widget>[
        Container(
            color: Colors.white,
            child:
                Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              null != widget.post.files && widget.post.files.isNotEmpty
                  ? FileSlider(
                      files: widget.post.files,
                      builder: (TwicFile f) => CachedNetworkImage(
                            width: mediaSize.width,
                            height: mediaSize.width * 0.6,
                            fit: BoxFit.cover,
                            imageUrl: f.href(),
                            placeholder: (context, url) => Center(
                                child: Container(
                                    child: CircularProgressIndicator())),
                            fadeOutDuration: new Duration(seconds: 1),
                            fadeInDuration: new Duration(seconds: 1),
                          ),
                    )
                  : Container(),
              SizedBox(
                height: 10,
              ),
              Container(
                  padding: EdgeInsets.symmetric(horizontal: 20),
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
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 10.0),
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
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 10.0),
                                  child: Text(
                                    widget.post.user.university.name,
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
                        textAlign: TextAlign.start,
                      )
                    ],
                  )),
              null != widget.post.content && widget.post.content.isNotEmpty
                  ? Container(
                      padding:
                          const EdgeInsets.only(top: 10.0, left: 20, right: 20),
                      child: postText(widget.post.content),
                    )
                  : Container(),
              SizedBox(
                height: 10,
              ),
              Row(children: <Widget>[
                Container(
                  padding: const EdgeInsets.only(right: 5.0, left: 20),
                  child: Icon(
                    widget.post.isLiked
                        ? Icons.favorite
                        : Icons.favorite_border,
                    color: Style.red,
                  ),
                ),
                Container(
                  padding: const EdgeInsets.only(right: 5.0),
                  child: Text(
                    widget.post.nbLikes.toString(),
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
                  child: Text(widget.post.nbComments.toString(),
                      style: Style.text),
                ),
              ]),
              SizedBox(
                height: 10,
              ),
            ])),
        Container(
            width: mediaSize.width,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[
                SizedBox(
                  height: 20,
                ),
                Padding(
                    padding: EdgeInsets.only(left: 20, right: 20),
                    child: Text("Comments", style: Style.lightTitle)),
                SizedBox(
                  height: 20,
                ),
                CommentsList(
                  comments: comments,
                ),
                SizedBox(
                  height: 70,
                ),
              ],
            ))
      ])),
      Positioned(
        bottom: 0,
        right: 0,
        left: 0,
        child: Container(
          padding: EdgeInsets.only(left: 20.0, right: 20.0, bottom: 10.0),
          child: Input(
            height: 50,
            controller: controller,
            placeholder: "Type a message",
            after: Button(
              background: Colors.transparent,
              padding: EdgeInsets.all(0),
              child: Icon(Icons.arrow_forward, color: Style.mainColor),
              onPressed: () {
                if (sending || content.isEmpty) return;
                sending = true;
                widget.addComment({
                  'parent_id': widget.post.id,
                  'content': content,
                });
                widget.post.nbComments++;
                comments.add(Post(
                    content: content,
                    createdAt: DateTime.now(),
                    user: Session.instance.user));
                setState(() {});
                content = "";
                controller.text = "";
                sending = false;
              },
            ),
          ),
        ),
      )
    ]);
  }
}
