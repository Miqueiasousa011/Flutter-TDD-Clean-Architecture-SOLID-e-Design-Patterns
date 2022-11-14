import 'package:flutter/material.dart';

import '../../../../ui/pages/signup/signup.dart';
import 'signup_presenter_factory.dart';

Widget makeSignUpPage() {
  return SignUpPage(presenter: getxSignUpPresenter());
}
