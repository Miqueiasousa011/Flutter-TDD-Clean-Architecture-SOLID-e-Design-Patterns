import 'package:fordev/presentation/protocols/validation.dart';
import 'package:fordev/validation/protocols/protocols.dart';
import 'package:test/test.dart';

class CompareFieldsValidation implements FieldValidation {
  final String _field;
  final String? _valueToCompare;

  const CompareFieldsValidation({
    required String field,
    required String? valueToCompare,
  })  : _field = field,
        _valueToCompare = valueToCompare;

  @override
  String get field => _field;

  @override
  ValidationError? validate(String? value) {
    return ValidationError.invalidField;
  }
}

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
}
