import '../../domain/usecases/usecases.dart';

import '../http/http.dart';

class RemoteAuthenticationUsecase {
  final String _url;
  final HttpClient _httpClient;

  RemoteAuthenticationUsecase({
    required String url,
    required HttpClient httpClient,
  })  : _url = url,
        _httpClient = httpClient;

  Future auth(AuthenticationParams params) async {
    final body = RemoteAuthenticationParams.fromDomain(params).toMap();
    return await _httpClient.request(
      url: _url,
      method: 'post',
      body: body,
    );
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
