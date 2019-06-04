import 'package:flutter/material.dart';
import 'dart:math';
import 'package:twic_app/style/style.dart';
import 'package:twic_app/shared/form/button.dart';
import 'package:twic_app/shared/form/link.dart';
import 'package:twic_app/pages/welcome/join.dart';
import 'package:twic_app/pages/welcome/login.dart';
import 'package:twic_app/pages/welcome/presentation.dart';

class BottomRoundClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    var path = Path();
    path.lineTo(0.0, size.height * 0.85);

    var firstControlPoint = Offset(size.width / 2, size.height * 1.15);
    var firstEndPoint = Offset(size.width, size.height * 0.85);
    path.quadraticBezierTo(firstControlPoint.dx, firstControlPoint.dy,
        firstEndPoint.dx, firstEndPoint.dy);

    path.lineTo(size.width, 0.0);
    path.close();

    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) => false;
}

class Welcome extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    Size mediaSize = MediaQuery.of(context).size;
    return Scaffold(
        body: SingleChildScrollView( child : Container(
            color: Colors.white,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                Stack(alignment: Alignment(0, 0), children: [
                  ClipPath(
                    clipper: BottomRoundClipper(),
                    child: Image.asset(
                      "assets/welcome.png",
                      width: mediaSize.width,
                      fit: BoxFit.fitWidth,
                    ),
                  ),
                  Image.asset(
                    "assets/logo.png",
                    color: Colors.white,
                    fit: BoxFit.fitWidth,
                  ),
                ]),
                SizedBox(height: max(0, mediaSize.height * 0.6 - 325,)),
                Container(
                    padding: EdgeInsets.only(left: 30.0, right: 30.0),
                    child: Column(
                      children: <Widget>[
                        Text("Welcome to TWIC", style: Style.hugeTitle),
                        SizedBox(
                          height: 10.0,
                        ),
                        Text(
                          "TWIC lets you connect with a community on your campus and at other universities.",
                          style: Style.greyText,
                          textAlign: TextAlign.center,
                        ),
                        SizedBox(
                          height: 50.0,
                        ),
                        Button(
                          text: "Join the community now",
                          width: mediaSize.width * 0.7,
                          onPressed: () => Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (BuildContext context) => Join(),
                              )),
                        ),
                        SizedBox(
                          height: 10.0,
                        ),
                        Button(
                          background: Colors.white,
                          width: mediaSize.width * 0.7,
                          color: Style.grey,
                          border: Border.all(
                              color: Style.border,
                              style: BorderStyle.solid,
                              width: 1),
                          text: "Login",
                          onPressed: () => Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (BuildContext context) => Login(),
                              )),
                        ),
                        SizedBox(
                          height: 10.0,
                        ),
                        Link(
                          style: Style.lightText,
                          text: "Learn more",
                          context: context,
                          href: (BuildContext context) => Presentation(onDone: this,),
                        )
                      ],
                    ))
              ],
            ))));
  }
}
