import 'package:flutter/material.dart';
import 'package:fordev/ui/pages/pages.dart';

import '../../components/components.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key, this.loginPresenter});

  final LoginPresenter? loginPresenter;

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  @override
  void dispose() {
    super.dispose();

    widget.loginPresenter!.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Builder(builder: (context) {
        widget.loginPresenter!.isLoadingController.listen((isLoading) {
          if (isLoading) {
            showLoading(context);
          } else {
            hidenLoading(context);
          }
        });

        widget.loginPresenter!.mainErrorController.listen((error) {
          if (error != null) {
            showErrorMessage(context, error);
          }
        });

        return SingleChildScrollView(
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
                        stream: widget.loginPresenter!.emailErrorStream,
                        builder: (context, snapshot) {
                          return TextFormField(
                            keyboardType: TextInputType.emailAddress,
                            decoration: InputDecoration(
                              errorText: snapshot.data,
                              hintText: 'Email',
                            ),
                            onChanged: (value) =>
                                widget.loginPresenter!.validateEmail(value),
                          );
                        },
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        child: StreamBuilder<String?>(
                            stream: widget.loginPresenter!.passwordErrorStream,
                            builder: (context, snapshot) {
                              return TextFormField(
                                obscureText: true,
                                decoration: InputDecoration(
                                  hintText: 'Senha',
                                  errorText: snapshot.data,
                                ),
                                onChanged: (value) => widget.loginPresenter!
                                    .validatePassword(value),
                              );
                            }),
                      ),
                      StreamBuilder<bool>(
                        stream: widget.loginPresenter!.isFormValidController,
                        builder: (context, snapshot) {
                          return ElevatedButton(
                            onPressed: snapshot.data == true
                                ? () {
                                    widget.loginPresenter!.auth();
                                  }
                                : null,
                            child: Text(
                              'Entrar'.toUpperCase(),
                            ),
                          );
                        },
                      ),
                      TextButton.icon(
                        onPressed: () {},
                        icon: const Icon(Icons.person),
                        label: const Text('Criar conta'),
                      )
                    ],
                  ),
                ),
              ),
            ],
          ),
        );
      }),
    );
  }
}
