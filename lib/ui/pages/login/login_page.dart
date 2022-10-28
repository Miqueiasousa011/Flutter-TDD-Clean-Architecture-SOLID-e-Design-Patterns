import 'package:flutter/material.dart';
import 'package:fordev/ui/pages/pages.dart';
import 'package:provider/provider.dart';

import '../../components/components.dart';
import 'components/components.dart';

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
      body: Builder(
        builder: (context) {
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
                  child: Provider(
                    create: (context) => widget.loginPresenter,
                    child: Form(
                      child: Column(
                        children: [
                          const EmailInput(),
                          const Padding(
                            padding: EdgeInsets.symmetric(vertical: 16),
                            child: PasswordInput(),
                          ),
                          const LoginButton(),
                          TextButton.icon(
                            onPressed: () {},
                            icon: const Icon(Icons.person),
                            label: const Text('Criar conta'),
                          )
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
