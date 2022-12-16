import 'package:fordev/domain/helpers/helpers.dart';

import 'package:fordev/presentation/mixins/mixins.dart';
import 'package:fordev/ui/pages/signup/signup_presenter.dart';
import 'package:get/get.dart';

import '../../domain/usecases/usecases.dart';
import '../../ui/helpers/helpers.dart';
import '../protocols/protocols.dart';

class GetxSignUpPresenter
    with LoadingManager, NavigateManager
    implements SignUpPresenter {
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

  @override
  Stream<UIError?> get nameErrorController => _nameError.stream;
  @override
  Stream<UIError?> get emailErrorController => _emailError.stream;
  @override
  Stream<UIError?> get passwordErrorController => _passwordError.stream;
  @override
  Stream<UIError?> get passwordConfirmationErrorController =>
      _passwordConfirmationError.stream;
  @override
  Stream<bool> get isFormValidController => _isFormValid.stream;
  @override
  Stream<UIError?> get mainErrorStreamController => _mainError.stream;

  @override
  void validateEmail(String? email) {
    _email = email;
    final result = _validate('email');
    _emailError.value = result;
    _validateForm();
  }

  @override
  void validateName(String? name) {
    _name = name;
    final result = _validate('name');
    _nameError.value = result;
    _validateForm();
  }

  @override
  void validatePassword(String? password) {
    _password = password;
    final result = _validate('password');
    _passwordError.value = result;
    _validateForm();
  }

  @override
  void validatePasswordConfirmation(String? password) {
    _passwordConfirmation = password;
    final result = _validate('passwordConfirmation');
    _passwordConfirmationError.value = result;
    _validateForm();
  }

  @override
  Future<void> signUp() async {
    try {
      isLoading = true;
      final account = await _addAccountUsecase.add(AddAccountParams(
        name: _name!,
        email: _email!,
        password: _password!,
        passwordConfirmation: _passwordConfirmation!,
      ));

      await _saveCurrentAccount.save(account);
      navigateTo = '/surveys';
    } on DomainError catch (e) {
      switch (e) {
        case DomainError.emailInUse:
          _mainError.value = UIError.emailInUse;
          break;
        default:
          _mainError.value = UIError.unexpected;
      }
      isLoading = false;
    } finally {
      isLoading = false;
    }
  }

  UIError? _validate(String field) {
    final formData = {
      'email': _email,
      'name': _name,
      'password': _password,
      'passwordConfirmation': _passwordConfirmation,
    };
    final result = _validation.validate(field: field, input: formData);

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
