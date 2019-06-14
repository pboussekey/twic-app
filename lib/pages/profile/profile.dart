import 'package:flutter/material.dart';

import 'package:twic_app/api/models/models.dart';
import 'package:twic_app/api/services/users.dart';
import 'package:twic_app/shared/users/avatar.dart';
import 'package:twic_app/style/style.dart';

import '../root_page.dart';
import 'package:twic_app/shared/feed/feed.dart';
import 'package:twic_app/shared/form/form.dart';
import 'package:twic_app/api/session.dart';
import 'package:twic_app/shared/components/bottom_nav.dart';
import 'package:twic_app/pages/profile/profile_followers.dart';
import 'package:twic_app/pages/profile/profile_followings.dart';
import 'package:twic_app/pages/profile/profile_edition.dart';
import 'package:twic_app/pages/profile/school.dart';
import 'package:twic_app/pages/posts/create.dart';

class Profile extends StatefulWidget {
  final int user_id;

  Profile({this.user_id});

  @override
  State createState() => ProfileState();
}

class ProfileState extends State<Profile> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: RootPage(
            child: Users.get(
                id: widget.user_id,
                builder: (User user) => ProfileContent(
                      avatar: user.avatar.href(),
                      description: user.description,
                      firstname: user.firstname,
                      lastname: user.lastname,
                      major: user.major?.name,
                      minor: user.minor?.name,
                      nb_followers: user.nbFollowers,
                      nb_followings: user.nbFollowings,
                      nb_posts: user.nbPosts,
                      classYear: user.classYear,
                      school: user.school.name,
                      university: user.institution.name,
                      university_id: user.institution.id,
                      university_logo:
                          user.institution.logo.href(),
                      user_id: user.id,
                    ))),
        bottomNavigationBar: BottomNav(
          current: ButtonEnum.Profile,
          refresh: setState,
        ));
  }
}

class ProfileContent extends StatefulWidget {
  int user_id;
  String avatar;
  String firstname;
  String lastname;
  String university;
  String school;
  int university_id;
  String university_logo;
  String major;
  String minor;
  String description;
  int nb_followers;
  int nb_followings;
  int nb_posts;
  int nb_channels;
  int classYear;

  ProfileContent(
      {this.description,
      this.firstname,
      this.school,
      this.avatar,
      this.lastname,
      this.major,
      this.minor,
      this.nb_channels,
      this.nb_followers,
      this.nb_followings,
      this.nb_posts,
      this.classYear,
      this.university,
      this.university_logo,
        this.university_id,
      this.user_id});

  @override
  State<ProfileContent> createState() => ProfileContentState();
}

