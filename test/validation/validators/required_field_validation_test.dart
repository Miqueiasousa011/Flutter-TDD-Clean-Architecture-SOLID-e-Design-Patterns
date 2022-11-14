import 'package:faker/faker.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fordev/presentation/protocols/protocols.dart';
import 'package:fordev/validation/validators/validators.dart';

void main() {
  late RequiredFieldValidation sut;
  late String value;

  setUp(() {
    value = faker.person.name();

    sut = const RequiredFieldValidation('any_field');
  });

  test('Should return null if value is not empty', () {
    final error = sut.validate({'any_field': value});

    expect(error, isNull);
  });

  test('Should return error if value is empty', () {
    final error = sut.validate({'any_field': ''});

    expect(error, ValidationError.requiredField);
  });

  test('Should return error if value is null', () {
    final error = sut.validate({'any_field': null});

    expect(error, ValidationError.requiredField);
  });
}
