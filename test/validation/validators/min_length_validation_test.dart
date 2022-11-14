import 'package:faker/faker.dart';
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
    return ValidationError.invalidField;
  }
}

void main() {
  late MinLengthValidation sut;

  setUp(() {
    sut = MinLengthValidation(field: 'any', size: 5);
  });

  test('Should return InvalidFieldError if value  is null', () {
    final error = sut.validate(null);

    expect(error, ValidationError.invalidField);
  });

  test('Should return InvalidFieldError if value is empty', () {
    final error = sut.validate('');

    expect(error, ValidationError.invalidField);
  });

  test('Should return error if value is less than min size ', () {
    final error = sut.validate(faker.randomGenerator.string(4, min: 1));

    expect(error, ValidationError.invalidField);
  });
}
