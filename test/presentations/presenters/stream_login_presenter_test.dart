import 'package:faker/faker.dart';
import 'package:fordev/domain/entities/account_entity.dart';
import 'package:fordev/domain/usecases/usecases.dart';

import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:test/test.dart';

import 'package:fordev/presentation/presenters/presenters.dart';
import 'package:fordev/presentation/protocols/protocols.dart';

import 'stream_login_presenter_test.mocks.dart';

///A RESPONSABILIDADE DO PRESENTER É GERENCIAMENTO DE ESTADO

@GenerateMocks([Validation, AuthenticationUsecase])
void main() {
  late StreamLoginPresenter sut;
  late MockValidation validation;
  late MockAuthenticationUsecase authentication;

  late String email;
  late String password;
  late AuthenticationParams authenticationParams;

  late AccountEntity accountEntity;

  setUp(() {
    email = faker.internet.email();
    password = faker.internet.password();

    authenticationParams = AuthenticationParams(
      email: email,
      password: password,
    );

    accountEntity = AccountEntity(token: faker.guid.guid());

    validation = MockValidation();
    authentication = MockAuthenticationUsecase();

    sut = StreamLoginPresenter(
      validation: validation,
      authenticationUsecase: authentication,
    );
  });

  test('Should call Validation with correct email', () {
    when(validation.validate(
            field: anyNamed('field'), value: anyNamed('value')))
        .thenReturn('any');

    sut.validateEmail(email);

    verify(validation.validate(field: 'email', value: email)).called(1);
  });

  test('Should emit email error if Validation fails', () {
    when(validation.validate(
            field: anyNamed('field'), value: anyNamed('value')))
        .thenReturn('error');

    /// GARANTIR QUE A TELA SEJA RENDERIZADA APENAS UMA VEZ,
    /// CASO O MESMO ERRO SEJA EMITIDO VARIAS VEZES
    sut.emailErrorStream
        .listen(expectAsync1((error) => expect(error, 'error')));

    /// Notificando que o formulário não está válido
    sut.isFormValidController
        .listen(expectAsync1((isValid) => expect(isValid, isFalse)));

    sut.validateEmail(email);

    ///ESTÁ REPETIDO PARA SIMULAR O MESMO ERRO OCORRENDO MAIS DE UMA VEZ
    sut.validateEmail(email);
  });

  test('Should emit null if email is valid', () {
    when(validation.validate(
            field: anyNamed('field'), value: anyNamed('value')))
        .thenReturn(null);

    sut.emailErrorStream.listen(expectAsync1(
      (error) => expect(error, isNull),
    ));

    ///O formulário ainda emit false, pois o password ainda não foi validado
    sut.isFormValidController
        .listen(expectAsync1((error) => expect(error, isFalse)));

    sut.validateEmail(email);
    sut.validateEmail(email);
  });

  test('Should call Validation with correct password', () {
    when(validation.validate(
            field: anyNamed('field'), value: anyNamed('value')))
        .thenReturn('any');

    sut.validatePassword(password);

    verify(validation.validate(field: 'password', value: password)).called(1);
  });

  test('should password error if Validation fails', () {
    when(validation.validate(
            field: anyNamed('field'), value: anyNamed('value')))
        .thenReturn('error');

    sut.passwordErrorStream
        .listen(expectAsync1((error) => expect(error, 'error')));

    sut.isFormValidController
        .listen(expectAsync1((isValid) => expect(isValid, isFalse)));

    sut.validatePassword(password);
    sut.validatePassword(password);
  });

  test('Should emits null if password is valid', () {
    when(validation.validate(
            field: anyNamed('field'), value: anyNamed('value')))
        .thenReturn(null);

    sut.passwordErrorStream
        .listen(expectAsync1((error) => expect(error, isNull)));

    sut.isFormValidController
        .listen(expectAsync1((isValid) => expect(isValid, isFalse)));

    sut.validatePassword(password);
    sut.validatePassword(password);
  });

  test('Should emits form is not valid if has error', () {
    when(validation.validate(field: 'email', value: anyNamed('value')))
        .thenReturn('error');

    when(validation.validate(field: 'password', value: anyNamed('value')))
        .thenReturn(null);

    sut.emailErrorStream
        .listen(expectAsync1((error) => expect(error, equals('error'))));

    sut.passwordErrorStream
        .listen(expectAsync1((error) => expect(error, isNull)));

    sut.isFormValidController
        .listen(expectAsync1((isValid) => expect(isValid, isFalse)));

    sut.validateEmail(email);
    sut.validatePassword(password);
  });

  test('should emits form is valid if not has error', () async {
    when(validation.validate(field: 'email', value: anyNamed('value')))
        .thenReturn(null);

    when(validation.validate(field: 'password', value: anyNamed('value')))
        .thenReturn(null);

    sut.emailErrorStream.listen(expectAsync1((error) => expect(error, isNull)));

    sut.passwordErrorStream
        .listen(expectAsync1((error) => expect(error, isNull)));

    expectLater(sut.isFormValidController, emitsInAnyOrder([isFalse, isTrue]));

    sut.validateEmail(email);
    await Future.delayed(Duration.zero);
    sut.validatePassword(password);
  });

  test('Should call Authentication with correct values', () async {
    when(authentication.auth(any)).thenAnswer((_) async => accountEntity);

    when(validation.validate(field: 'email', value: anyNamed('value')))
        .thenReturn(null);

    when(validation.validate(field: 'password', value: anyNamed('value')))
        .thenReturn(null);

    sut.validateEmail(email);
    sut.validatePassword(password);

    await sut.auth();

    ///Aqui é feita uma comparação entre os objetos enviados no parâmetros. Por isso é necessário adicionar o equatable
    verify(authentication.auth(authenticationParams)).called(1);
  });

  test('Should emit correct events on Authentication success', () async {
    when(authentication.auth(any)).thenAnswer((_) async => accountEntity);

    when(validation.validate(field: 'email', value: anyNamed('value')))
        .thenReturn(null);

    when(validation.validate(field: 'password', value: anyNamed('value')))
        .thenReturn(null);

    sut.validateEmail(email);
    sut.validatePassword(password);

    expectLater(sut.isLoadingController, emitsInOrder([isTrue, isFalse]));

    await sut.auth();
  });
}
