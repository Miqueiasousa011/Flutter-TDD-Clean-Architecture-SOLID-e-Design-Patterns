import '../../../../presentation/protocols/protocols.dart';
import '../../../../validation/protocols/protocols.dart';
import '../../../../validation/validators/validators.dart';

Validation makeLoginValidationFactory() {
  return ValidationComposite(makeLoginValidation());
}

List<FieldValidation> makeLoginValidation() {
  return const [
    RequiredFieldValidation('email'),
    RequiredFieldValidation('password'),
    EmailValidation('email'),
  ];
}
