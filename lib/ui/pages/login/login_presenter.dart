import 'package:flutter/material.dart';

import '../../helpers/ui_error.dart';

abstract class LoginPresenter implements Listenable {
  Stream<UIError?> get emailErrorStream;
  Stream<UIError?> get passwordErrorStream;
  Stream<UIError?> get mainErrorController;

  Stream<bool> get isFormValidController;
  Stream<bool> get isLoadingController;

  Stream<String?> get navigateToStream;

  void validateEmail(String? email);
  void validatePassword(String? password);
  Future<void> auth();
  Future<void> dispose();
  void goToSignUp();
}
