import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:test/test.dart';

import 'package:fordev/presentation/protocols/protocols.dart';
import 'package:fordev/validation/protocols/protocols.dart';

import 'validation_composite_test.mocks.dart';

class ValidationComposite implements Validation {
  final List<FieldValidation> validations;

  ValidationComposite(this.validations);

  @override
  String? validate({required String field, required value}) {
    String? error;

    for (var validation in validations) {
      error = validation.validate(value);
      if (error != null) {
        return error;
      }
    }

    return error;
  }
}

@GenerateMocks([FieldValidation])
void main() {
  late ValidationComposite sut;
  late MockFieldValidation val1;
  late MockFieldValidation val2;

  setUp(() {
    val1 = MockFieldValidation();
    val2 = MockFieldValidation();

    when(val1.field).thenReturn('any_field');
    when(val2.field).thenReturn('any_field');

    when(val1.validate(any)).thenReturn(null);
    when(val2.validate(any)).thenReturn(null);

    sut = ValidationComposite([val1, val2]);
  });

  test('Should return null if all validations returns null', () {
    final error = sut.validate(field: 'any_field', value: 'any_value');

    expect(error, isNull);
  });

  test('Should return first error if validations fail', () {
    when(val1.validate(any)).thenReturn('error_1');
    when(val2.validate(any)).thenReturn('error_2');

    final error = sut.validate(field: 'any_field', value: 'any_value');

    expect(error, 'error_1');
  });
}
