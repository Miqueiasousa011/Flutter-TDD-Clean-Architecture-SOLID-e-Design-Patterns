import '../protocols/protocols.dart';

class RequiredFieldValidation implements FieldValidation {
  final String _field;

  RequiredFieldValidation(this._field);

  @override
  String? validate(String? value) {
    if (value == null || value.isEmpty == true) {
      return 'Campo obrigatório';
    }

    return null;
  }

  @override
  String get field => _field;
}
