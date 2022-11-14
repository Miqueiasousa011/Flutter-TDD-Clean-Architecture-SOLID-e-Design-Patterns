import 'package:equatable/equatable.dart';

import '../../presentation/protocols/protocols.dart';
import '../protocols/protocols.dart';

class MinLengthValidation extends Equatable implements FieldValidation {
  final String _field;
  final int _size;

  const MinLengthValidation({
    required String field,
    required int size,
  })  : _field = field,
        _size = size;

  @override
  String get field => _field;

  @override
  ValidationError? validate(Map<String, dynamic> input) {
    if (input[field]?.length != null && input[field]!.length >= _size) {
      return null;
    }

    return ValidationError.invalidField;
  }

  @override
  List<Object> get props => [_size, _field];
}
