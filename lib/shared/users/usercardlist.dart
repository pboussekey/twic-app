import 'package:flutter/material.dart';
import 'package:twic_app/api/models/models.dart';
import 'package:twic_app/shared/users/usercard.dart';
import 'package:twic_app/api/services/cache.dart';
import 'package:twic_app/shared/components/infinite_scroll.dart';

class UserCardList extends StatefulWidget {
  final List<User> list;
  final Axis direction;
  final int school_id;
  final int university_id;
  final String search;
  final bool follower;
  final bool following;
  final int user_id;
  final int major_id;
  final int minor_id;
  final int hashtag_id;
  final int class_year;
  final Widget placeholder;
  final Function onFollow;
  final int page;

  UserCardList(
      {this.list,
      this.direction = Axis.horizontal,
      this.school_id,
      this.university_id,
      this.search,
      this.follower,
      this.following,
      this.user_id,
      this.major_id,
      this.minor_id,
      this.hashtag_id,
      this.class_year,
      this.placeholder,
      this.onFollow,
      this.page,
      Key key})
      : super(key: key);

  @override
  State<StatefulWidget> createState() => UserCardListState(page: page);
}

class UserCardListState extends State<UserCardList> {
  int page = 0;
  bool loading = false;
  bool inited = false;
  final List<int> users = [];
  final ScrollController _controller = ScrollController();

  UserCardListState({this.page = 0});

  void _fetch() async {
    if (loading) return;
    loading = true;
    inited = true;
    AppCache.getId<User>(
        params: {
          "hashtag_id": widget.hashtag_id,
          "user_id": widget.user_id,
          "page": page,
          "school_id": widget.school_id,
          "university_id": widget.university_id,
          "search": widget.search,
          "follower": widget.follower,
          "following": widget.following,
          "major_id": widget.major_id,
          "minor_id": widget.minor_id,
          "class_year": widget.class_year,
          "count": 10
        },
        onCompleted: () {
          if (this.mounted) {
            print("REBUILD USER CARD LIST");
            setState(() {});
          }
        }).then((List<int> _users) {
      users.addAll(_users);
      loading = false;
      setState(() {});
      print([users.length, page]);
    });
    page++;
  }

  @override
  void initState() {
    users.clear();
    page = 0;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return users.length > 0 || null == widget.placeholder || inited == false
        ? Container(
            height: widget.direction == Axis.horizontal ? 250.0 : null,
            width: double.infinity,
            child: InfiniteScroll(
              scroll: _controller,
              shrink: false,
              direction: widget.direction,
              fetch: _fetch,
              builder: (BuildContext context, int index) =>
                  _build(context, index),
              count: ((users.length) + 1 / 2).floor(),
            ))
        : widget.placeholder;
  }

  Widget _build(BuildContext context, int index) {
    Size mediaSize = MediaQuery.of(context).size;
    if (widget.direction == Axis.horizontal) {
      return Padding(
        padding: EdgeInsets.only(
            left: index == 0 ? 20 : 0, right: 10.0, top: 20, bottom: 40),
        child: UserCard(
          user_id: users[index],
          onFollow: widget.onFollow,
        ),
      );
    } else {
      return index % 2 == 0
          ? Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[
                Padding(
                  padding: EdgeInsets.only(
                      right: 5.0,
                      top: index > 0 ? 0.0 : 10,
                      bottom: 5,
                      left: 20),
                  child: UserCard(
                    user_id: users[index],
                    width: (mediaSize.width - 45) / 2,
                  ),
                ),
                index + 1 < users.length
                    ? Padding(
                        padding: EdgeInsets.only(
                            top: index > 0 ? 0.0 : 10, bottom: 5),
                        child: UserCard(
                          user_id: users[index + 1],
                          width: (mediaSize.width - 45) / 2,
                          onFollow: widget.onFollow,
                        ))
                    : Container()
              ],
            )
          : Container();
    }
  }
}
