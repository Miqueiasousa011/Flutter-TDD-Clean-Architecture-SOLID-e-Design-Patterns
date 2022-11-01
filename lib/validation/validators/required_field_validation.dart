import 'package:equatable/equatable.dart';

import '../protocols/protocols.dart';

class RequiredFieldValidation extends Equatable implements FieldValidation {
  final String _field;

  const RequiredFieldValidation(this._field);

  @override
  String? validate(String? value) {
    if (value == null || value.isEmpty == true) {
      return 'Campo obrigatório';
    }

    return null;
  }

  @override
  String get field => _field;

  @override
  List<Object?> get props => [_field];
}
