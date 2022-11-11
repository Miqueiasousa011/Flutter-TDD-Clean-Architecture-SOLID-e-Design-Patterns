import 'package:flutter/material.dart';
import 'package:fordev/ui/components/components.dart';
import 'package:fordev/utils/i18n/i18n.dart';

import 'components/components.dart';

class SignUpPage extends StatefulWidget {
  const SignUpPage({super.key});

  @override
  State<SignUpPage> createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: GestureDetector(
        onTap: _hindeKeyBoard,
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 16),
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
    );
  }

  void _hindeKeyBoard() {
    FocusScopeNode currentFocus = FocusScope.of(context);
    if (!currentFocus.hasPrimaryFocus) {
      currentFocus.unfocus();
    }
  }
}
