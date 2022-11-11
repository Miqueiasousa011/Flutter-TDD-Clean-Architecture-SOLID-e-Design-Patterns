import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fordev/ui/pages/signup/signup.dart';
import 'package:fordev/utils/i18n/resources.dart';
import 'package:get/route_manager.dart';

void main() {
  Future<void> loadPage(WidgetTester tester) async {
    final page = GetMaterialApp(
      initialRoute: '/signup',
      getPages: [GetPage(name: '/signup', page: () => const SignUpPage())],
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
}
