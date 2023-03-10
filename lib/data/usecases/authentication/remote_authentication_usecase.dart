import '../../../domain/helpers/helpers.dart';
import '../../../domain/usecases/usecases.dart';
import '../../../domain/entities/entities.dart';

import '../../http/http.dart';
import '../../models/models.dart';

class RemoteAuthenticationUsecase implements AuthenticationUsecase {
  final String _url;
  final HttpClient _httpClient;

  RemoteAuthenticationUsecase({
    required String url,
    required HttpClient httpClient,
  })  : _url = url,
        _httpClient = httpClient;

  @override
  Future<AccountEntity> auth(AuthenticationParams params) async {
    final body = RemoteAuthenticationParams.fromDomain(params).toMap();

    try {
      final result = await _httpClient.request(
        url: _url,
        method: 'post',
        body: body,
      );

      return RemoteAccountModel.fromJson(result!).toEntity;
    } on HttpError catch (e) {
      throw handleError(e);
    }
  }

  DomainError handleError(HttpError error) {
    switch (error) {
      case HttpError.unauthorized:
        return DomainError.invalidCredentialsError;
      case HttpError.badRequest:
      case HttpError.notFound:
      case HttpError.serverError:
      default:
        return DomainError.unexpected;
    }
  }
}

class RemoteAuthenticationParams {
  final String email;
  final String password;

  RemoteAuthenticationParams({
    required this.email,
    required this.password,
  });

  factory RemoteAuthenticationParams.fromDomain(AuthenticationParams params) =>
      RemoteAuthenticationParams(
        email: params.email,
        password: params.password,
      );

  Map<String, dynamic> toMap() => {'email': email, 'password': password};
}
