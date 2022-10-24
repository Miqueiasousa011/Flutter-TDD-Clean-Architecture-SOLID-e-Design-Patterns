import 'dart:convert';

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

    if (response.statusCode == 204) {
      return null;
    }

    return response.body.isNotEmpty ? jsonDecode(response.body) : null;
  }

  Map<String, String> get _headers => {
        'content-type': 'application/json',
        'accept': 'application/json',
      };
}
