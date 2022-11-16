import 'dart:convert';

import 'package:faker/faker.dart';
import 'package:fordev/data/http/http_error.dart';
import 'package:fordev/infra/http/http.dart';
import 'package:http/http.dart';
import 'package:mockito/mockito.dart';
import 'package:test/test.dart';
import 'package:mockito/annotations.dart';

import 'http_adapter_test.mocks.dart';

@GenerateMocks([Client])
void main() {
  late HttpAdapter sut;
  late MockClient httpClient;
  late String url;
  late Uri uri;
  late Map<String, String> headers;
  late Map<String, dynamic> body;

  setUp(() {
    headers = {
      'content-type': 'application/json',
      'accept': 'application/json',
    };

    body = {'any': 'any'};

    url = faker.internet.httpUrl();
    uri = Uri.parse(url);
    httpClient = MockClient();
    sut = HttpAdapter(httpClient);
  });

  group('shared', () {
    test('should throw ServerError if invalid method is provided', () async {
      final future = sut.request(url: url, method: 'invalid');

      expect(future, throwsA(HttpError.serverError));
    });
  });

  group('post', () {
    test('Should call post with correct values', () async {
      when(httpClient.post(any, headers: anyNamed('headers')))
          .thenAnswer((_) async => Response('{}', 200));

      await sut.request(url: url, method: 'post');

      verify(httpClient.post(uri, headers: headers));
    });

    test('Should call post with correct body', () async {
      when(httpClient.post(any,
              headers: anyNamed('headers'), body: anyNamed('body')))
          .thenAnswer((_) async => Response('{}', 200));

      await sut.request(url: url, method: 'post', body: body);

      verify(httpClient.post(uri, headers: headers, body: jsonEncode(body)));
    });

    test('Should call post without body', () async {
      when(httpClient.post(any, headers: anyNamed('headers')))
          .thenAnswer((_) async => Response('{}', 200));

      await sut.request(url: url, method: 'post');

      verify(httpClient.post(uri, headers: headers));
    });

    test('should return data if post returns 200', () async {
      when(httpClient.post(any, headers: anyNamed('headers')))
          .thenAnswer((_) async => Response(jsonEncode({'any': 'any'}), 200));

      final result = await sut.request(url: url, method: 'post');

      expect(result, {'any': 'any'});
    });

    test('Should return null if post returns 200 without data', () async {
      when(httpClient.post(any, headers: anyNamed('headers')))
          .thenAnswer((_) async => Response('', 200));

      final result = await sut.request(url: url, method: 'post');

      expect(result, isNull);
    });
    test('should return null if post returns 204', () async {
      when(httpClient.post(any, headers: anyNamed('headers')))
          .thenAnswer((_) async => Response('', 204));

      final result = await sut.request(url: url, method: 'post');

      expect(result, isNull);
    });

    test('should return null id post returns 204 with data', () async {
      when(httpClient.post(any, headers: anyNamed('headers')))
          .thenAnswer((_) async => Response('{any: "any"}', 204));

      final result = await sut.request(url: url, method: 'post');

      expect(result, isNull);
    });

    test('should return BadRequestError if post returns 400', () async {
      when(httpClient.post(any, headers: anyNamed('headers')))
          .thenAnswer((_) async => Response('any', 400));

      final future = sut.request(url: url, method: 'post');

      expect(future, throwsA(HttpError.badRequest));
    });

    test('should throw BadRequestError if post returns 400 with data',
        () async {
      when(httpClient.post(any, headers: anyNamed('headers')))
          .thenAnswer((_) async => Response('', 400));

      final future = sut.request(url: url, method: 'post');

      expect(future, throwsA(HttpError.badRequest));
    });

    test('should throw ServerError if httpAdapter retuns 500', () {
      when(httpClient.post(any, headers: anyNamed('headers')))
          .thenAnswer((_) async => Response('', 500));

      final future = sut.request(url: url, method: 'post');

      expect(future, throwsA(HttpError.serverError));
    });

    test('should throw unauthorized if httpAdapter returns 401', () {
      when(httpClient.post(any, headers: anyNamed('headers')))
          .thenAnswer((_) async => Response('any', 401));

      final future = sut.request(url: url, method: 'post');

      expect(future, throwsA(HttpError.unauthorized));
    });

    test('should throw ForbiddenError if httpAdapter returns 403', () {
      when(httpClient.post(any, headers: anyNamed('headers')))
          .thenAnswer((_) async => Response('', 403));

      final future = sut.request(url: url, method: 'post');
      expect(future, throwsA(HttpError.forbiddenError));
    });

    test('should throw notFoundError if httpAdapter returns 404', () {
      when(httpClient.post(any, headers: anyNamed('headers')))
          .thenAnswer((_) async => Response('', 404));

      final future = sut.request(url: url, method: 'post');

      expect(future, throwsA(HttpError.notFound));
    });

    test('should throw ServerError if post returns 500', () async {
      when(httpClient.post(any, headers: anyNamed('headers')))
          .thenThrow(Exception());

      final future = sut.request(url: url, method: 'post');

      expect(future, throwsA(HttpError.serverError));
    });
  });

  group('get', () {
    test('Should call post with correct values', () async {
      when(httpClient.get(any, headers: anyNamed('headers')))
          .thenAnswer((_) async => Response('{}', 200));

      await sut.request(url: url, method: 'get');

      verify(httpClient.get(uri, headers: headers));
    });

    test('Should return data if get returns 200', () async {
      when(httpClient.get(any, headers: anyNamed('headers')))
          .thenAnswer((_) async => Response(jsonEncode({'any': 'any'}), 200));

      final result = await sut.request(url: url, method: 'get');

      expect(result, equals({'any': 'any'}));
    });

    test('Should return null if get returns 200 with no data', () async {
      when(httpClient.get(any, headers: anyNamed('headers')))
          .thenAnswer((_) async => Response('', 200));

      final result = await sut.request(url: url, method: 'get');

      expect(result, isNull);
    });

    test('Should return null if get returns 204 with no data', () async {
      when(httpClient.get(any, headers: anyNamed('headers')))
          .thenAnswer((_) async => Response('', 204));

      final result = await sut.request(url: url, method: 'get');

      expect(result, isNull);
    });

    test('Should return null if get returns 204 with  data', () async {
      when(httpClient.get(any, headers: anyNamed('headers')))
          .thenAnswer((_) async => Response('{"any": "any"}', 204));

      final result = await sut.request(url: url, method: 'get');

      expect(result, isNull);
    });

    test('Should return BadRequest if get returns 400 with data', () async {
      when(httpClient.get(any, headers: anyNamed('headers')))
          .thenAnswer((_) async => Response('{"any": "any"}', 400));

      final result = sut.request(url: url, method: 'get');

      expect(result, throwsA(HttpError.badRequest));
    });

    test('Should return BadRequest if get returns 400 with no data', () async {
      when(httpClient.get(any, headers: anyNamed('headers')))
          .thenAnswer((_) async => Response('', 400));

      final result = sut.request(url: url, method: 'get');

      expect(result, throwsA(HttpError.badRequest));
    });

    test('Should return Unauthorized if get returns 401', () async {
      when(httpClient.get(any, headers: anyNamed('headers')))
          .thenAnswer((_) async => Response('', 401));

      final result = sut.request(url: url, method: 'get');

      expect(result, throwsA(HttpError.unauthorized));
    });

    test('Should return Forbidden if get returns 403', () async {
      when(httpClient.get(any, headers: anyNamed('headers')))
          .thenAnswer((_) async => Response('', 403));

      final result = sut.request(url: url, method: 'get');

      expect(result, throwsA(HttpError.forbiddenError));
    });

    test('Should return NotFound if get returns 404', () async {
      when(httpClient.get(any, headers: anyNamed('headers')))
          .thenAnswer((_) async => Response('', 404));

      final result = sut.request(url: url, method: 'get');

      expect(result, throwsA(HttpError.notFound));
    });

    test('Should return ServerError if get returns 500', () async {
      when(httpClient.get(any, headers: anyNamed('headers')))
          .thenAnswer((_) async => Response('', 500));

      final result = sut.request(url: url, method: 'get');

      expect(result, throwsA(HttpError.serverError));
    });
  });
}
