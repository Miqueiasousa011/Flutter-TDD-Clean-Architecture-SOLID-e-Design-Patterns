import 'package:flutter/material.dart';

import 'package:get/get.dart';

import 'splash_presenter.dart';

class SplashPage extends StatefulWidget {
  const SplashPage({super.key, required this.presenter});

  final SplashPresenter presenter;

  @override
  State<SplashPage> createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> {
  @override
  void initState() {
    super.initState();
    widget.presenter.checkAccount();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Builder(
        builder: (context) {
          widget.presenter.navigateToStream.listen(
            (page) {
              if (page?.isNotEmpty == true) {
                Get.offAllNamed(page!);
              }
            },
          );

          return const Center(
            child: CircularProgressIndicator(),
          );
        },
      ),
    );
  }
}
