import 'package:flutter/material.dart';
import 'package:fordev/ui/helpers/helpers.dart';
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

    return StreamBuilder<UIError?>(
      stream: presenter.nameErrorController,
      builder: (context, snapshot) {
        return TextFormField(
          keyboardType: TextInputType.name,
          decoration: InputDecoration(
            errorText: snapshot.data?.description,
            hintText: R.strings.name,
          ),
          onChanged: presenter.validateName,
        );
      },
    );
  }
}
