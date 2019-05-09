import 'package:flutter/material.dart';

import 'package:twic_app/api/services/api_rest.dart' as api;
import 'package:twic_app/api/session.dart';

import 'package:twic_app/style/style.dart';
import 'package:twic_app/shared/components/notifier.dart' as notifier;
import 'package:twic_app/shared/form/button.dart';
import 'package:twic_app/shared/form/link.dart';
import 'package:twic_app/shared/form/input.dart';
import 'package:twic_app/shared/form/autocomplete.dart';

import 'package:twic_app/pages/home.dart';
import 'package:twic_app/pages/onboarding/onboarding.dart';
import 'package:twic_app/pages/welcome/join.dart';
import 'package:twic_app/pages/welcome/forgot_password.dart';
import 'package:twic_app/pages/loading_page.dart';

import 'package:twic_app/shared/components/custom_painter.dart';
import 'package:twic_app/shared/locale/translations.dart';

class Login extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        resizeToAvoidBottomPadding: false,
        appBar: AppBar(
          backgroundColor: Style.genZPurple,
          elevation: 0.0,
          iconTheme: IconThemeData(color: Colors.white),
        ),
        body: LoginForm());
  }
}

class LoginForm extends StatefulWidget {
  @override
  State<LoginForm> createState() => LoginFormState();
}

class LoginFormState extends State<LoginForm> {
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
                    color: Style.genZPurple, padding: 0.4),
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
                    translations.text('login.title'),
                    style: Style.whiteTitle,
                  ),
                  Link(
                    text: translations.text('login.description'),
                    style: TextStyle(
                        color: Colors.white, fontSize: 15, fontFamily: 'Rubik'),
                    context: context,
                    href: (BuildContext context) => Join(),
                  ),
                  SizedBox(height: 60),
                  Input(
                    placeholder: translations.text('login.email_placeholder'),
                    icon: Icons.email,
                    validator: (String email) {
                      if (email.trim().isEmpty) {
                        return translations.text('errors.empty_email');
                      }
                      if (!RegExp(
                              r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$')
                          .hasMatch(email.trim())) {
                        return translations.text('errors.invalid_email');
                      }
                    },
                    inputType: TextInputType.emailAddress,
                    onSaved: (String value) => this.email = value.trim(),
                  ),
                  SizedBox(
                    height: 10.0,
                  ),
                  Input(
                      placeholder: translations.text('login.pwd_placeholder'),
                      icon: Icons.lock,
                      obscureText: true,
                      validator: (String password) {
                        if (password.isEmpty) {
                          return translations.text('errors.empty_pwd');
                        }
                      },
                      onSaved: (String value) => this.password = value),
                  SizedBox(height: 10),
                  Link(
                    text: translations.text('login.forgot_pwd'),
                    style: Style.lightText,
                    href: (BuildContext context) => ForgotPassword(),
                  ),
                  Align(
                      alignment: Alignment.topRight,
                      child: Button(
                          width: 150,
                          background: Style.darkGrey,
                          text: translations.text('login.proceed'),
                          disabled: null != email && null != password,
                          child: _isLoading
                              ? Padding(
                                  padding: EdgeInsets.all(10.0),
                                  child: SizedBox(
                                      height: 30.0,
                                      width: 30.0,
                                      child: CircularProgressIndicator(
                                        valueColor: new AlwaysStoppedAnimation(
                                            Colors.white),
                                        strokeWidth: 5.0,
                                      )))
                              : null,
                          onPressed: () async {
                            if (!_isLoading &&
                                _formKey.currentState.validate()) {
                              this.setState(() => _isLoading = true);
                              _formKey.currentState.save();
                              Map<String, dynamic> params = {
                                'email': this.email,
                                'password': this.password
                              };
                              final Map<String, dynamic> data = await api
                                  .request(cmd: 'login', params: params);
                              this.setState(() => _isLoading = false);
                              if (null != data['token']) {
                                await Session.set(data);
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (BuildContext context) =>
                                          Session.instance.user.isActive
                                              ? Home()
                                              : Onboarding(),
                                    ));
                              } else {
                                String error = data["error"];
                                notifier.alert(
                                    message: translations.text('errors.$error'),
                                    type: notifier.AlertType.error,
                                    icon:
                                        Icon(Icons.error, color: Colors.white),
                                    context: context);
                              }
                            }
                          })),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
