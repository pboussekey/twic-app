import 'package:flutter/material.dart';
import 'package:twic_app/shared/form/form.dart';
import 'package:twic_app/pages/onboarding/onboarding_content_state.dart';
import 'package:twic_app/api/session.dart';
import 'package:twic_app/pages/onboarding/onboarding_states.dart';
import 'package:twic_app/api/models/models.dart';
import 'package:twic_app/api/services/fields.dart';
import 'package:twic_app/api/services/schools.dart';
import 'package:twic_app/api/services/users.dart';

class OnboardingDetails extends OnboardingContentState {


  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();


  Widget _render() {
    print(Session.instance.user.toJson());
    return Fields.getList(
        school_id: Session.instance.user.institution.id,
        builder: (List<Field> fields) {
          List<AutoCompleteElement> list = fields
              .map((Field field) => AutoCompleteElement(
              id: field.id, name: field.name, data: field))
              .toList();
          return Users.update(
              builder: (RunMutation update, QueryResult result) => Form(
                  key: _formKey,
                  child: _OnboardingDetails(
                    fields: list,
                    update: update,
                    isCompleted: isCompleted,
                  )));
        });
  }

  Widget _child;
  @override
  void initState() {
    super.initState();

    _child = _render();
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
    this.render = () => _child;
  }
}

class _OnboardingDetails extends StatefulWidget {
  final RunMutation update;
  final List<AutoCompleteElement> fields;
  final Function isCompleted;

  _OnboardingDetails({this.update, this.fields, this.isCompleted});

  @override
  State<StatefulWidget> createState() => _OnboardingDetailsState();
}

class _OnboardingDetailsState extends State<_OnboardingDetails> {
  GlobalKey majorKey;
  GlobalKey minorKey;

  @override
  void initState() {
    super.initState();
    majorKey = Autocomplete.getKey();
    minorKey = Autocomplete.getKey();
  }

  @override
  Widget build(BuildContext context) => Column(children: [
        'UNDERGRADUATE' == Session.instance.user.degree
            ? Autocomplete(
                fieldKey: majorKey,
                initialValue: Session.instance.user.major != null
                    ? Session.instance.user.major.name
                    : null,
                placeholder: 'What is your major ?',
                suggestions: widget.fields,
                minLength: 0,
                itemSubmitted: (AutoCompleteElement item) {
                  this.setState(() {
                    Session.update({
                      'major': (item.data as Field).toJson(),
                      'isActive': widget.isCompleted()
                    });
                    widget.update({
                      'major_id': item.data.id,
                      'isActive': widget.isCompleted()
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
                suggestions: widget.fields,
                minLength: 0,
                itemSubmitted: (AutoCompleteElement item) {
                  this.setState(() {
                    Session.update({
                      'minor': (item.data as Field).toJson(),
                      'isActive': widget.isCompleted()
                    });
                    widget.update({
                      'minor_id': item.data.id,
                      'isActive': widget.isCompleted()
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
            university_id: null != Session.instance.user.university
                ? Session.instance.user.university.id
                : Session.instance.user.school.id,
            degree: Session.instance.user.degree,
            builder: (List<School> schools) => schools.length > 0
                ? Dropdown<School>(
                    value: null != Session.instance.user.university
                        ? Session.instance.user.school
                        : null,
                    size: double.maxFinite,
                    hint: Text('UNDERGRADUATE' == Session.instance.user.degree
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
                          Session.update({
                            'school': s.toJson(),
                            'isActive': widget.isCompleted()
                          });
                          widget.update({
                            'school_id': s.id,
                            'isActive': widget.isCompleted()
                          });
                        }),
                  )
                : CircularProgressIndicator()),
      ]);
}
