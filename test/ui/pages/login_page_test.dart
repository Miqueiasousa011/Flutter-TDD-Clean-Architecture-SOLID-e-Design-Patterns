import 'dart:async';

import 'package:faker/faker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fordev/ui/helpers/ui_error.dart';
import 'package:get/route_manager.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'package:fordev/ui/pages/pages.dart';

import 'login_page_test.mocks.dart';

@GenerateMocks([LoginPresenter])
void main() {
  late MockLoginPresenter presenter;

  late StreamController<UIError?> emailErrorController;
  late StreamController<UIError?> passwordErrorController;
  late StreamController<bool> isFormValidController;
  late StreamController<bool> isLoadingController;
  late StreamController<UIError?> mainErrorController;
  late StreamController<String?> navigateToStream;

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

    mainErrorController = StreamController();
    when(presenter.mainErrorController)
        .thenAnswer((_) => mainErrorController.stream);

    navigateToStream = StreamController();
    when(presenter.navigateToStream).thenAnswer((_) => navigateToStream.stream);
  });

  tearDown(() {
    emailErrorController.close();
    passwordErrorController.close();
    isFormValidController.close();
    isLoadingController.close();
    mainErrorController.close();
  });

  testWidgets('Should load with correct initial state',
      (WidgetTester tester) async {
    /// Crio uma instancia de LoginPage
    /// Como o componente utiliza componentes do Material Design,
    /// o mesmo deve estar envolvido em um MaterialApp()
    final loginPage = GetMaterialApp(
        home: LoginPage(
      loginPresenter: presenter,
    ));

    ///MANDO RENDERIZAR O COMPONENTE
    await tester.pumpWidget(loginPage);

    /// Testando que o TextFormField n??o possui erro
    /// Se a propriedade errorText n??o for nula, significa que o componente possue erro

    ///Pegando todos os filhos do TextFormField
    final emailChildren = find.descendant(
      ///Procura qualquer campo que possui uma label email
      of: find.bySemanticsLabel('Email'),
      matching: find.byType(Text),
    );

    expect(emailChildren, findsOneWidget,
        reason:
            'Quando o TextFormField tiver apenas um filho, significa que o o input n??o tem erros, pois o mesmo sempre ter?? um labelText');

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

    ///SEMPRE QUE O CAMPO DE EMAIL FOR MODIFICADO, O M??TODO validateEmail deve ser chamado
    verify(presenter.validateEmail(email));

    final password = faker.internet.password();

    ///Adicionando uma senha ao input de senha
    await tester.enterText(find.bySemanticsLabel('Senha'), password);

    ///Verificando se o m??todo de valida????o de senha est?? sendo chamado
    ///Sempre que o campo ?? alterado
    verify(presenter.validatePassword(password));
  });

  testWidgets('Should present error if email is invalid', (tester) async {
    final loginPage = MaterialApp(
      home: LoginPage(loginPresenter: presenter),
    );

    ///RENDERIZO A TELA
    await tester.pumpWidget(loginPage);

    ///altera estado
    emailErrorController.add(UIError.invalidField);

    ///Renderiza a tela novamente
    await tester.pump();

    expect(find.text(UIError.invalidField.description), findsOneWidget);
  });

  testWidgets('Should present error if password is invalid', (tester) async {
    final loginPage = MaterialApp(home: LoginPage(loginPresenter: presenter));

    await tester.pumpWidget(loginPage);

    passwordErrorController.add(UIError.requiredField);

    await tester.pump();

    expect(find.text(UIError.requiredField.description), findsOneWidget);
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

    ///FORMUL??RIO EST?? V??LIDO, LOGO O BOT??O SER?? ATIVADO
    isFormValidController.add(true);

    /// tela reage
    await tester.pump();

    ///CLICANDO NO BOT??O DE LOGIN
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

    //Loading est?? sendo exibido
    isLoadingController.add(true);

    await tester.pump();

    //Fechando loading
    isLoadingController.add(false);

    await tester.pump();

    expect(find.byType(CircularProgressIndicator), findsNothing);
  });

  testWidgets(
    'Should show error message if authentication fails',
    (tester) async {
      final loginPage = MaterialApp(home: LoginPage(loginPresenter: presenter));

      await tester.pumpWidget(loginPage);

      mainErrorController.add(UIError.unexpected);

      await tester.pump();

      expect(find.text(UIError.unexpected.description), findsOneWidget);
    },
  );

  testWidgets('should close streams on dispose', (tester) async {
    final loginPage = MaterialApp(home: LoginPage(loginPresenter: presenter));

    await tester.pumpWidget(loginPage);

    ///Recurso que ?? chamado depois que o widget ?? destruido
    ///Simula o dispose
    addTearDown(() {
      verify(presenter.dispose()).called(1);
    });
  });

  testWidgets('should navigate to /surveys', (tester) async {
    final loginPage = GetMaterialApp(
      initialRoute: '/login',
      getPages: [
        GetPage(
          name: '/login',
          page: () => LoginPage(loginPresenter: presenter),
        ),
        GetPage(
          name: '/surveys',
          page: () => const Scaffold(
            body: Center(
              child: Text('ENQUETES'),
            ),
          ),
        ),
      ],
    );

    await tester.pumpWidget(loginPage);

    navigateToStream.add('/surveys');

    await tester.pumpAndSettle();

    expect(Get.currentRoute, '/surveys');
  });

  testWidgets('Should call goToSignUp on button clicked', (tester) async {
    final loginPage = GetMaterialApp(
      initialRoute: '/login',
      getPages: [
        GetPage(
          name: '/login',
          page: () => LoginPage(loginPresenter: presenter),
        ),
        GetPage(
          name: '/signup',
          page: () => const Scaffold(
            body: Center(
              child: Text('signup'),
            ),
          ),
        ),
      ],
    );

    await tester.pumpWidget(loginPage);

    final button = find.text('Criar conta');
    await tester.ensureVisible(button);
    await tester.tap(button);

    await tester.pump();

    verify(presenter.goToSignUp());
  });
}
