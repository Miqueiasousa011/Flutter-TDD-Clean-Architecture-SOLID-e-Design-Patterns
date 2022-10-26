import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fordev/ui/pages/pages.dart';

void main() {
  testWidgets('Should load with correct initial state',
      (WidgetTester tester) async {
    /// Crio uma instancia de LoginPage
    /// Como o componente utiliza componentes do Material Design,
    /// o mesmo deve estar envolvido em um MaterialApp()
    const loginPage = MaterialApp(home: LoginPage());

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
}
