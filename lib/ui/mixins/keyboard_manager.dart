import 'package:flutter/material.dart';

mixin KeyboardManager<T extends StatefulWidget> on State<T> {
  void hindeKeyBoard() {
    FocusScopeNode currentFocus = FocusScope.of(context);
    if (!currentFocus.hasPrimaryFocus) {
      currentFocus.unfocus();
    }
  }
}
