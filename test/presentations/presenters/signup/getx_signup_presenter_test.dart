import 'package:fordev/ui/helpers/helpers.dart';
import 'package:mockito/mockito.dart';
import 'package:test/test.dart';
import 'package:faker/faker.dart';
import 'package:mockito/annotations.dart';

import 'package:fordev/presentation/protocols/validation.dart';
import 'package:fordev/presentation/presenters/presenters.dart';

import 'getx_signup_presenter_test.mocks.dart';

@GenerateMocks([Validation])
void main() {
  late GetxSignUpPresenter sut;
  late MockValidation validation;

  late String name;
  late String email;
  late String password;
  late String passwordConfirmation;

  setUp(() {
    name = faker.person.name();
    email = faker.internet.email();
    password = faker.internet.password();
    passwordConfirmation = password;
    validation = MockValidation();
    sut = GetxSignUpPresenter(validation: validation);
  });

  test('Should call Validation with correct email', () async {
    when(validation.validate(field: 'email', value: email)).thenReturn(null);

    sut.validateEmail(email);

    verify(validation.validate(field: 'email', value: email)).called(1);
  });

  test('Should emit invalidFieldError if email is invalid', () async {
    when(
      validation.validate(field: anyNamed('field'), value: anyNamed('value')),
    ).thenReturn(ValidationError.invalidField);

    sut.emailErrorController
        .listen(expectAsync1((error) => expect(error, UIError.invalidField)));
    sut.isFormValidController
        .listen(expectAsync1((isValid) => expect(isValid, isFalse)));

    sut.validateEmail(email);
    sut.validateEmail(email);
  });

  test('Should emit requiredFieldError if email is empty', () async {
    when(
      validation.validate(field: anyNamed('field'), value: anyNamed('value')),
    ).thenReturn(ValidationError.requiredField);

    sut.emailErrorController
        .listen(expectAsync1((error) => expect(error, UIError.requiredField)));
    sut.isFormValidController
        .listen(expectAsync1((isValid) => expect(isValid, isFalse)));

    sut.validateEmail(email);
    sut.validateEmail(email);
  });

  test('Should emit null if Validation success', () {
    when(
      validation.validate(field: anyNamed('field'), value: anyNamed('value')),
    ).thenReturn(null);

    sut.emailErrorController
        .listen(expectAsync1((error) => expect(error, isNull)));
    sut.isFormValidController
        .listen(expectAsync1((isValid) => expect(isValid, isFalse)));

    sut.validateEmail(email);
    sut.validateEmail(email);
  });
}
