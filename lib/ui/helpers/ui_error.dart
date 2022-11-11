import '../../utils/i18n/i18n.dart';

enum UIError {
  unexpected,
  invalidCredentialsError,
  requiredField,
  invalidField,
  emailInUse;
}

extension UIErrorExpension on UIError {
  String get description {
    switch (this) {
      case UIError.emailInUse:
        return R.strings.emailInUse;
      case UIError.invalidCredentialsError:
        return R.strings.msgInvalidCredentials;
      case UIError.invalidField:
        return R.strings.msgInvalidField;
      case UIError.requiredField:
        return R.strings.msgRequiredField;
      case UIError.unexpected:
      default:
        return R.strings.msgUnexpectedError;
    }
  }
}
