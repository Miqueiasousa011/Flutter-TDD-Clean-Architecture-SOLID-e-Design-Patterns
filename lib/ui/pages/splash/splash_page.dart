import 'package:flutter/material.dart';

import 'package:get/get.dart';

import 'splash_presenter.dart';

class SplashPage extends StatelessWidget {
  const SplashPage({super.key, required this.presenter});

  final SplashPresenter presenter;

  @override
  Widget build(BuildContext context) {
    presenter.checkAccount();
    return Scaffold(
      body: Builder(
        builder: (context) {
          presenter.navigateToStream.listen(
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
