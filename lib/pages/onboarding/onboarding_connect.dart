import 'package:flutter/material.dart';
import 'package:twic_app/api/services/hashtags.dart';
import 'package:twic_app/api/models/models.dart';
import 'package:twic_app/shared/form/form.dart';
import 'package:twic_app/pages/onboarding/onboarding_content_state.dart';
import 'package:twic_app/style/style.dart';
import 'package:twic_app/api/session.dart';
import 'package:twic_app/pages/onboarding/onboarding_states.dart';
import 'package:twic_app/shared/users/usercardlist.dart';
import 'package:twic_app/api/services/cache.dart';

class OnboardingConnect extends OnboardingContentState {
  OnboardingConnect()
      : super(
            title: 'Connect',
            padding: EdgeInsets.only(top: 20, bottom: 20),
            text:
                'Discover and connect with students on campus and at other universities.',
            previous: OnboardingState.Details,
            isCompleted: () => true,
            child: _OnboardingConnectContent());
}

class _OnboardingConnectContent extends StatefulWidget {

  @override
  State createState() => _OnboardingConnectContentState();
}

class _OnboardingConnectContentState extends State<_OnboardingConnectContent> {
  Hashtag hashtag;
  Size mediaSize;
  bool loaded = false;

  void _onFollow(User user, bool followed) {
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    mediaSize = MediaQuery.of(context).size;
    Widget placeholder = Container(
        width: mediaSize.width,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            SizedBox(
              height: 20,
            ),
            Image.asset(
              'assets/empty.png',
              width: 35,
              height: 35,
            ),
            SizedBox(
              height: 20,
            ),
            Text("There doesn’t seem to be anything here.",
                style: Style.greyText),
            SizedBox(
              height: 40,
            ),
          ],
        ));
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        //SAME CLASS YEAR

        Padding(
            padding: EdgeInsets.only(left: 20, right: 20),
            child: Text(
              'Same graduation year',
              style: Style.titleStyle,
              overflow: TextOverflow.ellipsis,
              textAlign: TextAlign.start,
            )),
        UserCardList(
          class_year: Session.instance.user.classYear,
          onFollow: _onFollow,
          placeholder: placeholder,
        ),

        //SAME MAJOR/MINOR

        Padding(
            padding: EdgeInsets.only(left: 20),
            child: Text(
              'Same major or minor',
              style: Style.titleStyle,
            )),
        UserCardList(
          follower: false,
          major_id: Session.instance.user.major.id,
          minor_id: Session.instance.user.minor.id,
          onFollow: _onFollow,
          placeholder: placeholder,
        ),
        //SAME SCHOOL
        null != Session.instance.user.school
            ? Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                Padding(
                    padding: EdgeInsets.only(left: 20),
                    child: Text(
                      'Same ${Session.instance.user.degree == "UNDERGRADUATE" ? "Residential College" : "School"}',
                      style: Style.titleStyle,
                      textAlign: TextAlign.start,
                    )),
                UserCardList(
                  follower: false,
                  school_id: Session.instance.user.school.id,
                  onFollow: _onFollow,
                  placeholder: placeholder,
                ),
              ])
            : Container(),
        //SAME UNIVERSITY
        Padding(
            padding: EdgeInsets.only(left: 20),
            child: Text(
              'Popular at ${Session.instance.user.institution.name}',
              style: Style.titleStyle,
              textAlign: TextAlign.start,
            )),
        UserCardList(
          follower: false,
          university_id: Session.instance.user.institution.id,
          onFollow: _onFollow,
          placeholder: placeholder,
        ),
        AppCache.getWidget<Hashtag>(
            onCompleted: () => setState((){
              loaded = true;
            }),
            params : {"followed" : true},
            builder: (List<int> followed) => (followed.length == 0 || !loaded)
                ? Container()
                : Column(
                    children: <Widget>[
                      Padding(
                          padding: EdgeInsets.only(left: 20, right: 20),
                          child: Flex(direction: Axis.horizontal, children: [
                            SizedBox(width: 10),
                            Text(
                              'Top from',
                              style: Style.titleStyle,
                              textAlign: TextAlign.start,
                            ),
                            SizedBox(
                              width: 10,
                            ),
                            Flexible(
                                child: Dropdown<Hashtag>(
                              icon: Container(
                                padding: EdgeInsets.only(top: 4),
                                decoration: BoxDecoration(
                                    color: Style.mainColor,
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(25))),
                                width: 30,
                                height: 30,
                                child: Text(
                                  "#",
                                  style: Style.whiteTitle,
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  textAlign: TextAlign.center,
                                ),
                              ),
                              value: hashtag ?? AppCache.getModel<Hashtag>(followed[0]),
                              items: followed
                                  .map((int hashtag_id){
                                    Hashtag h = AppCache.getModel<Hashtag>(hashtag_id);
                                    return DropdownMenuItem(
                                        child: Container(
                                          padding: EdgeInsets.all(10),
                                          child: Text(h.name,
                                              overflow: TextOverflow.ellipsis,
                                              style: Style.largeText),
                                        ),
                                        value: h,
                                      );})
                                  .toList(),
                              onChanged: (Hashtag h) => setState(() {
                                    hashtag = h;
                                  }),
                            ))
                          ])),
                      UserCardList(
                          follower: false,
                          hashtag_id: (hashtag?.id ?? followed[0]),
                          onFollow: _onFollow,
                          placeholder: placeholder)
                    ],
                  )),
        //ALL PLATFORM

        Padding(
            padding: EdgeInsets.only(left: 20),
            child: Text(
              'Most popular on TWIC',
              style: Style.titleStyle,
              textAlign: TextAlign.start,
            )),
        UserCardList(
            follower: false, onFollow: _onFollow, placeholder: placeholder)
      ],
    );
  }
}
