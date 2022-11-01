import '../../../../presentation/protocols/protocols.dart';
import '../../../../validation/validators/validators.dart';

Validation makeLoginValidationFactory() {
  return ValidationComposite([
    RequiredFieldValidation('email'),
    RequiredFieldValidation('password'),
    EmailValidation('email'),
  ]);
}
