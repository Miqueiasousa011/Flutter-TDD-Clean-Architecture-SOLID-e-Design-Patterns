import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../../utils/i18n/i18n.dart';
import '../signup_presenter.dart';

class NameInput extends StatelessWidget {
  const NameInput({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final presenter = Provider.of<SignUpPresenter>(context);

    return TextFormField(
      keyboardType: TextInputType.name,
      decoration: InputDecoration(
        hintText: R.strings.name,
      ),
      onChanged: presenter.validateName,
    );
  }
}
