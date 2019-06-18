import 'package:flutter/material.dart';
import 'package:twic_app/api/models/models.dart';
import 'package:twic_app/shared/users/avatar.dart';
import 'package:twic_app/style/style.dart';
import 'package:twic_app/shared/form/form.dart';
import 'package:twic_app/api/services/users.dart';
import 'package:twic_app/shared/components/infinite_scroll.dart';

class UserList extends StatefulWidget {
  final List<User> list;
  final Function renderAction;
  final Function onClick;
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

  UserList(
      {this.list,
      this.renderAction,
      this.onClick,
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
      Key key})
      : super(key: key);

  @override
  State<StatefulWidget> createState() => UserListState();
}

class UserListState extends State<UserList> {
  bool loading = false;
  final List<int> users = [];
  final ScrollController _controller = ScrollController();
  int page = 0;

  @override
  void initState() {
    users.clear();
    page = 0;
    super.initState();
  }

  void _fetch() async {
    if (loading) return;
    loading = true;
    Users.getId(
            hashtag_id: widget.hashtag_id,
            user_id: widget.user_id,
            page: page,
            school_id: widget.school_id,
            university_id: widget.university_id,
            search: widget.search,
            follower: widget.follower,
            following: widget.following,
            major_id: widget.major_id,
            minor_id: widget.minor_id,
            class_year: widget.class_year,
            onCompleted: () {
              if (this.mounted) {
                setState(() {});
              }
            },
            count: 10)
        .then((List<int> _users) {
      users.addAll(_users);
      loading = false;
      if (mounted) {
        setState(() {});
      }
    });
    page++;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
        child: InfiniteScroll(
      fetch: _fetch,
      scroll: _controller,
      shrink: false,
      count: users.length,
      builder: (BuildContext context, int index) {
        User user = Users.list[users[index]];
        if (null == user) {
          return Container();
        }
        return Button(
            background: Colors.transparent,
            radius: BorderRadius.all(Radius.circular(0)),
            padding: EdgeInsets.only(
                top: 10.0, bottom: 10.0, left: 20.0, right: 20.0),
            height: 51,
            onPressed: () =>
                null != widget.onClick ? widget.onClick(users[index]) : null,
            child: Flex(
                direction: Axis.horizontal,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
                    Avatar(
                      href: user?.avatar?.href(),
                      size: 30.0,
                    ),
                    SizedBox(
                      width: 10,
                    ),
                    Container(
                        child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Text("${user.firstname} ${user.lastname}",
                            style: Style.text),
                        Text("${user.institution.name}",
                            style: Style.lightText),
                      ],
                    ))
                  ]),
                  null == widget.renderAction
                      ? Button(
                          height: 30.0,
                          padding: EdgeInsets.only(left: 10.0, right: 10.0),
                          text: user.followed ? 'Unfollow' : 'Follow',
                          background: user.followed
                              ? Style.veryLightGrey
                              : Style.mainColor,
                          color: user.followed ? Style.lightGrey : Colors.white,
                        )
                      : widget.renderAction(user)
                ]));
      },
    ));
  }
}
