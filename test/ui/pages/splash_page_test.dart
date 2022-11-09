import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get/route_manager.dart';

class SplashPage extends StatelessWidget {
  const SplashPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(
        child: CircularProgressIndicator(),
      ),
    );
  }
}

void main() {
  Future<void> loadPage(tester) async {
    final splashPage = GetMaterialApp(
      initialRoute: '/',
      getPages: [GetPage(name: '/', page: () => const SplashPage())],
    );

    await tester.pumpWidget(splashPage);
  }

  testWidgets('Should present spinner on page load', (tester) async {
    await loadPage(tester);

    expect(Get.currentRoute, equals('/'));
    expect(find.byType(CircularProgressIndicator), findsOneWidget);
  });
}
