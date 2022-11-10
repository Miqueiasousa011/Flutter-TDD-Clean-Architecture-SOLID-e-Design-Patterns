import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../main/factories/factories.dart';

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle.light);

    const primaryColor = Color.fromRGBO(136, 14, 79, 1);
    const primaryColorDark = Color.fromRGBO(96, 0, 39, 1);
    const primaryColorLight = Color.fromRGBO(188, 71, 123, 1);

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
          name: '/surveys',
          page: () => const Scaffold(
            body: Center(
              child: Text('ENQUETES'),
            ),
          ),
        ),
      ],
    );
  }
}
