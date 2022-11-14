import 'package:get/get.dart';

import '../../ui/helpers/helpers.dart';
import '../protocols/protocols.dart';

class GetxSignUpPresenter {
  final Validation _validation;

  String? _email;
  String? _password;

  final _emailError = Rx<UIError?>(null);
  final _passwordError = Rx<UIError?>(null);
  final _isFormValid = RxBool(false);

  Stream<UIError?> get emailErrorController => _emailError.stream;
  Stream<UIError?> get passwordErrorController => _passwordError.stream;
  Stream<bool> get isFormValidController => _isFormValid.stream;

  GetxSignUpPresenter({required Validation validation})
      : _validation = validation;

  void validateEmail(String? email) {
    _email = email;
    final result = _validate(field: 'email', value: email);
    _emailError.value = result;
    _validateForm();
  }

  void validatePassword(String? password) {
    _password = password;
    final result = _validate(field: 'password', value: password);
    _passwordError.value = result;
    _validateForm();
  }

  UIError? _validate({required String field, String? value}) {
    final result = _validation.validate(field: field, value: value);

    switch (result) {
      case ValidationError.invalidField:
        return UIError.invalidField;
      case ValidationError.requiredField:
        return UIError.requiredField;
      default:
        return null;
    }
  }

  _validateForm() {
    _isFormValid.value = false;
  }
}
