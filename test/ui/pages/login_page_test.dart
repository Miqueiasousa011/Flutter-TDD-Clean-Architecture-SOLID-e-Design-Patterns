import 'dart:async';

import 'package:faker/faker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'package:fordev/ui/pages/pages.dart';

import 'login_page_test.mocks.dart';

@GenerateMocks([LoginPresenter])
void main() {
  late MockLoginPresenter presenter;

  late StreamController<String?> emailErrorController;
  late StreamController<String?> passwordErrorController;
  late StreamController<bool> isFormValidController;
  late StreamController<bool> isLoadingController;

  setUp(() {
    presenter = MockLoginPresenter();

    emailErrorController = StreamController();
    when(presenter.emailErrorStream).thenAnswer(
      (_) => emailErrorController.stream,
    );

    passwordErrorController = StreamController();
    when(presenter.passwordErrorStream)
        .thenAnswer((_) => passwordErrorController.stream);

    isFormValidController = StreamController();

    when(presenter.isFormValidController)
        .thenAnswer((_) => isFormValidController.stream);

    isLoadingController = StreamController();
    when(presenter.isLoadingController)
        .thenAnswer((_) => isLoadingController.stream);
  });

  tearDown(() {
    emailErrorController.close();
    passwordErrorController.close();
    isFormValidController.close();
    isLoadingController.close();
  });

  testWidgets('Should load with correct initial state',
      (WidgetTester tester) async {
    /// Crio uma instancia de LoginPage
    /// Como o componente utiliza componentes do Material Design,
    /// o mesmo deve estar envolvido em um MaterialApp()
    final loginPage = MaterialApp(
        home: LoginPage(
      loginPresenter: presenter,
    ));

    ///MANDO RENDERIZAR O COMPONENTE
    await tester.pumpWidget(loginPage);

    /// Testando que o TextFormField não possui erro
    /// Se a propriedade errorText não for nula, significa que o componente possue erro

    ///Pegando todos os filhos do TextFormField
    final emailChildren = find.descendant(
      ///Procura qualquer campo que possui uma label email
      of: find.bySemanticsLabel('Email'),
      matching: find.byType(Text),
    );

    expect(emailChildren, findsOneWidget,
        reason:
            'Quando o TextFormField tiver apenas um filho, significa que o o input não tem erros, pois o mesmo sempre terá um labelText');

    final passwordChildren = find.descendant(
      of: find.bySemanticsLabel('Senha'),
      matching: find.byType(Text),
    );

    expect(passwordChildren, findsOneWidget);

    final button = tester.widget<ElevatedButton>(find.byType(ElevatedButton));

    expect(button.onPressed, isNull);
  });

  testWidgets('Should call validate with correct values', (tester) async {
    final loginPage = MaterialApp(
        home: LoginPage(
      loginPresenter: presenter,
    ));

    await tester.pumpWidget(loginPage);

    final email = faker.internet.email();

    ///Adicionando o texto ao textformfield do email
    await tester.enterText(find.bySemanticsLabel('Email'), email);

    ///SEMPRE QUE O CAMPO DE EMAIL FOR MODIFICADO, O MÉTODO validateEmail deve ser chamado
    verify(presenter.validateEmail(email));

    final password = faker.internet.password();

    ///Adicionando uma senha ao input de senha
    await tester.enterText(find.bySemanticsLabel('Senha'), password);

    ///Verificando se o método de validação de senha está sendo chamado
    ///Sempre que o campo é alterado
    verify(presenter.validatePassword(password));
  });

  testWidgets('Should present error if email is invalid', (tester) async {
    final loginPage = MaterialApp(
      home: LoginPage(loginPresenter: presenter),
    );

    ///RENDERIZO A TELA
    await tester.pumpWidget(loginPage);

    ///altera estado
    emailErrorController.add('email error');

    ///Renderiza a tela novamente
    await tester.pump();

    expect(find.text('email error'), findsOneWidget);
  });

  testWidgets('Should present error if password is invalid', (tester) async {
    final loginPage = MaterialApp(home: LoginPage(loginPresenter: presenter));

    await tester.pumpWidget(loginPage);

    passwordErrorController.add('password error');

    await tester.pump();

    expect(find.text('password error'), findsOneWidget);
  });

  testWidgets('should presents no error if email is valid', (tester) async {
    final loginPage = MaterialApp(home: LoginPage(loginPresenter: presenter));

    await tester.pumpWidget(loginPage);

    emailErrorController.add(null);

    expect(
      find.descendant(
        of: find.bySemanticsLabel('Email'),
        matching: find.byType(Text),
      ),
      findsOneWidget,
    );
  });

  testWidgets('should presents no error if password is valid', (tester) async {
    final loginPage = MaterialApp(home: LoginPage(loginPresenter: presenter));

    await tester.pumpWidget(loginPage);

    passwordErrorController.add(null);

    await tester.pump();

    expect(
      find.descendant(
        of: find.bySemanticsLabel('Senha'),
        matching: find.byType(Text),
      ),
      findsOneWidget,
    );
  });

  testWidgets('should enable button if form is valid', (tester) async {
    final loginPage = MaterialApp(home: LoginPage(loginPresenter: presenter));

    await tester.pumpWidget(loginPage);

    isFormValidController.add(true);

    await tester.pump();

    final button = tester.widget<ElevatedButton>(find.byType(ElevatedButton));

    expect(button.onPressed, isNotNull);
  });

  testWidgets('should desable button if form is invalid', (tester) async {
    final loginPage = MaterialApp(home: LoginPage(loginPresenter: presenter));

    await tester.pumpWidget(loginPage);

    isFormValidController.add(false);

    await tester.pump();

    final button = tester.widget<ElevatedButton>(find.byType(ElevatedButton));
    expect(button.onPressed, isNull);
  });

  testWidgets('shoul call authentication on form submit', (tester) async {
    final loginPage = MaterialApp(home: LoginPage(loginPresenter: presenter));

    await tester.pumpWidget(loginPage);

    ///FORMULÁRIO ESTÁ VÁLIDO, LOGO O BOTÃO SERÁ ATIVADO
    isFormValidController.add(true);

    /// tela reage
    await tester.pump();

    ///CLICANDO NO BOTÃO DE LOGIN
    await tester.tap(find.byType(ElevatedButton));

    /// tela reage
    await tester.pump();

    verify(presenter.auth()).called(1);
  });

  testWidgets('should show loading', (tester) async {
    final loginPage = MaterialApp(home: LoginPage(loginPresenter: presenter));

    await tester.pumpWidget(loginPage);

    isLoadingController.add(true);

    await tester.pump();

    //Deve ser encontrado um CircularProgressIndicator
    expect(find.byType(CircularProgressIndicator), findsOneWidget);
  });

  testWidgets('Should hiden loading', (tester) async {
    final loginPage = MaterialApp(home: LoginPage(loginPresenter: presenter));

    await tester.pumpWidget(loginPage);

    //Loading está sendo exibido
    isLoadingController.add(true);

    await tester.pump();

    //Fechando loading
    isLoadingController.add(false);

    await tester.pump();

    expect(find.byType(CircularProgressIndicator), findsNothing);
  });
}
