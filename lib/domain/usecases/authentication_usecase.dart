import 'package:equatable/equatable.dart';

import '../entities/entities.dart';

abstract class AuthenticationUsecase {
  Future<AccountEntity> auth(AuthenticationParams params);
}

class AuthenticationParams extends Equatable {
  final String email;
  final String password;

  const AuthenticationParams({required this.email, required this.password});

  @override
  List<Object> get props => [email, password];
}
