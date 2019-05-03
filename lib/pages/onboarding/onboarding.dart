import 'package:flutter/material.dart';

import 'package:twic_app/style/style.dart';

import 'package:twic_app/pages/root_page.dart';
import 'package:twic_app/shared/form/button.dart';
import 'package:twic_app/pages/onboarding/onboarding_states.dart';
import 'package:twic_app/pages/onboarding/onboarding_class_year.dart';
import 'package:twic_app/pages/onboarding/onboarding_details.dart';
import 'package:twic_app/pages/onboarding/onboarding_interests.dart';
import 'package:twic_app/pages/onboarding/onboarding_connect.dart';
import 'package:twic_app/pages/home.dart';


class Onboarding extends StatelessWidget {
  final OnboardingState state;

  Onboarding({this.state = OnboardingState.ClassYear});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.white,
        resizeToAvoidBottomInset: false,
        body: RootPage(
            child: OnboardingContent(
          state: this.state,
        )));
  }
}

class OnboardingContent extends StatefulWidget {
  final OnboardingState state;

  final Map<OnboardingState, State<OnboardingContent>> states = {
    OnboardingState.ClassYear: OnboardingClassYear(),
    OnboardingState.Details: OnboardingDetails(),
    OnboardingState.Interests: OnboardingInterests(),
    OnboardingState.Connect: OnboardingConnect()
  };

  OnboardingContent({this.state});

  @override
  State createState() => this.states[this.state];
}

class _OnboardingContentState extends State<OnboardingContent> {
  String title;
  String text;
  Function render;
  Function isCompleted;
  OnboardingState previous;
  OnboardingState next;

  _OnboardingContentState(
      {this.title,
      this.text,
      this.isCompleted,
      this.render,
      this.previous,
      this.next});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      child: Column(
        children: <Widget>[
          Row(
            children: <Widget>[
              this.previous == null
                  ? Container()
                  : IconButton(
                      icon: Icon(Icons.arrow_back),
                      onPressed: () => Navigator.pop(context)),
              Spacer(),
              Padding(
                  padding: EdgeInsets.all(10.0),
                  child: Button(
                    text: "Next",
                    disabled: !this.isCompleted(),
                    onPressed: () => Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (BuildContext context) => this.next != null
                              ? Onboarding(state: this.next)
                              : Home(),
                        )),
                  ))
            ],
          ),
          Padding(
            child: Text(this.title, style: Style.titleStyle),
            padding: EdgeInsets.only(
                right: 20.0, left: 20.0, bottom: 5.0, top: 20.0),
          ),
          Padding(
            child: Text(this.text, style: Style.greyText),
            padding: EdgeInsets.only(right: 20.0, left: 20.0),
          ),
          Padding(child: this.render(), padding: EdgeInsets.all(20.0)),
        ],
      ),
    );
  }
}
