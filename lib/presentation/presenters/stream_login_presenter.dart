import 'dart:async';

import '../protocols/protocols.dart';

class StreamLoginPresenter {
  StreamLoginPresenter({
    required Validation validation,
  }) : _validation = validation;

  final Validation _validation;

  final _controller = StreamController<LoginState>.broadcast();

  final _state = LoginState();

  Stream<String?> get emailErrorStream =>
      _controller.stream.map((state) => state.emailError).distinct();

  Stream<bool> get isFormValidController =>
      _controller.stream.map((state) => state.isFormValid).distinct();

  void validateEmail(String email) {
    _state.emailError = _validation.validate(field: 'email', value: email);
    _controller.add(_state);
  }
}

class LoginState {
  String? emailError;

  bool isFormValid = false;
}
