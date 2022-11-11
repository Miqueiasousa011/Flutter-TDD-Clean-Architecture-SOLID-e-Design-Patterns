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
  // late StreamController<UIError?> passwordConfirmationErrorController;

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

    // passwordConfirmationErrorController = StreamController();
    // when(presenter.passwordConfirmationErrorController)
    //     .thenAnswer((_) => passwordConfirmationErrorController.stream);
  });

  Future<void> loadPage(WidgetTester tester) async {
    final page = GetMaterialApp(
      initialRoute: '/signup',
      getPages: [
        GetPage(name: '/signup', page: () => SignUpPage(presenter: presenter))
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
}
