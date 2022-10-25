import 'dart:convert';

import 'package:http/http.dart';

import '../../http/http.dart';

class HttpAdapter {
  final Client _client;

  HttpAdapter(this._client);

  request({
    required String url,
    required String method,
    Map<String, dynamic>? body,
  }) async {
    try {
      final requestBody = body != null ? jsonEncode(body) : null;

      var response = Response('', 500);

      if (method == 'post') {
        response = await _client.post(
          Uri.parse(url),
          headers: _headers,
          body: requestBody,
        );
      }

      return _handleResponse(response);
    } catch (e) {
      throw HttpError.serverError;
    }
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
