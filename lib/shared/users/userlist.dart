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
  final UniqueKey listKey;
  final int page;

  UserList(
      {this.list, this.renderAction, this.onClick,
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
        this.listKey,
        this.page = 0});

  @override
  State<StatefulWidget> createState() => UserListState(page: page);


}

class UserListState extends State<UserList>{

  int page = 0;
  bool loading = false;
  final List<User> users = [];
  final ScrollController _controller = ScrollController();

  UserListState({this.page = 0});


  void _fetch() async {
    if (loading) return;
    loading = true;
    Users.loadUsers(
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
        count: 10)
        .then((List<User> _users) {
      users.addAll(_users);
      loading = false;
      if(mounted){setState(() {});}
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
          builder: (BuildContext context, int index) => Button(
            background: Colors.transparent,
              radius: BorderRadius.all(Radius.circular(0)),
              padding:
              EdgeInsets.only(top: 10.0, bottom: 10.0, left: 20.0, right: 20.0),
              height: 51,
              onPressed: () => null != widget.onClick ? widget.onClick(users[index]) : null,
              child: Flex(
                  direction: Axis.horizontal,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Avatar(
                            href: users[index]?.avatar?.href(),
                            size: 30.0,
                          ),
                          SizedBox(
                            width: 10,
                          ),
                          Container(
                              child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              Text(
                                  "${users[index].firstname} ${users[index].lastname}",
                                  style: Style.text),
                              Text("${users[index].institution.name}",
                                  style: Style.lightText),
                            ],
                          ))
                        ]),
                    null == widget.renderAction ? Button(
                      height: 30.0,
                      padding: EdgeInsets.only(left : 10.0, right : 10.0),
                      text: users[index].followed ? 'Unfollow' : 'Follow',
                      background: users[index].followed
                          ? Style.veryLightGrey
                          : Style.mainColor,
                      color: users[index].followed
                          ? Style.lightGrey
                          : Colors.white,
                    ) : widget.renderAction(users[index])
                  ])),
        ));
  }
}
