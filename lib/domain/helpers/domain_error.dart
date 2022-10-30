enum DomainError {
  unexpected('Unexpected Error'),
  invalidCredentialsError('Invalid Credentials');

  const DomainError(this.description);

  final String description;
}
