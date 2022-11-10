import 'package:flutter/material.dart';
import 'package:fordev/ui/helpers/ui_error.dart';
import 'package:fordev/ui/pages/pages.dart';
import 'package:provider/provider.dart';

class PasswordInput extends StatelessWidget {
  const PasswordInput({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final presenter = Provider.of<LoginPresenter>(context);
    return StreamBuilder<UIError?>(
      stream: presenter.passwordErrorStream,
      builder: (context, snapshot) {
        return TextFormField(
          obscureText: true,
          decoration: InputDecoration(
            hintText: 'Senha',
            errorText: snapshot.data?.description,
          ),
          onChanged: (value) => presenter.validatePassword(value),
        );
      },
    );
  }
}
