import 'package:flutter/material.dart';
import 'package:twic_app/api/models/models.dart';
import 'package:twic_app/shared/components/round_picture.dart';
import 'package:twic_app/style/style.dart';
import 'package:twic_app/shared/form/form.dart';
import 'package:twic_app/style/twic_font_icons.dart';

import 'package:twic_app/pages/profile/hashtag.dart';
import 'package:twic_app/shared/components/infinite_scroll.dart';
import 'package:twic_app/api/services/cache.dart';

class HashtagList extends StatefulWidget {
  final Function renderAction;
  final Function onClick;
  final int university_id;
  final String search;
  final bool followed;
  final int user_id;
  final Widget placeholder;
  final int page;
  final List<Hashtag> list;

  HashtagList(
      {this.renderAction,
      this.onClick,
      this.list,
      this.university_id,
      this.search,
      this.followed,
      this.user_id,
      this.placeholder,
      this.page = 0,
      Key key})
      : super(key: key);

  @override
  State<StatefulWidget> createState() => HashtagListState(page: page);
}

class HashtagListState extends State<HashtagList> {
  int page = 0;
  bool loading = false;
  bool initialized = false;
  final List<int> hashtags = [];
  final ScrollController _controller = ScrollController();

  HashtagListState({this.page = 0});

  void _fetch() async {
    if (loading) return;
    loading = true;
    initialized = true;
    AppCache.getId<Hashtag>(
        params: {
          "user_id": widget.user_id,
          "page": page,
          "university_id": widget.university_id,
          "search": widget.search,
          "followed": widget.followed,
          "count": 10
        },
        onCompleted: () {
          if (this.mounted) {
            setState(() {});
          }
        }).then((List<int> _hashtags) {
      hashtags.addAll(_hashtags);
      loading = false;
      if (mounted) {
        setState(() {});
      }
    });
    page++;
  }

  @override
  Widget build(BuildContext context) {
    Size mediaSize = MediaQuery.of(context).size;
    return Container(
        child: hashtags.length > 0 || null == widget.placeholder || !initialized
            ? InfiniteScroll(
                fetch: _fetch,
                scroll: _controller,
                shrink: false,
                count: hashtags.length,
                builder: (BuildContext context, int index) {
                  Hashtag hashtag = AppCache.getModel<Hashtag>(hashtags[index]);
                  if (null == hashtag) return Container();
                  return Button(
                      background: Colors.transparent,
                      onPressed: () => null != widget.onClick
                          ? widget.onClick(hashtag)
                          : Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (BuildContext context) =>
                                      HashtagProfile(
                                        hashtag_id: hashtags[index],
                                      ))),
                      padding: EdgeInsets.only(
                          top: 10.0, bottom: 10.0, left: 20.0, right: 20.0),
                      height: 51,
                      width: mediaSize.width,
                      child: Flex(
                          direction: Axis.horizontal,
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Stack(children: [
                                    RoundPicture(
                                      width: 20,
                                      padding: EdgeInsets.all(5),
                                      height: 20,
                                      background: Style.darkPurple,
                                      picture: 'assets/logo-white.png',
                                    ),
                                    Container(
                                      alignment: Alignment.bottomRight,
                                      height: 35.0,
                                      width: 35.0,
                                      child: ClipRRect(
                                          borderRadius:
                                              new BorderRadius.circular(20.0),
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
                                  ]),
                                  SizedBox(
                                    width: 10,
                                  ),
                                  Container(
                                      child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: <Widget>[
                                      Text("${hashtag.name}",
                                          style: Style.text),
                                      Text(
                                          "${hashtag.nbfollowers} follower${hashtag.nbfollowers > 1 ? 's' : ''}",
                                          style: Style.lightText),
                                    ],
                                  ))
                                ]),
                            null == widget.renderAction
                                ? Button(
                                    height: 30.0,
                                    padding: EdgeInsets.only(
                                        left: 10.0, right: 10.0),
                                    text: !hashtag.followed
                                        ? 'Follow'
                                        : 'Unfollow',
                                    background: !hashtag.followed
                                        ? Style.mainColor
                                        : Style.veryLightGrey,
                                    color: !hashtag.followed
                                        ? Colors.white
                                        : Style.lightGrey,
                                  )
                                : widget.renderAction(hashtag)
                          ]));
                },
              )
            : widget.placeholder);
  }
}
