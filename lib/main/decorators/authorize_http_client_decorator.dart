import '../../data/cache/cache.dart';
import '../../data/http/http.dart';

class AuthorizeHttpClientDecorator implements HttpClient {
  final FetchSecureCacheStorage _fetchSecureCacheStorage;
  final DeleteSecureCacheStorage _deleteSecureCacheStorage;
  final HttpClient _decoratee;

  AuthorizeHttpClientDecorator({
    required FetchSecureCacheStorage fetchSecureCacheStorage,
    required DeleteSecureCacheStorage deleteSecureCacheStorage,
    required HttpClient decoratee,
  })  : _fetchSecureCacheStorage = fetchSecureCacheStorage,
        _deleteSecureCacheStorage = deleteSecureCacheStorage,
        _decoratee = decoratee;

  @override
  Future<dynamic> request({
    required String url,
    required String method,
    Map<String, dynamic>? body,
    Map<String, dynamic>? headers,
  }) async {
    try {
      final token = await _fetchSecureCacheStorage.fetchSecure('token') ?? '';

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
    } on HttpError catch (error) {
      if (error == HttpError.forbiddenError) {
        await _deleteSecureCacheStorage.delete('token');
      }
      rethrow;
    } catch (e) {
      await _deleteSecureCacheStorage.delete('token');
      throw HttpError.forbiddenError;
    }
  }
}
