import 'package:fordev/presentation/protocols/validation.dart';
import 'package:fordev/validation/protocols/field_validation.dart';
import 'package:test/test.dart';

class MinLengthValidation implements FieldValidation {
  final String _field;
  final int _size;

  MinLengthValidation({
    required String field,
    required int size,
  })  : _field = field,
        _size = size;

  @override
  String get field => _field;

  @override
  ValidationError? validate(String? value) {
    if (value == null || value.isEmpty) {
      return ValidationError.invalidField;
    }
    return null;
  }
}

void main() {
  late MinLengthValidation sut;

  test('Should return InvalidFieldError if value  is null', () {
    sut = MinLengthValidation(field: 'any', size: 2);
    final error = sut.validate(null);

    expect(error, ValidationError.invalidField);
  });

  test('Should return InvalidFieldError if value is empty', () {
    sut = MinLengthValidation(field: 'any', size: 2);
    final error = sut.validate('');

    expect(error, ValidationError.invalidField);
  });
}
