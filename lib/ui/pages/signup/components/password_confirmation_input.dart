import 'package:flutter/material.dart';
import 'package:fordev/utils/i18n/i18n.dart';

class PasswordConfirmationInput extends StatelessWidget {
  const PasswordConfirmationInput({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      obscureText: true,
      decoration: InputDecoration(
        hintText: R.strings.passwordConfirmation,
      ),
      onChanged: null,
    );
  }
}
