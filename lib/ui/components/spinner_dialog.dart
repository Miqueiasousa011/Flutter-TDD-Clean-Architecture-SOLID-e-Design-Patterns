import 'package:flutter/material.dart';

void showLoading(BuildContext context) {
  showDialog(
    context: context,
    builder: (context) => const SimpleDialog(
      children: [
        CircularProgressIndicator(),
      ],
    ),
  );
}

void hidenLoading(BuildContext context) {
  if (Navigator.of(context).canPop()) {
    Navigator.of(context).pop();
  }
}
