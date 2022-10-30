import '../protocols/protocols.dart';

class RequiredFieldValidation implements FieldValidation {
  final String field;

  RequiredFieldValidation(this.field);

  @override
  String? validate(String? value) {
    if (value == null || value.isEmpty == true) {
      return 'Campo obrigatório';
    }

    return null;
  }
}
