import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

import '../../main/factories/factories.dart';
import '../../main/factories/pages/signup/signup_page_factory.dart';
import '../../utils/i18n/i18n.dart';

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle.light);

    const primaryColor = Color.fromRGBO(136, 14, 79, 1);
    const primaryColorDark = Color.fromRGBO(96, 0, 39, 1);
    const primaryColorLight = Color.fromRGBO(188, 71, 123, 1);

    R.load(const Locale('pt', 'BR'));

    return GetMaterialApp(
      theme: ThemeData(
        primaryColor: primaryColor,
        primaryColorDark: primaryColorDark,
        primaryColorLight: primaryColorLight,
        backgroundColor: Colors.white,
        textTheme: const TextTheme(
          headline1: TextStyle(
            fontSize: 30,
            color: primaryColorDark,
            fontWeight: FontWeight.w700,
          ),
        ),
      ),
      debugShowCheckedModeBanner: false,
      localizationsDelegates: const [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      locale: const Locale('pt'),
      supportedLocales: const [Locale('pt', 'BR')],
      title: '4Dev',
      initialRoute: '/',
      getPages: [
        GetPage(
          name: '/',
          page: () => makeSplashPage(),
        ),
        GetPage(
          name: '/login',
          page: () => makeLoginPage(),
        ),
        GetPage(
          name: '/signup',
          page: () => makeSignUpPage(),
        ),
        GetPage(
          name: '/surveys',
          page: () => makeSurveyPage(),
        ),
        GetPage(
          name: '/survey_result/:survey_id',
          page: () => makeSurveyResultPage(),
        ),
      ],
    );
  }
}
