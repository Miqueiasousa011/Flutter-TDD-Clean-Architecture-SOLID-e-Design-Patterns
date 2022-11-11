import 'package:flutter/material.dart';
import 'package:fordev/utils/i18n/i18n.dart';

class NameInput extends StatelessWidget {
  const NameInput({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      keyboardType: TextInputType.name,
      decoration: InputDecoration(
        hintText: R.strings.name,
      ),
      onChanged: null,
    );
  }
}
