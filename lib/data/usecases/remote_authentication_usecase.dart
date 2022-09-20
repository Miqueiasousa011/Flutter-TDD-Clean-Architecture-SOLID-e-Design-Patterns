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
    return await _httpClient.request(
      url: _url,
      method: 'post',
      body: {
        'email': params.email,
        'password': params.password,
      },
    );
  }
}
