enum DomainError {
  unexpected('Algo de errado aconteceu. Tente novamente'),
  invalidCredentialsError('Credenciais inválidas.');

  const DomainError(this.description);

  final String description;
}
