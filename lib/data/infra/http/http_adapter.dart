import 'dart:convert';

import 'package:fordev/data/http/http_error.dart';
import 'package:http/http.dart';

class HttpAdapter {
  final Client _client;

  HttpAdapter(this._client);

  request({
    required String url,
    required String method,
    Map<String, dynamic>? body,
  }) async {
    final requestBody = body != null ? jsonEncode(body) : null;
    final response = await _client.post(
      Uri.parse(url),
      headers: _headers,
      body: requestBody,
    );

    return _handleResponse(response);
  }

  Map<String, dynamic>? _handleResponse(Response response) {
    switch (response.statusCode) {
      case 200:
        return response.body.isNotEmpty ? jsonDecode(response.body) : null;
      case 204:
        return null;
      default:
        throw HttpError.badRequest;
    }
  }

  Map<String, String> get _headers => {
        'content-type': 'application/json',
        'accept': 'application/json',
      };
}
