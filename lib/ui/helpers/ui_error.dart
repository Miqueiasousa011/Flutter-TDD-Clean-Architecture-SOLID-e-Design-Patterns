enum UIError {
  unexpected('Algo de errado aconteceu. Tente novamente'),
  invalidCredentialsError('Credenciais inválidas.'),
  requiredField('Campo obrigatório'),
  invalidField('Campo inválido');

  const UIError(this.description);

  final String description;
}
