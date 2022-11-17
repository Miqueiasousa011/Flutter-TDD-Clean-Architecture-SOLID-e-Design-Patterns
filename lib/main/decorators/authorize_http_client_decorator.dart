import '../../data/cache/cache.dart';
import '../../data/http/http.dart';

class AuthorizeHttpClientDecorator implements HttpClient {
  final FetchSecureCacheStorage _secureCacheStorage;
  final HttpClient _decoratee;

  AuthorizeHttpClientDecorator({
    required FetchSecureCacheStorage secureCacheStorage,
    required HttpClient decoratee,
  })  : _secureCacheStorage = secureCacheStorage,
        _decoratee = decoratee;

  @override
  Future<dynamic> request({
    required String url,
    required String method,
    Map<String, dynamic>? body,
    Map<String, dynamic>? headers,
  }) async {
    try {
      final token = await _secureCacheStorage.fetchSecure('token') ?? '';

      final authorizedHeader = {
        'x-access-token': token,
        if (headers != null) ...headers
      };

      return await _decoratee.request(
        url: url,
        method: method,
        body: body,
        headers: authorizedHeader,
      );
    } on HttpError {
      rethrow;
    } catch (e) {
      throw HttpError.forbiddenError;
    }
  }
}
