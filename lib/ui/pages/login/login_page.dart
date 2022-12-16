import 'package:flutter/material.dart';
import 'package:fordev/ui/pages/pages.dart';
import 'package:get/get.dart';

import 'package:provider/provider.dart';

import '../../components/components.dart';
import '../../mixins/mixins.dart';
import 'components/components.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key, required this.loginPresenter});

  final LoginPresenter loginPresenter;

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage>
    with KeyboardManager, LoadingManager, UIErrorManager {
  @override
  void dispose() {
    widget.loginPresenter.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Builder(
        builder: (context) {
          handleLoading(context, widget.loginPresenter.isLoadingController);
          handleError(context, widget.loginPresenter.mainErrorController);

          widget.loginPresenter.navigateToStream.listen((page) {
            if (page?.isNotEmpty == true) {
              Get.offAllNamed(page!);
            }
          });

          return GestureDetector(
            onTap: hindeKeyBoard,
            child: SingleChildScrollView(
              child: Column(
                children: [
                  const LoginHeader(),
                  const Headline1(text: 'login'),
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: ListenableProvider(
                      create: (_) => widget.loginPresenter,
                      child: Form(
                        child: Column(
                          children: [
                            const EmailInput(),
                            const Padding(
                              padding: EdgeInsets.symmetric(vertical: 16),
                              child: PasswordInput(),
                            ),
                            const LoginButton(),
                            TextButton.icon(
                              onPressed: widget.loginPresenter.goToSignUp,
                              icon: const Icon(Icons.person),
                              label: const Text('Criar conta'),
                            )
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
