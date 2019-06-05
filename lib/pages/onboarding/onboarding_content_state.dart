import 'package:flutter/material.dart';
import 'package:twic_app/shared/form/button.dart';
import 'package:twic_app/pages/onboarding/onboarding_states.dart';
import 'package:twic_app/pages/onboarding/onboarding.dart';
import 'package:twic_app/pages/home.dart';
import 'package:twic_app/style/style.dart';
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
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Row(
                children: <Widget>[
                  previous == null
                      ? Container()
                      : IconButton(
                          icon: Icon(Icons.arrow_back),
                          onPressed: () => Navigator.pop(context)),
                  Spacer(),
                  Padding(
                      padding: EdgeInsets.all(10.0),
                      child: Button(
                        text: "Next",
                        disabled: !isCompleted(),
                        onPressed: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (BuildContext context) =>
                                    next != null
                                        ? Onboarding(state: next)
                                        : Home(),
                              ));
                        },
                      ))
                ],
              ),
              Padding(
                child: Text(title, style: Style.titleStyle, textAlign: TextAlign.start,),
                padding: EdgeInsets.only(
                    right: 20.0, left: 20.0, bottom: 5.0, top: 20.0),
              ),
              SizedBox(height: 5,),
              Padding(
                child: Text(text, style: Style.greyText),
                padding: EdgeInsets.only(right: 20.0, left: 20.0),
              ),
              SizedBox(height: 20,),
              Padding(child: render(), padding: EdgeInsets.all(20.0)),
            ],
          ),
        ));
  }
}
