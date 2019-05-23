import 'package:flutter/material.dart';

import 'package:twic_app/api/services/api_rest.dart' as api;
import 'package:twic_app/api/session.dart';

import 'package:twic_app/style/style.dart';
import 'package:twic_app/shared/components/notifier.dart' as notifier;
import 'package:twic_app/shared/form/form.dart';

import 'package:twic_app/pages/home.dart';
import 'package:twic_app/pages/onboarding/onboarding.dart';
import 'package:twic_app/pages/loading_page.dart';

import 'package:twic_app/shared/components/custom_painter.dart';
import 'package:twic_app/shared/locale/translations.dart';

class Join extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        resizeToAvoidBottomPadding: false,
        appBar: AppBar(
          backgroundColor: Style.genZBlue,
          elevation: 0.0,
          iconTheme: IconThemeData(color: Colors.white),
        ),
        body: JoinForm());
  }
}

class JoinForm extends StatefulWidget {
  @override
  State<JoinForm> createState() => JoinFormState();
}

class JoinFormState extends State<JoinForm> {
  List<AutoCompleteElement> schools = null;
  AutoCompleteElement school;

  String email;
  String password;

  bool _isLoading = false;

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final GlobalKey fieldKey = Autocomplete.getKey();

  @override
  Widget build(BuildContext context) {
    final Size mediaSize = MediaQuery.of(context).size;
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).requestFocus((FocusNode()));
      },
      child: Stack(
        children: <Widget>[
          ClipRect(
            child: CustomPaint(
                painter: CustomBackgroundPainter(
                    color: Style.genZBlue, padding: 0.4),
                size: Size(double.infinity, mediaSize.height * 0.55)),
          ),
          Container(
            margin: EdgeInsets.only(top: 60.0, left: 50.0, right: 50.0),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(
                    translations.text('join.title'),
                    style: Style.whiteTitle,
                  ),
                  SizedBox(height: 10,),
                  Text(
                    translations.text('join.description'),
                    style: TextStyle(
                        color: Colors.white, fontSize: 15, fontFamily: 'Rubik'),
                  ),
                  SizedBox(height: 40),
                  FutureBuilder(
                    future: api.request(cmd: 'schools'),
                    builder: (BuildContext context,
                        AsyncSnapshot<Map<String, dynamic>> snapshot) {
                      if (snapshot.hasData) {
                        List<dynamic> data = snapshot.data['schools'];
                        return Autocomplete(
                          fieldKey: fieldKey,
                          suggestions: data
                              .map((dynamic _data) => AutoCompleteElement(
                                  name: _data['name'], logo: _data['logo']))
                              .toList(),
                          size: mediaSize.width - 100,
                          placeholder:
                              translations.text('join.schools_placeholder'),
                          initialValue: school != null ? school.name : null,
                          icon: Icons.search,
                          minLength: 0,
                          itemSubmitted: (AutoCompleteElement item) {
                            this.setState(() {
                              school = item;
                            });
                          },
                          textChanged: (String text) {
                            if (null != school) {
                              this.setState(() {
                                school = null;
                              });
                            }
                          },
                        );
                      }
                      return Center(
                          child: CircularProgressIndicator(
                        valueColor: AlwaysStoppedAnimation(Colors.white),
                      ));
                    },
                  ),
                  SizedBox(height: 10.0,),
                  null != school
                      ?  Input(
                            placeholder:
                                translations.text('join.email_placeholder'),
                            icon: Icons.email,
                            validator: (String email) {
                              if (email.isEmpty) {
                                return translations.text('errors.empty_email');
                              }
                              if (!RegExp(
                                      r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$')
                                  .hasMatch(email)) {
                                return translations
                                    .text('errors.invalid_email');
                              }
                            },
                            inputType: TextInputType.emailAddress,
                            onSaved: (String value) => this.email = value,
                          )
                      : Container(),
                  SizedBox(height: 10.0,),
                  null != school
                      ? Input(
                              placeholder:
                                  translations.text('join.pwd_placeholder'),
                              icon: Icons.lock,
                              obscureText: true,
                              validator: (String password) {
                                if (password.isEmpty) {
                                  return translations.text('errors.empty_pwd');
                                }
                              },
                              onSaved: (String value) => this.password = value)
                      : Container(),
                  SizedBox(height:50),
                  null != school
                      ? Center(
                              child: Button(
                                  text: translations.text('join.proceed'),
                                  child: _isLoading
                                      ? Padding(
                                          padding: EdgeInsets.all(10.0),
                                          child: SizedBox(
                                              height: 30.0,
                                              width: 30.0,
                                              child: CircularProgressIndicator(
                                                valueColor:
                                                    new AlwaysStoppedAnimation(
                                                        Colors.white),
                                                strokeWidth: 5.0,
                                              )))
                                      : null,
                                  padding:
                                      EdgeInsets.only(left: 80.0, right: 80.0),
                                  onPressed: () async {
                                    if (!_isLoading &&
                                        _formKey.currentState.validate()) {
                                      this.setState(() => _isLoading = true);
                                      _formKey.currentState.save();
                                      Map<String, dynamic> params = {
                                        'email': this.email,
                                        'password': this.password
                                      };
                                      final Map<String, dynamic> data =
                                          await api.request(
                                              cmd: 'login', params: params);
                                      this.setState(() => _isLoading = false);
                                      if (null != data['token']) {
                                        await Session.set(data);
                                        Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                              builder: (BuildContext context) =>
                                                  Session.instance.user
                                                              .isActive
                                                      ? Home()
                                                      : Onboarding(),
                                            ));
                                      } else {
                                        String error = data["error"];
                                        notifier.alert(
                                            message: translations
                                                .text('errors.$error'),
                                            type: notifier.AlertType.error,
                                            icon: Icon(Icons.error,
                                                color: Colors.white),
                                            context: context);
                                      }
                                    }
                                  }))
                      : Container(),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
