import 'package:faker/faker.dart';
import 'package:flutter_test/flutter_test.dart';

abstract class FieldValidation {
  String? validate(String? value);
}

class RequiredFieldValidation implements FieldValidation {
  final String? field;

  RequiredFieldValidation(this.field);

  @override
  String? validate(String? value) {
    if (value == null || value.isEmpty == true) {
      return 'Campo obrigatório';
    }

    return null;
  }
}

void main() {
  late RequiredFieldValidation sut;
  late String value;

  setUp(() {
    value = faker.person.name();

    sut = RequiredFieldValidation(value);
  });

  test('Should return null if value is not empty', () {
    final error = sut.validate(value);

    expect(error, isNull);
  });

  test('Should return error if value is empty', () {
    final error = sut.validate(null);

    expect(error, equals('Campo obrigatório'));
  });
}
