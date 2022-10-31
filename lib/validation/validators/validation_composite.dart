import '../../presentation/protocols/protocols.dart';
import '../protocols/protocols.dart';

class ValidationComposite implements Validation {
  final List<FieldValidation> validations;

  ValidationComposite(this.validations);

  @override
  String? validate({required String field, required value}) {
    String? error;

    for (var validation in validations.where((v) => v.field == field)) {
      error = validation.validate(value);
      if (error != null) {
        return error;
      }
    }

    return error;
  }
}
