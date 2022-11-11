import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../../utils/i18n/i18n.dart';
import '../signup_presenter.dart';

class EmailInput extends StatelessWidget {
  const EmailInput({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final presenter = Provider.of<SignUpPresenter>(context);
    return TextFormField(
      keyboardType: TextInputType.emailAddress,
      decoration: InputDecoration(
        hintText: R.strings.email,
      ),
      onChanged: presenter.validateEmail,
    );
  }
}
