import 'package:test/test.dart';

import 'package:fordev/presentation/protocols/validation.dart';
import 'package:fordev/validation/validators/validators.dart';

void main() {
  late CompareFieldsValidation sut;

  setUp(() {
    sut = const CompareFieldsValidation(
      field: 'any',
      valueToCompare: 'any_value',
    );
  });

  test('Should return error if value is not equals', () {
    final error = sut.validate('wrong_value');

    expect(error, ValidationError.invalidField);
  });

  test('Should return null if value its equals', () {
    final error = sut.validate('any_value');

    expect(error, isNull);
  });
}
