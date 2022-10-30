import 'package:flutter_test/flutter_test.dart';
import 'package:fordev/validation/protocols/protocols.dart';

class EmailValidation implements FieldValidation {
  final String field;

  EmailValidation(this.field);

  @override
  String? validate(String? value) {
    return null;
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
}
