import 'package:flutter/material.dart';
import 'package:twic_app/api/services/users.dart';
import 'package:twic_app/api/services/hashtags.dart';
import 'package:twic_app/api/models/user.dart';
import 'package:twic_app/api/models/hashtag.dart';
import 'package:twic_app/shared/form/dropdown.dart';
import 'package:twic_app/pages/onboarding/onboarding_content_state.dart';
import 'package:twic_app/style/style.dart';
import 'package:twic_app/api/session.dart';
import 'package:twic_app/pages/onboarding/onboarding_states.dart';
import 'package:twic_app/shared/users/usercardlist.dart';

class OnboardingConnect extends OnboardingContentState {
  OnboardingConnect()
      : super(
            title: 'Connect',
            text:
                'Discover and connect with students on campus and at other universities.',
            previous: OnboardingState.Details,
            isCompleted: () => true,
            render: () => _OnboardingConnectContent());
}

class _OnboardingConnectContent extends StatefulWidget {
  @override
  State createState() => _OnboardingConnectContentState();
}

class _OnboardingConnectContentState extends State<_OnboardingConnectContent> {
  Hashtag hashtag;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        //SAME CLASS YEAR
        Text(
          'Class of ${Session.instance.user.classYear}',
          style: Style.titleStyle,
        ),
        SizedBox(
          height: 20.0,
        ),
        Users.getList(
            follower: false,
            class_year: Session.instance.user.classYear,
            builder: (List<User> users) => UserCardList(list: users)),
        //SAME MAJOR/MINOR
        null != Session.instance.user.major
            ? Text(
                '${Session.instance.user.major.name} or ${Session.instance.user.minor.name}',
                style: Style.titleStyle,
              )
            : Container(),
        null != Session.instance.user.major
            ? SizedBox(
                height: 20.0,
              )
            : Container(),
        null != Session.instance.user.major
            ? Users.getList(
                follower: false,
                major_id: Session.instance.user.major.id,
                minor_id: Session.instance.user.minor.id,
                builder: (List<User> users) => UserCardList(list: users))
            : Container(),
        //SAME SCHOOL
        null != Session.instance.user.school
            ? Text(
                'Most popular at ${Session.instance.user.school.name}',
                style: Style.titleStyle,
              )
            : Container(),
        null != Session.instance.user.school
            ? SizedBox(
                height: 20.0,
              )
            : Container(),
        null != Session.instance.user.school
            ? Users.getList(
                follower: false,
                school_id: Session.instance.user.school.id,
                builder: (List<User> users) => UserCardList(list: users))
            : Container(),
        //SAME UNIVERSITY
        Text(
          'Most popular at ${Session.instance.user.university.name}',
          style: Style.titleStyle,
        ),
        SizedBox(
          height: 20.0,
        ),
        Users.getList(
            follower: false,
            university_id: Session.instance.user.university.id,
            builder: (List<User> users) => UserCardList(list: users)),
        Hashtags.followed(
            builder: (List<Hashtag> followed) => followed.length == 0
                ? Container()
                : Column(
                    children: <Widget>[
                      Row(children: [
                        Text(
                          'Top from',
                          style: Style.titleStyle,
                        ),
                        SizedBox(
                          width: 10,
                        ),
                        Expanded(
                            child: Dropdown<Hashtag>(
                          icon: Container(
                            padding: EdgeInsets.only(top : 4),
                            decoration: BoxDecoration(
                                color: Style.genZPurple,
                                borderRadius: BorderRadius.all(Radius.circular(25))),
                            width: 30,
                            height: 30,
                            child: Text("#", style: Style.whiteTitle, textAlign: TextAlign.center,),
                          ),
                          value: hashtag ?? followed[0],
                          items: followed
                              .map((Hashtag h) => DropdownMenuItem(
                                    child: Container(
                                      padding: EdgeInsets.all(10),
                                      child:
                                          Text(h.name, style: Style.largeText),
                                    ),
                                    value: h,
                                  ))
                              .toList(),
                          onChanged: (Hashtag h) => setState(() {
                                hashtag = h;
                              }),
                        ))
                      ]),
                      SizedBox(
                        height: 20.0,
                      ),
                      Users.getList(
                          follower: false,
                          hashtag_id: (hashtag ?? followed[0]).id,
                          builder: (List<User> users) =>
                              UserCardList(list: users))
                    ],
                  )),
        //ALL PLATFORM
        Text(
          'Most popular on TWIC',
          style: Style.titleStyle,
        ),
        SizedBox(
          height: 20.0,
        ),
        Users.getList(
            follower: false,
            builder: (List<User> users) => UserCardList(list: users)),
      ],
    );
  }
}
