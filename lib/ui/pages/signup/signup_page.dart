import 'package:flutter/material.dart';
import 'package:fordev/ui/mixins/mixins.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';

import '../../../utils/i18n/i18n.dart';
import '../../components/components.dart';
import 'components/components.dart';
import 'signup_presenter.dart';

class SignUpPage extends StatefulWidget {
  const SignUpPage({super.key, required this.presenter});

  final SignUpPresenter presenter;

  @override
  State<SignUpPage> createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage>
    with KeyboardManager, LoadingManager, UIErrorManager {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Builder(builder: (context) {
        handleLoading(context, widget.presenter.isLoadingController);
        handleError(context, widget.presenter.mainErrorStreamController);

        widget.presenter.navigateToStream.listen((route) {
          if (route?.isNotEmpty == true) {
            Get.offAllNamed(route!);
          }
        });

        return GestureDetector(
          onTap: hindeKeyBoard,
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Provider(
              create: (context) => widget.presenter,
              child: Form(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Headline1(text: R.strings.addAccount.toUpperCase()),
                    const SizedBox(height: 32),
                    const NameInput(),
                    const SizedBox(height: 8),
                    const EmailInput(),
                    const SizedBox(height: 8),
                    const PasswordInput(),
                    const SizedBox(height: 8),
                    const PasswordConfirmationInput(),
                    const SizedBox(height: 32),
                    const SignUpButton()
                  ],
                ),
              ),
            ),
          ),
        );
      }),
    );
  }
}
