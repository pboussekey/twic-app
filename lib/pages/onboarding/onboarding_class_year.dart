import 'package:flutter/material.dart';
import 'package:twic_app/pages/onboarding/onboarding_content_state.dart';
import 'package:twic_app/style/style.dart';
import 'package:twic_app/api/session.dart';
import 'package:twic_app/pages/onboarding/onboarding_states.dart';
import 'package:twic_app/api/services/users.dart';
import 'package:twic_app/shared/form/form.dart';

class OnboardingClassYear extends OnboardingContentState {
  bool otherClassYear = false;
  FocusNode _focusNode;
  TextEditingController _classYearCtrl = TextEditingController();

  @override
  initState() {
    super.initState();
    int currentYear = new DateTime.now().year;
    int classYear = Session.instance.user.classYear;
    _focusNode = FocusNode();

    if (null != classYear &&
        (classYear < currentYear || classYear >= currentYear + 6)) {
      _classYearCtrl.text = classYear.toString();
      otherClassYear = true;
    }
  }

  @override
  void dispose() {
    // Clean up the focus node when the Form is disposed
    _focusNode.dispose();

    super.dispose();
  }

  Widget _renderButton(
      String text, double size, bool active, Function onPressed) {
    return Button(
      text: text,
      radius: BorderRadius.all(Radius.circular(6.0)),
      border: Border.all(color: Style.border),
      width: size,
      height: 60,
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
          !otherClassYear && Session.instance.user.classYear == classYear,
          () => setState(() {
                otherClassYear = false;
                _classYearCtrl.text = '';
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
    if (!_classYearCtrl.hasListeners) {
      _classYearCtrl.addListener(() {
        int classYear = int.tryParse(_classYearCtrl.text);
        if (null != classYear) {
          otherClassYear = true;
          runMutation({'classYear': classYear});
          Session.update({'classYear': classYear});
        }
      });
    }
    lines.add(Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
      _renderButton(
          "Other",
          size / 2 - 25.0,
          otherClassYear,
          () => setState(() {
                otherClassYear = true;
                FocusScope.of(context).requestFocus(_focusNode);
                int classYear = int.tryParse(_classYearCtrl.text);
                if (null != classYear) {
                  runMutation({'classYear': classYear});
                  Session.update({'classYear': classYear});
                }
              })),
      SizedBox(
        width: 10,
      ),
      Expanded(
          child: Input(
            height: 60,
        controller: _classYearCtrl,
        focusNode: _focusNode,
        placeholder: "Class year",
        inputType:
            TextInputType.numberWithOptions(decimal: false, signed: false),
      ))
    ]));

    return Column(
      children: lines,
    );
  }

  OnboardingClassYear()
      : super(
            title: 'What type of student are you?',
            text:
                'Please select your education level and expected graduation year.',
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
                        radius: BorderRadius.all(Radius.circular(6.0)),
                        border: Border.all(color: Style.border),
                        width: mediaSize.width / 2 - 25.0,
                        height: 60,
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
                                'school_id':null
                              });
                              Session.update({
                                'degree': 'UNDERGRADUATE',
                                'school': null
                              });
                            }),
                      ),
                      Button(
                        text: 'Graduate',
                        radius: BorderRadius.all(Radius.circular(6.0)),
                        border: Border.all(color: Style.border),
                        width: mediaSize.width / 2 - 25.0,
                        height: 60,
                        background: 'GRADUATE' == Session.instance.user.degree
                            ? Style.darkPurple
                            : Colors.white,
                        color: 'GRADUATE' == Session.instance.user.degree
                            ? Colors.white
                            : Style.darkGrey,
                        onPressed: () => setState(() {
                              runMutation({
                                'degree': 'GRADUATE',
                                'major_id': 0,
                                'minor_id': 0,
                                'school_id':null
                              });
                              Session.update({
                                'degree': 'GRADUATE',
                                'major': null,
                                'minor': null,
                                'school': null
                              });
                            }),
                      ),
                    ]),
                SizedBox(
                  height: 40,
                ),
                _renderButtons(runMutation, mediaSize.width),
              ],
            ));
  }
}
