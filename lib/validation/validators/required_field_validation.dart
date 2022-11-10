import 'package:equatable/equatable.dart';
import '../../presentation/protocols/protocols.dart';

import '../protocols/protocols.dart';

class RequiredFieldValidation extends Equatable implements FieldValidation {
  final String _field;

  const RequiredFieldValidation(this._field);

  @override
  ValidationError? validate(String? value) {
    if (value == null || value.isEmpty == true) {
      return ValidationError.requiredField;
    }

    return null;
  }

  @override
  String get field => _field;

  @override
  List<Object?> get props => [_field];
}
