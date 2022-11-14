import 'package:equatable/equatable.dart';

import '../../presentation/protocols/protocols.dart';
import '../protocols/protocols.dart';

class CompareFieldsValidation extends Equatable implements FieldValidation {
  final String _field;
  final String? _fieldToCompare;

  const CompareFieldsValidation({
    required String field,
    required String? fieldToCompare,
  })  : _field = field,
        _fieldToCompare = fieldToCompare;

  @override
  String get field => _field;

  @override
  ValidationError? validate(Map<String, dynamic> input) {
    if (input[field] == input[_fieldToCompare]) {
      return null;
    }
    return ValidationError.invalidField;
  }

  @override
  List<Object?> get props => [_field, _fieldToCompare];
}
