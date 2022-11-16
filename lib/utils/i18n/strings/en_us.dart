import 'translations.dart';

class EnUs implements Translations {
  @override
  String get addAccount => 'Create Account';

  @override
  String get email => 'E-mail';

  @override
  String get name => 'Name';

  @override
  String get password => 'Password';

  @override
  String get passwordConfirmation => 'Password Confirmation';

  @override
  String get emailInUse => 'Email already registered';

  @override
  String get msgInvalidCredentials => 'Invalid credentials';

  @override
  String get msgInvalidField => 'Invalid field';

  @override
  String get msgRequiredField => 'Required field';

  @override
  String get msgUnexpectedError => 'Unexpected error';

  @override
  String get surveys => 'Surveys';
}
