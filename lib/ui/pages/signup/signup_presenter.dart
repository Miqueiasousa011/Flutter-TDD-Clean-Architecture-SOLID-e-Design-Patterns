import '../../helpers/helpers.dart';

abstract class SignUpPresenter {
  Stream<UIError?> get nameErrorController;
  Stream<UIError?> get emailErrorController;
  Stream<UIError?> get passwordErrorController;
  Stream<UIError?> get passwordConfirmationErrorController;
  Stream<UIError?> get mainErrorStreamController;
  Stream<bool> get isFormValidController;
  Stream<bool> get isLoadingController;

  void validateName(String? name);
  void validateEmail(String? email);
  void validatePassword(String? password);
  void validatePasswordConfirmation(String? password);
  Future<void> signUp();
}
