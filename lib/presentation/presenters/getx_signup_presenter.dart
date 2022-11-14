import 'package:fordev/domain/helpers/helpers.dart';
import 'package:get/get.dart';

import '../../domain/usecases/usecases.dart';
import '../../ui/helpers/helpers.dart';
import '../protocols/protocols.dart';

class GetxSignUpPresenter {
  GetxSignUpPresenter({
    required Validation validation,
    required AddAccountUsecase addAccountUsecase,
    required SaveCurrentAccountUsecase saveCurrentAccount,
  })  : _validation = validation,
        _addAccountUsecase = addAccountUsecase,
        _saveCurrentAccount = saveCurrentAccount;

  final Validation _validation;
  final AddAccountUsecase _addAccountUsecase;
  final SaveCurrentAccountUsecase _saveCurrentAccount;

  String? _name;
  String? _email;
  String? _password;
  String? _passwordConfirmation;

  final _nameError = Rx<UIError?>(null);
  final _emailError = Rx<UIError?>(null);
  final _passwordError = Rx<UIError?>(null);
  final _passwordConfirmationError = Rx<UIError?>(null);
  final _isFormValid = RxBool(false);
  final _mainError = Rx<UIError?>(null);
  final _isLoading = RxBool(false);

  Stream<UIError?> get nameErrorController => _nameError.stream;
  Stream<UIError?> get emailErrorController => _emailError.stream;
  Stream<UIError?> get passwordErrorController => _passwordError.stream;
  Stream<UIError?> get passwordConfirmationErrorController =>
      _passwordConfirmationError.stream;
  Stream<bool> get isFormValidController => _isFormValid.stream;
  Stream<UIError?> get mainErrorStreamController => _mainError.stream;
  Stream<bool> get isLoadingController => _isLoading.stream;

  void validateEmail(String? email) {
    _email = email;
    final result = _validate(field: 'email', value: email);
    _emailError.value = result;
    _validateForm();
  }

  void validateName(String? name) {
    _name = name;
    final result = _validate(field: 'name', value: name);
    _nameError.value = result;
    _validateForm();
  }

  void validatePassword(String? password) {
    _password = password;
    final result = _validate(field: 'password', value: password);
    _passwordError.value = result;
    _validateForm();
  }

  void validatePasswordConfirmation(String? password) {
    _passwordConfirmation = password;
    final result = _validate(field: 'password confirmation', value: password);
    _passwordConfirmationError.value = result;
    _validateForm();
  }

  Future<void> signUp() async {
    try {
      _isLoading.value = true;
      final account = await _addAccountUsecase.add(AddAccountParams(
        name: _name!,
        email: _email!,
        password: _password!,
        passwordConfirmation: _passwordConfirmation!,
      ));

      await _saveCurrentAccount.save(account);
    } on DomainError catch (e) {
      switch (e) {
        case DomainError.unexpected:

        default:
          _mainError.value = UIError.unexpected;
      }
      _isLoading.value = false;
    } finally {
      _isLoading.value = false;
    }
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
    _isFormValid.value = (_name != null &&
            _email != null &&
            _password != null &&
            _passwordConfirmation != null) &&
        (_nameError.value == null &&
            _emailError.value == null &&
            _passwordError.value == null &&
            _passwordConfirmationError.value == null);
  }
}
