import 'package:flutter/material.dart';
import 'package:twic_app/shared/form/button.dart';
import 'package:twic_app/pages/onboarding/onboarding_states.dart';
import 'package:twic_app/pages/onboarding/onboarding.dart';
import 'package:twic_app/pages/home.dart';
import 'package:twic_app/style/style.dart';
import 'package:twic_app/api/services/api_graphql.dart' as api;
import 'package:twic_app/api/session.dart';

class OnboardingContentState extends State<OnboardingContent> {
  final String title;
  final String text;
  Function render;
  final Function isCompleted;
  final OnboardingState previous;
  final OnboardingState next;
  Size mediaSize;

  OnboardingContentState(
      {this.title,
      this.text,
      this.isCompleted,
      this.render,
      this.previous,
      this.next});

  @override
  Widget build(BuildContext context) {
    mediaSize = MediaQuery.of(context).size;
    return GestureDetector(
        onTap: () {
          FocusScope.of(context).requestFocus((FocusNode()));
        },
        child: Container(
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
                        onPressed: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (BuildContext context) =>
                                    this.next != null
                                        ? Onboarding(state: this.next)
                                        : Home(),
                              ));
                        },
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
        ));
  }
}
