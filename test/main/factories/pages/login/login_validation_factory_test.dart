import 'package:flutter_test/flutter_test.dart';
import 'package:fordev/main/factories/pages/pages.dart';
import 'package:fordev/validation/validators/validators.dart';

void main() {
  test(
    'Should return the correct validations',
    () {
      final validations = makeLoginValidation();

      expect(
        validations,
        equals(
          const [
            EmailValidation('email'),
            RequiredFieldValidation('email'),
            RequiredFieldValidation('password'),
            MinLengthValidation(field: 'password', size: 3),
          ],
        ),
      );
    },
  );
}
