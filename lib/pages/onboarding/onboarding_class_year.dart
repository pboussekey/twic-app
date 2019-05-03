import 'package:flutter/material.dart';
import 'package:twic_app/shared/form/button.dart';
import 'package:twic_app/pages/onboarding/onboarding_content_state.dart';
import 'package:twic_app/style/style.dart';
import 'package:twic_app/api/session.dart';
import 'package:twic_app/pages/onboarding/onboarding_states.dart';
import 'package:twic_app/api/services/users.dart';

class OnboardingClassYear extends OnboardingContentState {
  Widget _renderButton(
      String text, double size, bool active, Function onPressed) {
    return Button(
      text: text,
      radius: 6.0,
      border: Border.all(color: Style.border),
      width: size,
      background: active ? Style.darkPurple : Colors.white,
      color: active ? Colors.white : Style.darkGrey,
      onPressed: onPressed,
    );
  }

  Widget _renderButtons(RunMutation runMutation, double size) {
    int currentYear = new DateTime.now().year;
    List<Widget> buttons = [];
    List<Widget> lines = [];
    int index = 0;
    for (int classYear = currentYear;
        classYear < currentYear + 6;
        classYear++) {
      buttons.add(_renderButton(
          classYear.toString(),
          size / 2 - 25.0,
          Session.instance.user.classYear == classYear,
          () => setState(() {
                runMutation({'classYear': classYear});
                Session.update({'classYear': classYear});
              })));

      if (buttons.length == 2 || index == 6) {
        lines.add(Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: buttons));
        lines.add(SizedBox(
          height: 10.0,
        ));
        buttons = [];
      }
      index++;
    }
    ;

    return Column(
      children: lines,
    );
  }

  OnboardingClassYear()
      : super(
            title: 'What is your current year?',
            text:
                'Please select your current class standing from the list below.',
            next: OnboardingState.Details,
            isCompleted: () =>
                Session.instance.user.classYear != null &&
                Session.instance.user.degree != null) {
    this.render = () => Users.update(
        builder: (RunMutation runMutation, QueryResult result) => Column(
              children: <Widget>[
                Flex(
                    direction: Axis.horizontal,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Button(
                        text: 'Undergraduate',
                        radius: 6.0,
                        border: Border.all(color: Style.border),
                        width: mediaSize.width / 2 - 25.0,
                        background:
                            'UNDERGRADUATE' == Session.instance.user.degree
                                ? Style.darkPurple
                                : Colors.white,
                        color: 'UNDERGRADUATE' == Session.instance.user.degree
                            ? Colors.white
                            : Style.darkGrey,
                        onPressed: () => setState(() {
                              runMutation({
                                'degree': 'UNDERGRADUATE',
                                'school_id': Session.instance.user.university.id
                              });
                              Session.update({
                                'degree': 'UNDERGRADUATE',
                                'school':
                                    Session.instance.user.university.toJson()
                              });
                            }),
                      ),
                      Button(
                        text: 'Graduate',
                        radius: 6.0,
                        border: Border.all(color: Style.border),
                        width: mediaSize.width / 2 - 25.0,
                        background: 'GRADUATE' == Session.instance.user.degree
                            ? Style.darkPurple
                            : Colors.white,
                        color: 'GRADUATE' == Session.instance.user.degree
                            ? Colors.white
                            : Style.darkGrey,
                        onPressed: () => setState(() {
                              runMutation({
                                'degree': 'GRADUATE',
                                'major_id' : 0,
                                'minor_id' : 0,
                                'school_id': Session.instance.user.university.id
                              });
                              Session.update({
                                'degree': 'GRADUATE',
                                'major' : null,
                                'minor' : null,
                                'school':
                                    Session.instance.user.university.toJson()
                              });
                            }),
                      ),
                    ]),
                SizedBox(
                  height: 50,
                ),
                _renderButtons(runMutation, mediaSize.width)
              ],
            ));
  }
}
