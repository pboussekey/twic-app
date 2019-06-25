import 'package:flutter/material.dart';

import 'package:twic_app/api/models/models.dart';
import 'package:twic_app/api/services/hashtags.dart';
import 'package:twic_app/api/services/conversations.dart';
import 'package:twic_app/shared/components/round_picture.dart';
import 'package:twic_app/style/style.dart';

import '../root_page.dart';
import 'package:twic_app/shared/feed/feed.dart';
import 'package:twic_app/shared/form/form.dart';
import 'package:twic_app/api/session.dart';
import 'package:twic_app/pages/profile/profile_followers.dart';
import 'package:twic_app/pages/profile/profile_followings.dart';
import 'package:twic_app/pages/posts/create.dart';
import 'package:twic_app/style/twic_font_icons.dart';
import 'package:twic_app/pages/chat/conversation.dart';

class HashtagProfile extends StatefulWidget {
  final int hashtag_id;

  HashtagProfile({this.hashtag_id});

  @override
  State createState() => HashtagProfileState();
}

class HashtagProfileState extends State<HashtagProfile> {

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: RootPage(
          child: Hashtags.get(
              id: widget.hashtag_id,
              builder: (Hashtag hashtag) => HashtagProfileContent(
                    hashtag_id: hashtag.id,
                    name: hashtag.name,
                    followed: hashtag.followed,
                    nb_followers: hashtag.nbfollowers,
                  ))),
    );
  }
}

class HashtagProfileContent extends StatefulWidget {
  int hashtag_id;
  String name;
  int nb_followers;
  bool followed;

  HashtagProfileContent(
      {this.hashtag_id,
      this.name,
      this.nb_followers,
      this.followed});

  @override
  State<HashtagProfileContent> createState() => HashtagProfileContentState();
}

class HashtagProfileContentState extends State<HashtagProfileContent> {
  bool loading = false;

  @override
  Widget build(BuildContext context) {
    Size mediaSize = MediaQuery.of(context).size;
    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: <
        Widget>[
      Padding(
          padding: EdgeInsets.only(left: 20.0, right: 20.0, top: 20.0),
          child:
              Column(crossAxisAlignment: CrossAxisAlignment.start, children: <
                  Widget>[
            Button(
              width: 25,
              height: 40,
              background: Colors.transparent,
              child: Icon(
                Icons.arrow_back,
                color: Style.lightGrey,
                size: 25,
              ),
              onPressed: () => Navigator.pop(context),
              padding: EdgeInsets.all(0),
            ),
            SizedBox(
              height: 10,
            ),
            Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
              Stack(
                children: <Widget>[
                  RoundPicture(
                    width: 30,
                    padding: EdgeInsets.all(5),
                    height: 30,
                    background: Style.darkPurple,
                    picture: 'assets/logo-white.png',
                  ),
                  Container(
                    alignment: Alignment.bottomRight,
                    height: 40.0,
                    width: 40.0,
                    child: ClipRRect(
                        borderRadius: new BorderRadius.circular(20.0),
                        child: Container(
                          child: Icon(
                            TwicFont.hashtag,
                            color: Colors.white,
                            size: 10,
                          ),
                          color: Style.mainColor,
                          height: 20,
                          width: 20,
                          alignment: Alignment.center,
                        )),
                  )
                ],
              ),
              Row(children: [
                widget.followed
                    ? Conversations.join(
                        onCompleted: (dynamic data) {
                          loading = false;
                          if (null != data) {
                            Conversation conversation =
                                Conversation.fromJson(data['joinChannel']);
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (BuildContext context) =>
                                        ConversationPage(
                                          conversation: conversation,
                                        )));
                          }
                        },
                        builder: (RunMutation join, QueryResult result) =>
                            Button(
                                text: "Channel",
                                height: 40,
                                color: Style.lightGrey,
                                background: Colors.transparent,
                                child: Row(
                                  children: <Widget>[
                                    Icon(
                                      Icons.group,
                                      color: Style.lightGrey,
                                    ),
                                    SizedBox(
                                      width: 5,
                                    ),
                                    Text("Channel", style: Style.greyText)
                                  ],
                                ),
                                border: Border.all(color: Style.border),
                                onPressed: () {
                                  if (!loading) {
                                    setState(() {
                                      loading = true;
                                    });
                                    join({'hashtag_id': widget.hashtag_id});
                                  }
                                }))
                    : Container(),
                SizedBox(
                  width: 5,
                ),
                widget.followed
                    ? Hashtags.unfollow(
                        builder: (RunMutation runMutation, QueryResult result) {
                        return Button(
                            child: Icon(
                              TwicFont.hashtag,
                              color: Colors.white,
                              size: 16,
                            ),
                            height: 40.0,
                            width: 40,
                            padding: EdgeInsets.all(0),
                            onPressed: () => setState(() {
                                  widget.followed = false;
                                  widget.nb_followers--;
                                  runMutation(
                                      {"hashtag_id": widget.hashtag_id});
                                }));
                      })
                    : Hashtags.follow(
                        builder: (RunMutation runMutation, QueryResult result) {
                        return Button(
                            text: 'Follow',
                            height: 40.0,
                            padding: EdgeInsets.all(0),
                            onPressed: () => setState(() {
                                  widget.followed = true;
                                  widget.nb_followers++;
                                  runMutation(
                                      {"hashtag_id": widget.hashtag_id});
                                }));
                      })
              ])
            ]),
            SizedBox(
              height: 10.0,
            ),
            Text("#${widget.name}", style: Style.titleStyle),
            SizedBox(
              height: 5.0,
            ),
            Text(
                "${widget.nb_followers} follower${widget.nb_followers > 1 ? 's' : ''}",
                style: Style.greyText),
            SizedBox(
              height: 40.0,
            ),
            Text('Top posts', style: Style.largeText),
            SizedBox(
              height: 20.0,
            )
          ])),
      Feed(
          hashtag_id: widget.hashtag_id,
          placeholder: Button(
            background: Colors.transparent,
            width: mediaSize.width,
            onPressed: () => Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (BuildContext context) => CreatePost(
                          share: '#${widget.name}',
                        ))),
            padding: EdgeInsets.all(0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                SizedBox(
                  height: 40,
                ),
                Image.asset(
                  'assets/empty-feed.png',
                  height: 60,
                ),
                SizedBox(
                  height: 20,
                ),
                Text("There are no posts", style: Style.titleStyle),
                Text("Create your first post.", style: Style.greyText),
                SizedBox(
                  height: 40,
                ),
              ],
            ),
          ))
    ]);
  }
}
