import 'package:equatable/equatable.dart';

import '../../presentation/protocols/protocols.dart';
import '../protocols/protocols.dart';

class EmailValidation extends Equatable implements FieldValidation {
  final String _field;

  const EmailValidation(this._field);

  @override
  ValidationError? validate(String? value) {
    final regexp = RegExp(
        r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+");

    if (value == null || value.isEmpty) {
      return null;
    }

    return regexp.hasMatch(value) ? null : ValidationError.invalidField;
  }

  @override
  String get field => _field;

  @override
  List<Object?> get props => [_field];
}
