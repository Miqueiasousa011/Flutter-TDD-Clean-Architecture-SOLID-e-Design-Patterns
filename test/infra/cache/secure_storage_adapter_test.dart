import 'package:faker/faker.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:test/test.dart';

import 'package:flutter_secure_storage/flutter_secure_storage.dart';

import 'package:fordev/infra/cache/cache.dart';

import 'secure_storage_adapter_test.mocks.dart';

@GenerateMocks([FlutterSecureStorage])
void main() {
  late SecureStorageAdapter sut;
  late MockFlutterSecureStorage secureStorage;
  late String key;
  late String value;

  setUp(() {
    key = faker.lorem.word();
    value = faker.guid.guid();

    secureStorage = MockFlutterSecureStorage();
    sut = SecureStorageAdapter(secureStorage: secureStorage);
  });

  group('saveSecure', () {
    test('Should call save secure with correct values', () async {
      await sut.saveSecure(key: key, value: value);

      verify(secureStorage.write(key: key, value: value));
    });

    test('Should throw if save secure throws', () {
      when(secureStorage.write(key: key, value: value)).thenThrow(Exception());

      final future = sut.saveSecure(key: key, value: value);

      ///Significa que o adapter vai lançar uma exception qualquer
      ///Não vamos trata-la no adapter. assim não é necessário usar o bloco
      ///try catch
      expect(future, throwsA(const TypeMatcher<Exception>()));
    });
  });

  group('fetchSecure', () {
    test('Should call fetch secure with correct values', () async {
      when(secureStorage.read(key: key)).thenAnswer((_) async => 'any');

      await sut.fetchSecure(key);

      verify(secureStorage.read(key: key));
    });

    test('Should return correct value on sucess', () async {
      when(secureStorage.read(key: key)).thenAnswer((_) async => value);

      final result = await sut.fetchSecure(key);

      expect(result, equals(value));
    });

    test('Should throw if fetch secure throws', () async {
      when(secureStorage.read(key: key)).thenThrow(Exception());

      final result = sut.fetchSecure(key);

      expect(result, throwsA(const TypeMatcher<Exception>()));
    });
  });

  group('deleteSecure', () {
    test('Should call delete secure with correct key', () async {
      await sut.delete('any_key');

      verify(secureStorage.delete(key: 'any_key'));
    });

    test('Should throw if delete secure throws', () {
      when(secureStorage.delete(key: anyNamed('key'))).thenThrow(Exception());

      final future = sut.delete('key');

      expect(future, throwsA(const TypeMatcher<Exception>()));
    });
  });
}
