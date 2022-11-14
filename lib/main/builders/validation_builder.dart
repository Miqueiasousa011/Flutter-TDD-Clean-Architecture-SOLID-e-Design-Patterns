import '../../validation/protocols/protocols.dart';
import '../../validation/validators/validators.dart';

class ValidationBuilder {
  static late ValidationBuilder _instance;
  late String _fieldName;
  List<FieldValidation> validations = [];

  ValidationBuilder._();

  static ValidationBuilder field(String fieldName) {
    _instance = ValidationBuilder._();
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

  ValidationBuilder min(int size) {
    validations.add(MinLengthValidation(field: _fieldName, size: size));
    return this;
  }

  List<FieldValidation> build() => validations;
}
