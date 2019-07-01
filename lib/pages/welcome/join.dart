import 'package:flutter/material.dart';

import 'package:twic_app/api/services/api_rest.dart';
import 'package:twic_app/api/session.dart';

import 'package:twic_app/style/style.dart';
import 'package:twic_app/shared/components/notifier.dart' as notifier;
import 'package:twic_app/shared/form/form.dart';

import 'package:twic_app/style/twic_font_icons.dart';
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
  TextEditingController _controller = TextEditingController();
  String password;

  bool _isLoading = false;
  bool _requested = false;

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final GlobalKey fieldKey = Autocomplete.getKey();


  @override
  void initState() {
    _controller.addListener(() => email = _controller.text);
  }

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
            margin: EdgeInsets.only(top: 50.0, left: 50.0, right: 50.0),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(
                    translations.text('join.title'),
                    style: Style.whiteTitle,
                  ),
                  Href(
                    text: translations.text('join.description'),
                    style: TextStyle(
                        color: Colors.white, fontSize: 15, fontFamily: 'Rubik'),
                    context: context,
                    href: (BuildContext context) => Join(),
                  ),
                  SizedBox(height: 50),
                  Input(
                    placeholder: translations.text('join.email_placeholder'),
                    icon: TwicFont.email,
                    height: 72,
                    iconSize: 15,
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
                    controller: _controller,
                    inputType: TextInputType.emailAddress,
                  ),
                  SizedBox(height: 50,),
                  Align(
                      alignment: Alignment.center,
                      child: Button(
                          background: Style.mainColor,
                          width: 250,
                          text: translations.text(!_requested ? 'join.proceed' :'join.proceeded'),
                          disabled: _controller.text.isEmpty,
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
                              setState(() => _isLoading = true);
                              _formKey.currentState.save();
                              Map<String, dynamic> params = {
                                'email': this.email.trim()
                              };

                              final Map<String, dynamic> data = await ApiRest
                                  .request(cmd: 'requestLink', params: params);
                              setState(() => _isLoading = false);
                              notifier.alert(
                                  content: Text('Email sent! Please check your inbox.', style : Style.whiteText, textAlign: TextAlign.center,),
                                  background: Style.mainColor,
                                  context: context);
                              if (data['type'] != 'error') {
                                await Session.setRequest(data['request_token']);
                                setState(() {
                                  _requested = true;
                                });
                              } else {
                                String error = data["error"];
                                notifier.alert(
                                    message: translations.text('errors.$error'),
                                    background: Style.red,
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
