import 'package:flutter/material.dart';

import 'package:twic_app/style/style.dart';

import 'package:twic_app/shared/components/welcome_slider.dart';
import 'package:twic_app/pages/welcome/welcome.dart';
import 'package:twic_app/shared/locale/translations.dart';

class Presentation extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return PresentationState();
  }
}

class PresentationState extends State<Presentation> {
  List<Slide> slides = new List();

  @override
  void initState() {
    super.initState();

    slides.add(
      new Slide(
        title: translations.text("welcome.step1.title"),
        pathImage: 'assets/image-splash-1.png',
        widthImage: double.infinity,
        description: translations.text("welcome.step1.description"),
        backgroundColor: Style.genZPurple,
        marginImage: 0.03,
      ),
    );

    slides.add(
      new Slide(
        title: translations.text("welcome.step2.title"),
        pathImage: 'assets/image-splash-2.png',
        widthImage: double.infinity,
        heightImage: 0.5,
        imageFit: BoxFit.fitHeight,
        description: translations.text("welcome.step2.description"),
        backgroundColor: Style.genZGreen,
        marginImage: 0.12,
      ),
    );

    slides.add(
      new Slide(
        title: translations.text("welcome.step3.title"),
        pathImage: 'assets/image-splash-3.png',
        widthImage: double.infinity,
        heightImage: 0.5,
        imageFit: BoxFit.fitHeight,
        description: translations.text("welcome.step3.description"),
        backgroundColor: Style.genZOrange,
        marginImage: 0.12,
      ),
    );

    slides.add(
      new Slide(
        title: translations.text("welcome.step4.title"),
        pathImage: 'assets/image-splash-4.png',
        widthImage: double.infinity,
        heightImage: 0.5,
        imageFit: BoxFit.fitHeight,
        description: translations.text("welcome.step4.description"),
        backgroundColor: Style.genZYellow,
        marginImage: 0.12,
      ),
    );
  }

  void onDonePress() {
    Navigator.push(
        context,
        MaterialPageRoute(
          builder: (BuildContext context) => Welcome(),
        ));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: WelcomeSlider(slides: this.slides, onDonePress: this.onDonePress),
    );
  }
}