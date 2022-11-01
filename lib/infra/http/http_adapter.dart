import 'dart:convert';

import 'package:http/http.dart';

import '../../data/http/http.dart';

class HttpAdapter implements HttpClient {
  final Client _client;

  HttpAdapter(this._client);

  @override
  request({
    required String url,
    required String method,
    Map<String, dynamic>? body,
  }) async {
    final requestBody = body != null ? jsonEncode(body) : null;

    var response = Response('', 500);

    try {
      if (method == 'post') {
        response = await _client.post(
          Uri.parse(url),
          headers: _headers,
          body: requestBody,
        );
      }
    } catch (e) {
      throw HttpError.serverError;
    }

    return _handleResponse(response);
  }

  Map<String, dynamic>? _handleResponse(Response response) {
    switch (response.statusCode) {
      case 200:
        return response.body.isNotEmpty ? jsonDecode(response.body) : null;
      case 204:
        return null;
      case 401:
        throw HttpError.unauthorized;
      case 403:
        throw HttpError.forbiddenError;
      case 404:
        throw HttpError.notFound;
      case 500:
        throw HttpError.serverError;
      default:
        throw HttpError.badRequest;
    }
  }

  Map<String, String> get _headers => {
        'content-type': 'application/json',
        'accept': 'application/json',
      };
}
