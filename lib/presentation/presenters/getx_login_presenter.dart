import 'dart:async';

import 'package:fordev/domain/helpers/helpers.dart';
import 'package:fordev/presentation/mixins/mixins.dart';
import 'package:fordev/ui/helpers/ui_error.dart';
import 'package:fordev/ui/pages/login/login.dart';
import 'package:get/get.dart';

import '../../domain/usecases/usecases.dart';
import '../protocols/protocols.dart';

class GetXLoginPresenter extends GetxController
    with LoadingManager, NavigateManager
    implements LoginPresenter {
  GetXLoginPresenter({
    required Validation validation,
    required AuthenticationUsecase authenticationUsecase,
    required SaveCurrentAccountUsecase saveCurrentAccount,
  })  : _validation = validation,
        _saveCurrentAccount = saveCurrentAccount,
        _authenticationUsecase = authenticationUsecase;

  final Validation _validation;
  final AuthenticationUsecase _authenticationUsecase;
  final SaveCurrentAccountUsecase _saveCurrentAccount;

  String? _email;
  String? _password;

  final _emailError = Rx<UIError?>(null);
  final _passwordError = Rx<UIError?>(null);
  final _mainError = Rx<UIError?>(null);

  final _isFormValid = RxBool(false);

  @override
  Stream<UIError?> get emailErrorStream => _emailError.stream;

  @override
  Stream<UIError?> get passwordErrorStream => _passwordError.stream.distinct();

  @override
  Stream<bool> get isFormValidController => _isFormValid.stream.distinct();

  @override
  Stream<UIError?> get mainErrorController => _mainError.stream;

  UIError? _validateField(String field) {
    final formData = {
      'email': _email,
      'password': _password,
    };

    final error = _validation.validate(
      field: field,
      input: formData,
    );
    switch (error) {
      case ValidationError.invalidField:
        return UIError.invalidField;
      case ValidationError.requiredField:
        return UIError.requiredField;
      default:
        return null;
    }
  }

  @override
  void validateEmail(String? email) {
    _email = email;
    _emailError.value = _validateField('email');
    _validateForm();
  }

  @override
  void validatePassword(String? password) {
    _password = password;
    _passwordError.value = _validateField('password');
    _validateForm();
  }

  @override
  Future<void> auth() async {
    final params = AuthenticationParams(
      email: _email!,
      password: _password!,
    );
    isLoading = true;

    try {
      final account = await _authenticationUsecase.auth(params);
      await _saveCurrentAccount.save(account);
      navigateTo = '/surveys';
    } on DomainError catch (e) {
      switch (e) {
        case DomainError.invalidCredentialsError:
          _mainError.value = UIError.invalidCredentialsError;
          break;
        default:
          _mainError.value = UIError.unexpected;
      }
    } finally {
      isLoading = false;
    }
  }

  void _validateForm() {
    _isFormValid.value = _email != null &&
        _password != null &&
        _emailError.value == null &&
        _passwordError.value == null;
  }

  @override
  Future<void> dispose() async {
    super.dispose();
  }

  @override
  void goToSignUp() => navigateTo = '/signup';
}
