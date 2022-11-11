import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get/route_manager.dart';

class SignUpPage extends StatelessWidget {
  const SignUpPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Container();
  }
}

void main() {
  Future<void> loadPage(WidgetTester tester) async {
    final page = GetMaterialApp(
      initialRoute: '/signup',
      getPages: [GetPage(name: '/signup', page: () => SignUpPage())],
    );

    await tester.pumpWidget(page);
  }

  testWidgets('description', (tester) async {
    await loadPage(tester);
  });
}
