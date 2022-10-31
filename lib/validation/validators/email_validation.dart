import '../protocols/protocols.dart';

class EmailValidation implements FieldValidation {
  final String _field;

  EmailValidation(this._field);

  @override
  String? validate(String? value) {
    final regexp = RegExp(
        r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+");

    if (value == null || value.isEmpty) {
      return null;
    }

    return regexp.hasMatch(value) ? null : 'Email inválido';
  }

  @override
  String get field => _field;
}
