import 'package:fordev/domain/entities/account_entity.dart';
import 'package:fordev/domain/usecases/usecases.dart';
import 'package:fordev/ui/helpers/helpers.dart';
import 'package:mockito/mockito.dart';
import 'package:test/test.dart';
import 'package:faker/faker.dart';
import 'package:mockito/annotations.dart';

import 'package:fordev/presentation/protocols/validation.dart';
import 'package:fordev/presentation/presenters/presenters.dart';

import 'getx_signup_presenter_test.mocks.dart';

@GenerateMocks([Validation, AddAccountUsecase])
void main() {
  late GetxSignUpPresenter sut;
  late MockValidation validation;
  late MockAddAccountUsecase addAccount;
  late AddAccountParams addAccountParams;

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

    addAccount = MockAddAccountUsecase();
    addAccountParams = AddAccountParams(
      name: name,
      email: email,
      password: password,
      passwordConfirmation: passwordConfirmation,
    );
    sut = GetxSignUpPresenter(
      validation: validation,
      addAccountUsecase: addAccount,
    );
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

  group('Password Confirmation field', () {
    test('Should call Validation with correct password confirmation', () {
      when(
        validation.validate(field: anyNamed('field'), value: anyNamed('value')),
      ).thenReturn(null);

      sut.validatePasswordConfirmation(password);
      verify(
          validation.validate(field: 'password confirmation', value: password));
    });

    test('Should emits invalidFieldError if password confirmation is invalid',
        () {
      when(
        validation.validate(field: anyNamed('field'), value: anyNamed('value')),
      ).thenReturn(ValidationError.invalidField);

      sut.passwordConfirmationErrorController
          .listen(expectAsync1((error) => expect(error, UIError.invalidField)));
      sut.isFormValidController
          .listen(expectAsync1((isValid) => expect(isValid, isFalse)));

      sut.validatePasswordConfirmation(password);
      sut.validatePasswordConfirmation(password);
    });

    test('Should emits requiredFieldError if password confirmation is empty',
        () {
      when(
        validation.validate(field: anyNamed('field'), value: anyNamed('value')),
      ).thenReturn(ValidationError.requiredField);

      sut.passwordConfirmationErrorController.listen(
          expectAsync1((error) => expect(error, UIError.requiredField)));
      sut.isFormValidController
          .listen(expectAsync1((isValid) => expect(isValid, isFalse)));

      sut.validatePasswordConfirmation(password);
    });

    test('Should emits null if valildation success', () {
      when(
        validation.validate(field: anyNamed('field'), value: anyNamed('value')),
      ).thenReturn(null);

      sut.passwordConfirmationErrorController
          .listen(expectAsync1((error) => expect(error, isNull)));
      sut.isFormValidController
          .listen(expectAsync1((isValid) => expect(isValid, isFalse)));

      sut.validatePasswordConfirmation(password);
    });
  });

  test('Should enable form button if all fields avalid', () async {
    when(validation.validate(field: 'name', value: name)).thenReturn(null);
    when(validation.validate(field: 'email', value: email)).thenReturn(null);
    when(
      validation.validate(field: 'password', value: password),
    ).thenReturn(null);
    when(
      validation.validate(
          field: 'password confirmation', value: passwordConfirmation),
    ).thenReturn(null);

    expectLater(sut.isFormValidController, emitsInOrder([false, true]));

    sut.validateName(name);
    await Future.delayed(Duration.zero);
    sut.validateEmail(email);
    await Future.delayed(Duration.zero);
    sut.validatePassword(password);
    await Future.delayed(Duration.zero);
    sut.validatePasswordConfirmation(password);
    await Future.delayed(Duration.zero);
  });

  test('Should call addAccount eith correct values', () async {
    when(validation.validate(field: 'name', value: name)).thenReturn(null);
    when(validation.validate(field: 'email', value: email)).thenReturn(null);
    when(validation.validate(
      field: 'password',
      value: password,
    )).thenReturn(null);
    when(validation.validate(
      field: 'password confirmation',
      value: passwordConfirmation,
    )).thenReturn(null);

    when(addAccount.add(any))
        .thenAnswer((_) async => const AccountEntity(token: 'token'));

    sut.validateName(name);
    sut.validateEmail(email);
    sut.validatePassword(password);
    sut.validatePasswordConfirmation(password);

    await sut.signUp();

    verify(addAccount.add(addAccountParams));
  });
}
