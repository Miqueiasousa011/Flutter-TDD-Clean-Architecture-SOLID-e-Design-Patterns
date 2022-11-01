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
            RequiredFieldValidation('email'),
            RequiredFieldValidation('password'),
            EmailValidation('email'),
          ],
        ),
      );
    },
  );
}
