import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:test/test.dart';

import 'package:fordev/validation/protocols/protocols.dart';
import 'package:fordev/validation/validators/validators.dart';

import 'validation_composite_test.mocks.dart';

@GenerateMocks([FieldValidation])
void main() {
  late ValidationComposite sut;
  late MockFieldValidation val1;
  late MockFieldValidation val2;
  late MockFieldValidation val3;

  setUp(() {
    val1 = MockFieldValidation();
    val2 = MockFieldValidation();
    val3 = MockFieldValidation();

    when(val1.field).thenReturn('any_field_1');
    when(val2.field).thenReturn('any_field_2');
    when(val3.field).thenReturn('any_field_3');

    when(val1.validate(any)).thenReturn(null);
    when(val2.validate(any)).thenReturn(null);

    sut = ValidationComposite([val1, val2, val3]);
  });

  test('Should return null if all validations returns null', () {
    final error = sut.validate(field: 'any_field', value: 'any_value');

    expect(error, isNull);
  });

  test('Should return first error if validations fail', () {
    when(val1.validate(any)).thenReturn('error_1');
    when(val2.validate(any)).thenReturn('error_2');

    final error = sut.validate(field: 'any_field_2', value: 'any_value');

    expect(error, 'error_2');
  });

  test('Should return error of corresponding field', () {
    when(val1.validate(any)).thenReturn('error_1');
    when(val2.validate(any)).thenReturn('error_2');
    when(val3.validate(any)).thenReturn('other_error');
    final error = sut.validate(field: 'any_field_3', value: 'any_value');

    expect(error, 'other_error');
  });
}
