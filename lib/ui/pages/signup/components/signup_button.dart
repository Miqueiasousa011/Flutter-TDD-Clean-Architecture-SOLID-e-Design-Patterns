import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../../utils/i18n/i18n.dart';
import '../signup_presenter.dart';

class SignUpButton extends StatelessWidget {
  const SignUpButton({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final presenter = Provider.of<SignUpPresenter>(context);
    return StreamBuilder<bool>(
      stream: presenter.isFormValidController,
      builder: (context, snapshot) {
        return ElevatedButton(
          onPressed: snapshot.data == true ? presenter.signUp : null,
          child: Text(R.strings.addAccount.toUpperCase()),
        );
      },
    );
  }
}
