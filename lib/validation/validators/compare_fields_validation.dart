import 'package:equatable/equatable.dart';

import '../../presentation/protocols/protocols.dart';
import '../protocols/protocols.dart';

class CompareFieldsValidation extends Equatable implements FieldValidation {
  final String _field;
  final String? _valueToCompare;

  const CompareFieldsValidation({
    required String field,
    required String? valueToCompare,
  })  : _field = field,
        _valueToCompare = valueToCompare;

  @override
  String get field => _field;

  @override
  ValidationError? validate(String? value) {
    if (value == _valueToCompare) {
      return null;
    }
    return ValidationError.invalidField;
  }

  @override
  List<Object?> get props => [_field, _valueToCompare];
}
