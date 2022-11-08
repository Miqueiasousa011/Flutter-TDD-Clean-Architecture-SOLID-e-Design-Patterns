import 'package:flutter/material.dart';

abstract class LoginPresenter implements Listenable {
  Stream<String?> get emailErrorStream;
  Stream<String?> get passwordErrorStream;
  Stream<bool> get isFormValidController;
  Stream<bool> get isLoadingController;
  Stream<String?> get mainErrorController;

  Stream<String?> get navigateToStream;

  void validateEmail(String? email);
  void validatePassword(String? password);
  Future<void> auth();
  Future<void> dispose();
}
