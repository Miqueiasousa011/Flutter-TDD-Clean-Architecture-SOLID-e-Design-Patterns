enum DomainError {
  unexpected('Algo de errado aconteceu. Tente novamente'),
  invalidCredentialsError('Credenciais inválidas.'),
  emailInUse('Email já está sendo usado');

  const DomainError(this.description);

  final String description;
}
