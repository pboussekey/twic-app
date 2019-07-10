import 'package:flutter/material.dart';

import 'package:twic_app/style/style.dart';

import 'package:twic_app/pages/root_page.dart';
import 'package:twic_app/shared/form/button.dart';
import 'package:twic_app/pages/onboarding/onboarding_states.dart';
import 'package:twic_app/pages/onboarding/onboarding_class_year.dart';
import 'package:twic_app/pages/onboarding/onboarding_details.dart';
import 'package:twic_app/pages/onboarding/onboarding_interests.dart';
import 'package:twic_app/pages/onboarding/onboarding_connect.dart';
import 'package:twic_app/pages/home.dart';

class Onboarding extends StatelessWidget {
  final OnboardingState state;

  Onboarding({this.state = OnboardingState.ClassYear});

  @override
  Widget build(BuildContext context) {
    return RootPage(
        scrollable: true,
        child: OnboardingContent(
          state: this.state,
        ));
  }
}

class OnboardingContent extends StatefulWidget {
  final OnboardingState state;

  final Map<OnboardingState, State<OnboardingContent>> states = {
    OnboardingState.ClassYear: OnboardingClassYear(),
    OnboardingState.Details: OnboardingDetails(),
    OnboardingState.Interests: OnboardingInterests(),
    OnboardingState.Connect: OnboardingConnect()
  };

  OnboardingContent({this.state});

  @override
  State createState() => this.states[this.state];
}
