import 'package:faker/faker.dart';

import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:test/test.dart';

import 'package:fordev/presentation/presenters/presenters.dart';
import 'package:fordev/presentation/protocols/protocols.dart';

import 'stream_login_presenter_test.mocks.dart';

///A RESPONSABILIDADE DO PRESENTER É GERENCIAMENTO DE ESTADO

@GenerateMocks([Validation])
void main() {
  late StreamLoginPresenter sut;
  late MockValidation validation;

  late String email;
  late String password;

  setUp(() {
    email = faker.internet.email();
    password = faker.internet.password();

    validation = MockValidation();

    sut = StreamLoginPresenter(validation: validation);
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
}
