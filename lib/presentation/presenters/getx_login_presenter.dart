import 'dart:async';

import 'package:fordev/domain/helpers/helpers.dart';
import 'package:fordev/ui/pages/login/login.dart';
import 'package:get/get.dart';

import '../../domain/usecases/usecases.dart';
import '../protocols/protocols.dart';

class GetXLoginPresenter extends GetxController implements LoginPresenter {
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

  final _emailError = Rx<String?>(null);
  final _passwordError = Rx<String?>(null);
  final _mainError = Rx<String?>(null);
  final _navigateTo = Rx<String?>(null);
  final _isLoading = RxBool(false);
  final _isFormValid = RxBool(false);

  @override
  Stream<String?> get emailErrorStream => _emailError.stream.distinct();

  @override
  Stream<String?> get passwordErrorStream => _passwordError.stream.distinct();

  @override
  Stream<bool> get isFormValidController => _isFormValid.stream.distinct();

  @override
  Stream<bool> get isLoadingController => _isLoading.stream.distinct();

  @override
  Stream<String?> get mainErrorController => _mainError.stream;

  @override
  Stream<String?> get navigateToStream => _navigateTo.stream;

  @override
  void validateEmail(String? email) {
    _email = email;
    _emailError.value = _validation.validate(
      field: 'email',
      value: email,
    );
    _validateForm();
  }

  @override
  void validatePassword(String? password) {
    _password = password;
    _passwordError.value = _validation.validate(
      field: 'password',
      value: password,
    );
    _validateForm();
  }

  @override
  Future<void> auth() async {
    final params = AuthenticationParams(
      email: _email!,
      password: _password!,
    );
    _isLoading.value = true;

    try {
      final account = await _authenticationUsecase.auth(params);
      await _saveCurrentAccount.save(account);
      _navigateTo.value = '/surveys';
    } on DomainError catch (e) {
      _mainError.value = e.description;
    } finally {
      _isLoading.value = false;
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
}
