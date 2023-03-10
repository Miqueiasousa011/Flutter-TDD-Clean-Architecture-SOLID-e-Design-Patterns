import 'dart:async';

import 'package:faker/faker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get/route_manager.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'package:fordev/ui/pages/signup/signup.dart';
import 'package:fordev/utils/i18n/i18n.dart';
import 'package:fordev/ui/helpers/helpers.dart';

import 'signup_page_test.mocks.dart';

@GenerateMocks([SignUpPresenter])
void main() {
  late String name;
  late String email;
  late String password;
  late String passwordConfirmation;

  late MockSignUpPresenter presenter;

  late StreamController<UIError?> nameErrorController;
  late StreamController<UIError?> emailErrorController;
  late StreamController<UIError?> passwordErrorController;
  late StreamController<UIError?> passwordConfirmationErrorController;
  late StreamController<bool> isFormValidController;
  late StreamController<bool> isLoadingController;
  late StreamController<UIError?> mainErrorStreamController;
  late StreamController<String?> navigateToController;

  setUp(() {
    name = faker.person.name();
    email = faker.internet.email();
    password = faker.internet.password();
    passwordConfirmation = password;

    presenter = MockSignUpPresenter();

    nameErrorController = StreamController();
    when(presenter.nameErrorController)
        .thenAnswer((_) => nameErrorController.stream);

    emailErrorController = StreamController();
    when(presenter.emailErrorController)
        .thenAnswer((_) => emailErrorController.stream);

    passwordErrorController = StreamController();
    when(presenter.passwordErrorController)
        .thenAnswer((_) => passwordErrorController.stream);

    passwordConfirmationErrorController = StreamController();
    when(presenter.passwordConfirmationErrorController)
        .thenAnswer((_) => passwordConfirmationErrorController.stream);

    isFormValidController = StreamController();
    when(presenter.isFormValidController)
        .thenAnswer((_) => isFormValidController.stream);

    isLoadingController = StreamController();
    when(presenter.isLoadingController)
        .thenAnswer((_) => isLoadingController.stream);

    mainErrorStreamController = StreamController();
    when(presenter.mainErrorStreamController)
        .thenAnswer((_) => mainErrorStreamController.stream);

    navigateToController = StreamController();
    when(presenter.navigateToStream)
        .thenAnswer((_) => navigateToController.stream);
  });

  Future<void> loadPage(WidgetTester tester) async {
    final page = GetMaterialApp(
      initialRoute: '/signup',
      getPages: [
        GetPage(name: '/signup', page: () => SignUpPage(presenter: presenter)),
        GetPage(
          name: '/surveys',
          page: () => const Scaffold(body: Text('/surveys')),
        )
      ],
    );

    await tester.pumpWidget(page);
  }

  testWidgets('Should load with correct initial state', (tester) async {
    await loadPage(tester);

    final emailChildren = find.descendant(
      of: find.bySemanticsLabel(R.strings.email),
      matching: find.byType(Text),
    );
    expect(emailChildren, findsOneWidget);

    final nameChidren = find.descendant(
      of: find.bySemanticsLabel(R.strings.name),
      matching: find.byType(Text),
    );
    expect(nameChidren, findsOneWidget);

    final passwordChildren = find.descendant(
      of: find.bySemanticsLabel(R.strings.password),
      matching: find.byType(Text),
    );
    expect(passwordChildren, findsOneWidget);

    final passwordConfirmation = find.descendant(
      of: find.bySemanticsLabel(R.strings.passwordConfirmation),
      matching: find.byType(Text),
    );
    expect(passwordConfirmation, findsOneWidget);

    final signupButton =
        tester.widget<ElevatedButton>(find.byType(ElevatedButton));

    expect(signupButton.onPressed, isNull);
  });

  testWidgets('Should call validate with correct values', (tester) async {
    await loadPage(tester);

    await tester.enterText(find.bySemanticsLabel(R.strings.name), name);
    verify(presenter.validateName(name));

    await tester.enterText(find.bySemanticsLabel(R.strings.email), email);
    verify(presenter.validateEmail(email));

    await tester.enterText(find.bySemanticsLabel(R.strings.password), password);
    verify(presenter.validatePassword(password));

    await tester.enterText(
      find.bySemanticsLabel(R.strings.passwordConfirmation),
      passwordConfirmation,
    );
    verify(presenter.validatePasswordConfirmation(passwordConfirmation));
  });

  testWidgets('Should present error if name is invalid', (tester) async {
    await loadPage(tester);

    nameErrorController.add(UIError.requiredField);
    await tester.pump();
    expect(find.text(UIError.requiredField.description), findsOneWidget);

    nameErrorController.add(UIError.invalidField);
    await tester.pump();
    expect(find.text(UIError.invalidField.description), findsOneWidget);

    nameErrorController.add(null);
    await tester.pump();
    expect(
      find.descendant(
        of: find.bySemanticsLabel(R.strings.email),
        matching: find.byType(Text),
      ),
      findsOneWidget,
    );
  });

  testWidgets('Should present error if email is invalid', (tester) async {
    await loadPage(tester);

    emailErrorController.add(UIError.invalidField);
    await tester.pump();
    expect(find.text(UIError.invalidField.description), findsOneWidget);

    emailErrorController.add(UIError.requiredField);
    await tester.pump();
    expect(find.text(UIError.requiredField.description), findsOneWidget);

    emailErrorController.add(null);
    await tester.pump();
    expect(
      find.descendant(
        of: find.bySemanticsLabel(R.strings.email),
        matching: find.byType(Text),
      ),
      findsOneWidget,
    );
  });

  testWidgets('Should present error if password is invalid', (tester) async {
    await loadPage(tester);

    passwordErrorController.add(UIError.requiredField);
    await tester.pump();
    expect(find.text(UIError.requiredField.description), findsOneWidget);

    passwordErrorController.add(UIError.invalidField);
    await tester.pump();
    expect(find.text(UIError.invalidField.description), findsOneWidget);

    passwordErrorController.add(null);
    await tester.pump();
    expect(
      find.descendant(
        of: find.bySemanticsLabel(R.strings.password),
        matching: find.byType(Text),
      ),
      findsOneWidget,
    );
  });

  testWidgets('Should present error if passwordConfirmation is invalid',
      (tester) async {
    await loadPage(tester);

    passwordConfirmationErrorController.add(UIError.requiredField);
    await tester.pump();
    expect(find.text(UIError.requiredField.description), findsOneWidget);

    passwordConfirmationErrorController.add(UIError.invalidField);
    await tester.pump();
    expect(find.text(UIError.invalidField.description), findsOneWidget);

    passwordConfirmationErrorController.add(null);
    await tester.pump();
    expect(
      find.descendant(
        of: find.bySemanticsLabel(R.strings.passwordConfirmation),
        matching: find.byType(Text),
      ),
      findsOneWidget,
    );
  });

  testWidgets('should desable button if form is invalid', (tester) async {
    await loadPage(tester);

    isFormValidController.add(false);
    await tester.pump();

    final button = tester.widget<ElevatedButton>(find.byType(ElevatedButton));

    expect(button.onPressed, isNull);
  });

  testWidgets('should enable button if form is valid', (tester) async {
    await loadPage(tester);

    isFormValidController.add(true);
    await tester.pump();

    final button = tester.widget<ElevatedButton>(find.byType(ElevatedButton));

    expect(button.onPressed, isNotNull);
  });

  testWidgets('Should call signUp on form submit', (tester) async {
    await loadPage(tester);

    isFormValidController.add(true);
    await tester.pump();

    ///Garantir que o bot??o estar?? vis??vel
    await tester.ensureVisible(find.byType(ElevatedButton));
    await tester.tap(find.byType(ElevatedButton));
    await tester.pump();

    verify(presenter.signUp()).called(1);
  });

  testWidgets('Should show loading', (tester) async {
    await loadPage(tester);

    isLoadingController.add(true);

    await tester.pump();

    expect(find.byType(CircularProgressIndicator), findsOneWidget);
  });

  testWidgets('Should hide loading', (tester) async {
    await loadPage(tester);

    isLoadingController.add(true);
    await tester.pump();
    isLoadingController.add(false);
    await tester.pump();

    expect(find.byType(CircularProgressIndicator), findsNothing);
  });

  testWidgets('Should show error if segnup fails', (tester) async {
    await loadPage(tester);

    mainErrorStreamController.add(UIError.emailInUse);
    await tester.pump();

    expect(find.text(UIError.emailInUse.description), findsOneWidget);
  });

  testWidgets('Should show error if segnup throws', (tester) async {
    await loadPage(tester);

    mainErrorStreamController.add(UIError.unexpected);
    await tester.pump();

    expect(find.text(UIError.unexpected.description), findsOneWidget);
  });

  testWidgets('Should not change page ', (tester) async {
    await loadPage(tester);

    navigateToController.add('');

    await tester.pump();

    expect(Get.currentRoute, equals('/signup'));
  });

  testWidgets('Should navigate to homePage', (tester) async {
    await loadPage(tester);

    navigateToController.add('/surveys');

    await tester.pump();

    expect(Get.currentRoute, equals('/surveys'));
  });
}
