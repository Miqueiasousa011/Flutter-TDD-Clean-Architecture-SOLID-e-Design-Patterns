import 'package:fordev/validation/protocols/field_validation.dart';
import 'package:fordev/validation/validators/validators.dart';

class ValidationBuilder {
  static late ValidationBuilder _instance;
  late String _fieldName;
  List<FieldValidation> validations = [];

  static ValidationBuilder field(String fieldName) {
    _instance = ValidationBuilder();
    _instance._fieldName = fieldName;
    return _instance;
  }

  ValidationBuilder required() {
    validations.add(RequiredFieldValidation(_fieldName));
    return this;
  }

  ValidationBuilder email() {
    validations.add(EmailValidation(_fieldName));
    return this;
  }

  List<FieldValidation> build() => validations;
}
