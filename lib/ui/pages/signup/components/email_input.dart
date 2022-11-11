import 'package:flutter/material.dart';
import 'package:fordev/utils/i18n/i18n.dart';

class EmailInput extends StatelessWidget {
  const EmailInput({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      keyboardType: TextInputType.emailAddress,
      decoration: InputDecoration(
        hintText: R.strings.email,
      ),
      onChanged: null,
    );
  }
}
