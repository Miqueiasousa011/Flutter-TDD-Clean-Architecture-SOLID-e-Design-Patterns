import 'package:test/test.dart';

import 'package:fordev/presentation/protocols/validation.dart';
import 'package:fordev/validation/validators/validators.dart';

void main() {
  late CompareFieldsValidation sut;

  setUp(() {
    sut = const CompareFieldsValidation(
      field: 'any_field',
      fieldToCompare: 'other_field',
    );
  });

  test('Should return error if value is not equals', () {
    final formData = {'any_field': 'any_value', 'other_field': 'other_value'};
    final error = sut.validate(formData);

    expect(error, ValidationError.invalidField);
  });

  test('Should return null if value its equals', () {
    final formData = {'any_field': 'any_value', 'other_field': 'any_value'};
    final error = sut.validate(formData);

    expect(error, isNull);
  });
}
