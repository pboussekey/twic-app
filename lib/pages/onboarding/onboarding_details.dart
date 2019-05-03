import 'package:flutter/material.dart';
import 'package:twic_app/shared/form/autocomplete.dart';
import 'package:twic_app/shared/form/dropdown.dart';
import 'package:twic_app/pages/onboarding/onboarding_content_state.dart';
import 'package:twic_app/api/session.dart';
import 'package:twic_app/pages/onboarding/onboarding_states.dart';
import 'package:twic_app/api/models/school.dart';
import 'package:twic_app/api/models/field.dart';
import 'package:twic_app/api/services/fields.dart';
import 'package:twic_app/api/services/schools.dart';
import 'package:twic_app/api/services/users.dart';

class OnboardingDetails extends OnboardingContentState {
  final GlobalKey majorKey = Autocomplete.getKey();
  final GlobalKey minorKey = Autocomplete.getKey();

  Widget _render() {
    final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
    return Fields.getList(builder: (List<Field> fields) {
      List<AutoCompleteElement> list = fields
          .map((Field field) =>
              AutoCompleteElement(id: field.id, name: field.name, data: field))
          .toList();
      return Users.update(
          builder: (RunMutation runMutation, QueryResult result) => Form(
              key: _formKey,
              child: Column(children: [
                'UNDERGRADUATE' == Session.instance.user.degree
                    ? Autocomplete(
                        fieldKey: majorKey,
                        initialValue: Session.instance.user.major != null
                            ? Session.instance.user.major.name
                            : null,
                        placeholder: 'What is your major ?',
                        suggestions: list,
                        minLength: 0,
                        itemSubmitted: (AutoCompleteElement item) {
                          this.setState(() {
                            Session.update({
                              'major': (item.data as Field).toJson(),
                              'isActive': this.isCompleted()
                            });
                            runMutation({
                              'major_id': item.data.id,
                              'isActive': this.isCompleted()
                            });
                          });
                        },
                        textChanged: (String text) {
                          if (null != Session.instance.user.major) {
                            this.setState(() {
                              Session.update({'major': null});
                            });
                          }
                        },
                      )
                    : Container(),
                'UNDERGRADUATE' == Session.instance.user.degree
                    ? SizedBox(height: 10)
                    : Container(),
                'UNDERGRADUATE' == Session.instance.user.degree
                    ? Autocomplete(
                        fieldKey: minorKey,
                        initialValue: Session.instance.user.minor != null
                            ? Session.instance.user.minor.name
                            : null,
                        placeholder: 'What is your minor ?',
                        suggestions: list,
                        minLength: 0,
                        itemSubmitted: (AutoCompleteElement item) {
                          this.setState(() {
                            Session.update({
                              'minor': (item.data as Field).toJson(),
                              'isActive': this.isCompleted()
                            });
                            runMutation({
                              'minor_id': item.data.id,
                              'isActive': this.isCompleted()
                            });
                          });
                        },
                        textChanged: (String text) {
                          if (null != Session.instance.user.minor) {
                            this.setState(() {
                              Session.update({'minor': null});
                            });
                          }
                        },
                      )
                    : Container(),
                'UNDERGRADUATE' == Session.instance.user.degree
                    ? SizedBox(height: 10)
                    : Container(),
                Schools.getList(
                    university_id: Session.instance.user.university.id,
                    degree: Session.instance.user.degree,
                    builder: (List<School> schools) => schools.length > 0
                        ? Dropdown<School>(
                            value: Session.instance.user.school,
                            size: double.maxFinite,
                            hint: Text(
                                'UNDERGRADUATE' == Session.instance.user.degree
                                    ? "Residential college"
                                    : "Graduate school"),
                            items: schools
                                .map<DropdownMenuItem<School>>(
                                    (School value) => DropdownMenuItem(
                                          child: Text(value.name),
                                          value: value,
                                        ))
                                .toList(),
                            onChanged: (School s) => setState(() {
                                  Session.update({'school': s.toJson(), 'isActive' : this.isCompleted()});
                                  runMutation({
                                    'school_id': s.id,
                                    'isActive': this.isCompleted()
                                  });
                                }),
                          )
                        : CircularProgressIndicator()),
              ])));
    });
  }

  OnboardingDetails()
      : super(
            title: 'Collect some details',
            text: 'Let’s confirm some details about your collegiate career.',
            next: OnboardingState.Interests,
            previous: OnboardingState.ClassYear,
            isCompleted: () =>
                null != Session.instance.user.school &&
                ('UNDERGRADUATE' != Session.instance.user.degree ||
                    (Session.instance.user.major != null &&
                        Session.instance.user.minor != null))) {
    this.render = () => _render();
  }
}
