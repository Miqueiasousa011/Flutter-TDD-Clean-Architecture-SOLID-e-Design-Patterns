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
    return null;
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
    when(val2.validate(any)).thenReturn('');
    when(val1.validate(any)).thenReturn(null);

    sut = ValidationComposite([val1, val2]);
  });

  test('Should return null if all validations returns null or empty', () {
    final error = sut.validate(field: 'any_field', value: 'any_value');

    expect(error, isNull);
  });
}
