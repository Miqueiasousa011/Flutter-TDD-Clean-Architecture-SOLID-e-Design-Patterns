import 'package:faker/faker.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fordev/presentation/protocols/protocols.dart';
import 'package:fordev/validation/validators/validators.dart';

void main() {
  late EmailValidation sut;

  setUp(() {
    sut = const EmailValidation('email');
  });

  test('Should return null if email is empty', () {
    final error = sut.validate({'email': ''});

    expect(error, isNull);
  });

  test('Should return null if email is null', () {
    final error = sut.validate({'email': null});

    expect(error, isNull);
  });

  test('Should return null if email is valid', () {
    final error = sut.validate({'email': faker.internet.email()});

    expect(error, isNull);
  });

  test('Should return error if email is invalid', () {
    final error = sut.validate({'email': 'asd.com'});

    expect(error, ValidationError.invalidField);
  });
}
