import 'package:flutter/material.dart';
import 'package:fordev/ui/helpers/ui_error.dart';
import 'package:provider/provider.dart';

import '../login_presenter.dart';

class EmailInput extends StatelessWidget {
  const EmailInput({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final presenter = Provider.of<LoginPresenter>(context);

    return StreamBuilder<UIError?>(
      stream: presenter.emailErrorStream,
      builder: (context, snapshot) {
        return TextFormField(
          keyboardType: TextInputType.emailAddress,
          decoration: InputDecoration(
            errorText: snapshot.data?.description,
            hintText: 'Email',
          ),
          onChanged: (value) => presenter.validateEmail(value),
        );
      },
    );
  }
}
