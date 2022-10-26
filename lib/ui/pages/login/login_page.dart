import 'package:flutter/material.dart';
import 'package:fordev/ui/pages/pages.dart';

import '../../components/components.dart';

class LoginPage extends StatelessWidget {
  const LoginPage({super.key, this.loginPresenter});

  final LoginPresenter? loginPresenter;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            const LoginHeader(),
            const Headline1(text: 'login'),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Form(
                child: Column(
                  children: [
                    StreamBuilder<String?>(
                      stream: loginPresenter!.emailErrorStream,
                      builder: (context, snapshot) {
                        return TextFormField(
                          keyboardType: TextInputType.emailAddress,
                          decoration: InputDecoration(
                            errorText: snapshot.data,
                            hintText: 'Email',
                          ),
                          onChanged: (value) =>
                              loginPresenter!.validateEmail(value),
                        );
                      },
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      child: TextFormField(
                        obscureText: true,
                        decoration: const InputDecoration(hintText: 'Senha'),
                        onChanged: (value) =>
                            loginPresenter!.validatePassword(value),
                      ),
                    ),
                    ElevatedButton(
                      onPressed: null,
                      child: Text(
                        'Entrar'.toUpperCase(),
                      ),
                    ),
                    TextButton.icon(
                      onPressed: () {},
                      icon: const Icon(Icons.person),
                      label: const Text('Criar conta'),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
