import 'package:flutter/material.dart';
import 'package:fordev/utils/i18n/i18n.dart';
import 'package:provider/provider.dart';

import '../signup_presenter.dart';

class PasswordConfirmationInput extends StatelessWidget {
  const PasswordConfirmationInput({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final presenter = Provider.of<SignUpPresenter>(context);
    return TextFormField(
      obscureText: true,
      decoration: InputDecoration(
        hintText: R.strings.passwordConfirmation,
      ),
      onChanged: presenter.validatePasswordConfirmation,
    );
  }
}
