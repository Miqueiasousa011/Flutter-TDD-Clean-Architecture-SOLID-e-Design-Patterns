import 'package:flutter/material.dart';

import '../../../../ui/pages/splash/splash.dart';

import 'splash_presenter.dart';

Widget makeSplashPage() {
  return SplashPage(presenter: makeGexSplashPresenter());
}
