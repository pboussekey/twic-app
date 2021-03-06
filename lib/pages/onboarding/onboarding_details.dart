import 'package:flutter/material.dart';
import 'package:twic_app/shared/form/form.dart';
import 'package:twic_app/pages/onboarding/onboarding_content_state.dart';
import 'package:twic_app/api/session.dart';
import 'package:twic_app/pages/onboarding/onboarding_states.dart';
import 'package:twic_app/api/models/models.dart';
import 'package:twic_app/api/services/fields.dart';
import 'package:twic_app/api/services/schools.dart';
import 'package:twic_app/api/services/users.dart';
import 'package:cached_network_image/cached_network_image.dart';

class OnboardingDetails extends OnboardingContentState {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
  }

  OnboardingDetails()
      : super(
            title: 'Collect some details',
            text: 'Let’s confirm some details about your collegiate career.',
            next: OnboardingState.Interests,
            previous: OnboardingState.ClassYear,
            isCompleted: () {
              return null != Session.instance.user.school &&
                  ('UNDERGRADUATE' != Session.instance.user.degree ||
                      (Session.instance.user.major != null &&
                          Session.instance.user.minor != null));
            }) {
    this.onNext = () {
      Session.update({'isActive': true});
    };
    this.child = Fields.getList(
        school_id: Session.instance.user.institution.id,
        builder: (List<Field> fields) {
          List<AutoCompleteElement> list = fields
              .map((Field field) => AutoCompleteElement(
                  id: field.id, name: field.name, data: field))
              .toList();
          return Schools.getList(
              university_id: Session.instance.user.university.id,
              degree: Session.instance.user.degree,
              builder: (List<School> schools) {
                return Users.update(
                    builder: (RunMutation update, QueryResult result) => Form(
                        key: _formKey,
                        child: _OnboardingDetails(
                          fields: list,
                          schools: schools,
                          update: update,
                          isCompleted: isCompleted,
                          updateState: setState,
                        )));
              });
        });
  }
}

class _OnboardingDetails extends StatefulWidget {
  final RunMutation update;
  final List<AutoCompleteElement> fields;
  final List<School> schools;
  final Function isCompleted;
  final Function updateState;

  _OnboardingDetails(
      {this.update,
      this.fields,
      this.schools,
      this.isCompleted,
      this.updateState});

  @override
  State<StatefulWidget> createState() => _OnboardingDetailsState();
}

TextEditingController _majorController =
    TextEditingController(text: Session.instance.user?.major?.name);
TextEditingController _minorController =
    TextEditingController(text: Session.instance.user?.minor?.name);

class _OnboardingDetailsState extends State<_OnboardingDetails> {
  Key majorKey = UniqueKey();
  Key minorKey = UniqueKey();

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    print(["???", _majorController.text]);
    if(null != Session.instance.user.major){
      _majorController.text = Session.instance.user.major.name;
    }
    if(null != Session.instance.user.minor){
      _minorController.text = Session.instance.user.minor.name;
    }
    Size mediaSize = MediaQuery.of(context).size;
    return Column(children: [
      'UNDERGRADUATE' == Session.instance.user.degree
          ? Autocomplete(
              controller: _majorController,
              placeholder: 'What is your major ?',
              suggestions: widget.fields,
              minLength: 0,
              itemSubmitted: (AutoCompleteElement item) {
                widget.updateState(() {
                  _majorController.text = item.name;
                  print([
                    "SUBMITTED",
                    item.name,
                    item.data.toJson(),
                    _majorController.text
                  ]);
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
              controller: _minorController,
              placeholder: 'What is your minor ?',
              suggestions: widget.fields,
              minLength: 0,
              itemSubmitted: (AutoCompleteElement item) {
                widget.updateState(() {
                  _minorController.text = item.name;
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
      widget.schools.length > 0
          ? Dropdown<School>(
              value: Session.instance.user.school,
              size: mediaSize.width - 40,
              hint: Text('UNDERGRADUATE' == Session.instance.user.degree
                  ? "Residential college"
                  : "Graduate school"),
              items: widget.schools
                  .map<DropdownMenuItem<School>>(
                      (School value) => DropdownMenuItem(
                            child: Container(
                                width: mediaSize.width - 40,
                                child: Row(
                                  children: <Widget>[
                                    null != value.logo
                                        ? CachedNetworkImage(
                                            imageUrl: value.logo?.href(),
                                            height: 12.0,
                                            width: 12.0,
                                            fit: BoxFit.fill,
                                            fadeOutDuration:
                                                new Duration(seconds: 1),
                                            fadeInDuration:
                                                new Duration(seconds: 1),
                                          )
                                        : Container(),
                                    null != value.logo
                                        ? SizedBox(
                                            width: 5,
                                          )
                                        : Container(),
                                    Text(value.name)
                                  ],
                                )),
                            value: value,
                          ))
                  .toList(),
              onChanged: (School s) => widget.updateState(() {
                    Session.update({
                      'school': s.toJson(),
                      'isActive': widget.isCompleted()
                    });
                    widget.update(
                        {'school_id': s.id, 'isActive': widget.isCompleted()});
                  }),
            )
          : Container(),
    ]);
  }
}
