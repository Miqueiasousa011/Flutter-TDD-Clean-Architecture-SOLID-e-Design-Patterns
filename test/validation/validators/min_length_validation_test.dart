import 'package:test/test.dart';
import 'package:faker/faker.dart';
import 'package:fordev/presentation/protocols/validation.dart';
import 'package:fordev/validation/validators/validators.dart';

void main() {
  late MinLengthValidation sut;

  setUp(() {
    sut = const MinLengthValidation(field: 'any', size: 5);
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

  test('Should return error if value is equal than min size ', () {
    final error = sut.validate(faker.randomGenerator.string(5, min: 5));

    expect(error, isNull);
  });

  test('Should return error if value is bigger than min size ', () {
    final error = sut.validate(faker.randomGenerator.string(10, min: 6));

    expect(error, isNull);
  });
}