class ProfileContentState extends State<ProfileContent> {
  @override
  Widget build(BuildContext context) {
    Size mediaSize = MediaQuery.of(context).size;
    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      Container(
          child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Padding(
            padding: EdgeInsets.only(left: 20.0, right: 20.0, top: 20.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Avatar(
                        href: widget.avatar,
                      ),
                      Session.instance.user.id == widget.user_id
                          ? Button(
                              text: "Edit profile",
                              height: 40,
                              color: Style.lightGrey,
                              background: Colors.transparent,
                              border: Border.all(color: Style.lightGrey),
                              onPressed: () => Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (BuildContext context) =>
                                              ProfileEdition())).then(
                                    (dynamic value) => setState(() {
                                          widget.firstname = value['avatar'];
                                          widget.lastname = value['lastname'];
                                          widget.description =
                                              value['description'];
                                          widget.classYear = value['classYear'];
                                          widget.avatar = value['avatar'];
                                          widget.school = value['school'];
                                          widget.university =
                                              value['university'];
                                          widget.university_logo =
                                              value['university_logo'];
                                          widget.minor = value['minor'];
                                          widget.major = value['major'];
                                        }),
                                  ))
                          : Container()
                    ]),
                SizedBox(
                  height: 10.0,
                ),
                Row(children: [
                  Text("${widget.firstname} ${widget.lastname}",
                      style: Style.titleStyle),
                  null != widget.classYear
                      ? Text(
                          "'${widget.classYear % 100}",
                          style: Style.lightTitle,
                        )
                      : Container()
                ]),
                Button(
                    background: Colors.transparent,
                    padding: EdgeInsets.all(0),
                    onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (BuildContext context) => SchoolProfile(school_id: widget.university_id,) )),
                    child : Row(children: [
                  null != widget.university_logo
                      ? Container(
                          padding: EdgeInsets.all(4.0),
                          decoration: BoxDecoration(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(4)),
                              border: Border.all(
                                  width: 1,
                                  color: Style.border,
                                  style: BorderStyle.solid)),
                          child: Image.network(
                            widget.university_logo,
                            height: 12.0,
                            width: 12.0,
                          ))
                      : Container(),
                  SizedBox(
                    width: 10.0,
                  ),
                  Column(
                    children: <Widget>[
                      Text(widget.university, style: Style.hashtagStyle),
                      null != widget.school && widget.school != widget.university
                          ? Text(widget.school, style: Style.smallGreyText)
                          : Container(),
                    ],
                  )
                ])),
                null != widget.major || null != widget.minor ? SizedBox(
                  height: 10.0,
                ) : Container(),
                Row(children: [
                  null != widget.major
                      ? Container(
                          padding: EdgeInsets.only(
                              top: 4.0, bottom: 5.0, left: 10.0, right: 10.0),
                          height: 20.0,
                          decoration: BoxDecoration(
                            borderRadius:
                                BorderRadius.all(Radius.circular(10.0)),
                            color: Style.grey,
                          ),
                          child:
                              Text(widget.major, style: Style.smallWhiteText),
                        )
                      : Container(),
                  SizedBox(
                    width: 10.0,
                  ),
                  null != widget.minor
                      ? Container(
                          padding: EdgeInsets.only(
                              top: 4.0, bottom: 5.0, left: 10.0, right: 10.0),
                          height: 20.0,
                          decoration: BoxDecoration(
                            borderRadius:
                                BorderRadius.all(Radius.circular(10.0)),
                            color: Style.veryLightGrey,
                          ),
                          child: Text(widget.minor, style: Style.smallGreyText),
                        )
                      : Container(),
                ]),
              ],
            ),
          ),
          null != widget.major || null != widget.minor ? SizedBox(
            height: 10.0,
          ) : Container(),
          null != widget.description
              ? Padding(
                  padding: EdgeInsets.symmetric(horizontal: 20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      SizedBox(
                        height: 10.0,
                        child: Container(
                          decoration: BoxDecoration(
                              border: Border(
                                  bottom: BorderSide(
                                      width: 1,
                                      color: Style.border,
                                      style: BorderStyle.solid))),
                        ),
                      ),
                      Text(
                        widget.description,
                        style: Style.get(fontSize: 12, color: Style.grey),
                        textAlign: TextAlign.start,
                      ),
                    ],
                  ))
              : Container(),
          Padding(
              padding: EdgeInsets.symmetric(horizontal: 20),
              child: SizedBox(
                height: 10.0,
                child: Container(
                  decoration: BoxDecoration(
                      border: Border(
                          bottom: BorderSide(
                              width: 1,
                              color: Style.border,
                              style: BorderStyle.solid))),
                ),
              )),
          Padding(
            padding: EdgeInsets.only(left: 10.0, right: 10.0),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                Container(
                    width: (mediaSize.width - 20) / 4,
                    child: FlatButton(
                        padding: EdgeInsets.all(0.0),
                        onPressed: () => Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (BuildContext context) =>
                                    ProfileFollowers(user_id: widget.user_id))),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Text(widget.nb_followers.toString(),
                                style: Style.largeText),
                            Text('FOLLOWERS', style: Style.verySmallWhiteText),
                          ],
                        ))),
                Container(
                    width: (mediaSize.width - 20) / 4,
                    child: FlatButton(
                        padding: EdgeInsets.all(0.0),
                        onPressed: () => Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (BuildContext context) =>
                                    ProfileFollowings(
                                        user_id: widget.user_id))),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Text(widget.nb_followings.toString(),
                                style: Style.largeText),
                            Text('FOLLOWINGS', style: Style.verySmallWhiteText),
                          ],
                        ))),
                Container(
                    width: (mediaSize.width - 20) / 4,
                    child: FlatButton(
                        padding: EdgeInsets.all(0.0),
                        onPressed: () => Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (BuildContext context) =>
                                    ProfileFollowings(
                                        user_id: widget.user_id))),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Text(widget.nb_posts.toString(),
                                style: Style.largeText),
                            Text('POSTS', style: Style.verySmallWhiteText),
                          ],
                        ))),
              ],
            ),
          )
        ],
      )),
      Padding(
          padding: EdgeInsets.symmetric(horizontal: 20),
          child: SizedBox(
            height: 10.0,
            child: Container(
              decoration: BoxDecoration(
                  border: Border(
                      bottom: BorderSide(
                          width: 1,
                          color: Style.border,
                          style: BorderStyle.solid))),
            ),
          )),
      SizedBox(
        height: 20.0,
      ),
      Padding(
          padding: EdgeInsets.only(left: 20.0, right: 20.0),
          child: Text(
            "Posts",
            style: Style.titleStyle,
          )),
      SizedBox(
        height: 10.0,
      ),
      Feed(
          user_id: widget.user_id,
          hideHeaders: true,
          placeholder: Button(
            background: Colors.transparent,
            width: mediaSize.width,
            onPressed: () => widget.user_id == Session.instance.user.id ? Navigator.push(context, MaterialPageRoute(builder: (BuildContext context) => CreatePost())) : null,
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
                Text(
                    widget.user_id == Session.instance.user.id
                        ? "You have no posts"
                        : "No posts",
                    style: Style.titleStyle),
                Text(
                    widget.user_id == Session.instance.user.id
                        ? "Create your first post."
                        : "${widget.firstname} hasn’t shared anything on TWIC yet.",
                    style: Style.greyText),
                SizedBox(
                  height: 40,
                ),
              ],
            ),
          ))
    ]);
  }
}
