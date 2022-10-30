import 'package:faker/faker.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fordev/validation/protocols/protocols.dart';

class EmailValidation implements FieldValidation {
  final String field;

  EmailValidation(this.field);

  @override
  String? validate(String? value) {
    final regexp = RegExp(
        r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+");

    if (value == null || value.isEmpty) {
      return null;
    }

    return regexp.hasMatch(value) ? null : 'Email inválido';
  }
}

void main() {
  late EmailValidation sut;

  setUp(() {
    sut = EmailValidation('field');
  });

  test('Should return null if email is empty', () {
    final error = sut.validate('');

    expect(error, isNull);
  });

  test('Should return null if email is null', () {
    final error = sut.validate(null);

    expect(error, isNull);
  });

  test('Should return null if email is valid', () {
    final error = sut.validate(faker.internet.email());

    expect(error, isNull);
  });

  test('Should return error if email is invalid', () {
    final error = sut.validate('asd.com');

    expect(error, 'Email inválido');
  });
}
