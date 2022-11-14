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

  group('Email field', () {
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

      sut.emailErrorController.listen(
          expectAsync1((error) => expect(error, UIError.requiredField)));
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
  });

  group('Name field', () {
    test('Should call Validation with correct name', () {
      when(
        validation.validate(field: anyNamed('field'), value: anyNamed('value')),
      ).thenReturn(null);

      sut.validateName(name);
      verify(validation.validate(field: 'name', value: name));
    });

    test('Should emits invalidFieldError if name is invalid', () {
      when(
        validation.validate(field: anyNamed('field'), value: anyNamed('value')),
      ).thenReturn(ValidationError.invalidField);

      sut.nameErrorController
          .listen(expectAsync1((error) => expect(error, UIError.invalidField)));
      sut.isFormValidController
          .listen(expectAsync1((isValid) => expect(isValid, isFalse)));

      sut.validateName(name);
      sut.validateName(name);
    });

    test('Should emits requiredFieldError if name is empty', () {
      when(
        validation.validate(field: anyNamed('field'), value: anyNamed('value')),
      ).thenReturn(ValidationError.requiredField);

      sut.nameErrorController.listen(
          expectAsync1((error) => expect(error, UIError.requiredField)));
      sut.isFormValidController
          .listen(expectAsync1((isValid) => expect(isValid, isFalse)));

      sut.validateName(name);
    });

    test('Should emits null if valildation success', () {
      when(
        validation.validate(field: anyNamed('field'), value: anyNamed('value')),
      ).thenReturn(null);

      sut.nameErrorController
          .listen(expectAsync1((error) => expect(error, isNull)));
      sut.isFormValidController
          .listen(expectAsync1((isValid) => expect(isValid, isFalse)));

      sut.validateName(name);
    });
  });

  group('Password field', () {
    test('Should call Validation with correct password', () {
      when(
        validation.validate(field: anyNamed('field'), value: anyNamed('value')),
      ).thenReturn(null);

      sut.validatePassword(password);
      verify(validation.validate(field: 'password', value: password));
    });

    test('Should emits invalidFieldError if password is invalid', () {
      when(
        validation.validate(field: anyNamed('field'), value: anyNamed('value')),
      ).thenReturn(ValidationError.invalidField);

      sut.passwordErrorController
          .listen(expectAsync1((error) => expect(error, UIError.invalidField)));
      sut.isFormValidController
          .listen(expectAsync1((isValid) => expect(isValid, isFalse)));

      sut.validatePassword(password);
      sut.validatePassword(password);
    });

    test('Should emits requiredFieldError if password is empty', () {
      when(
        validation.validate(field: anyNamed('field'), value: anyNamed('value')),
      ).thenReturn(ValidationError.requiredField);

      sut.passwordErrorController.listen(
          expectAsync1((error) => expect(error, UIError.requiredField)));
      sut.isFormValidController
          .listen(expectAsync1((isValid) => expect(isValid, isFalse)));

      sut.validatePassword(password);
    });

    test('Should emits null if valildation success', () {
      when(
        validation.validate(field: anyNamed('field'), value: anyNamed('value')),
      ).thenReturn(null);

      sut.passwordErrorController
          .listen(expectAsync1((error) => expect(error, isNull)));
      sut.isFormValidController
          .listen(expectAsync1((isValid) => expect(isValid, isFalse)));

      sut.validatePassword(password);
    });
  });
}
