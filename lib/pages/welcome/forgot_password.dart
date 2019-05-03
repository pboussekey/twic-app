import 'package:flutter/material.dart';

import 'package:twic_app/api/services/api_rest.dart' as api;
import 'package:twic_app/api/session.dart';

import 'package:twic_app/style/style.dart';
import 'package:twic_app/shared/components/notifier.dart' as notifier;
import 'package:twic_app/shared/form/button.dart';
import 'package:twic_app/shared/form/link.dart';
import 'package:twic_app/shared/form/input.dart';
import 'package:twic_app/shared/form/autocomplete.dart';

import 'package:twic_app/pages/welcome/join.dart';

import 'package:twic_app/shared/components/custom_painter.dart';
import 'package:twic_app/shared/locale/translations.dart';

class ForgotPassword extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        resizeToAvoidBottomPadding: false,
        appBar: AppBar(
          backgroundColor: Style.genZPurple,
          elevation: 0.0,
          iconTheme: IconThemeData(color: Colors.white),
        ),
        body: ForgotPasswordForm());
  }
}

class ForgotPasswordForm extends StatefulWidget {
  @override
  State<ForgotPasswordForm> createState() => ForgotPasswordFormState();
}

class ForgotPasswordFormState extends State<ForgotPasswordForm> {
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
                    translations.text('forgot_pwd.title'),
                    style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                        fontSize: 22,
                        fontFamily: 'Rubik'),
                  ),
                  Link(
                    text: translations.text('forgot_pwd.description'),
                    style: TextStyle(
                        color: Colors.white, fontSize: 15, fontFamily: 'Rubik'),
                    context: context,
                    href: (BuildContext context) => Join(),
                  ),
                  SizedBox(height: 60),
                  Input(
                    placeholder:
                        translations.text('forgot_pwd.email_placeholder'),
                    icon: Icons.email,
                    validator: (String email) {
                      if (email.isEmpty) {
                        return translations.text('errors.empty_email');
                      }
                      if (!RegExp(
                              r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$')
                          .hasMatch(email)) {
                        return translations.text('errors.invalid_email');
                      }
                    },
                    inputType: TextInputType.emailAddress,
                    onSaved: (String value) => this.email = value,
                  ),
                  SizedBox(height: 30),
                  Center(
                      child: Button(
                          background: Style.darkGrey,
                          text: translations.text('forgot_pwd.proceed'),
                          disabled: null != email,
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
                          onPressed: () {})),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
