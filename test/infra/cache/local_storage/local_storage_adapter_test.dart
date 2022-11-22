import 'package:faker/faker.dart';
import 'package:localstorage/localstorage.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:test/test.dart';

import 'package:fordev/infra/cache/cache.dart';

import 'local_storage_adapter_test.mocks.dart';

@GenerateMocks([LocalStorage])
void main() {
  late LocalStorageAdapter sut;
  late MockLocalStorage localStorage;

  late String value;
  late String key;

  setUp(() {
    value = faker.randomGenerator.string(10);
    key = faker.randomGenerator.string(10);

    localStorage = MockLocalStorage();
    sut = LocalStorageAdapter(localStorage: localStorage);
  });

  group('save', () {
    test('Should call LocalStorage package with correct values', () async {
      await sut.save(key: key, value: value);

      verify(localStorage.deleteItem(key)).called(1);

      verify(localStorage.setItem(key, value)).called(1);
    });

    test('Should throw if deleteItem throws', () async {
      when(localStorage.deleteItem(any)).thenThrow(Exception());

      final future = sut.save(key: key, value: value);

      expect(future, throwsA(const TypeMatcher<Exception>()));
    });

    test('Should throw if setItem throws', () async {
      when(localStorage.setItem(any, any)).thenThrow(Exception());

      final future = sut.save(key: key, value: value);

      expect(future, throwsA(const TypeMatcher<Exception>()));
    });
  });

  group('delete', () {
    test('Should call LocalStorage package with correct values', () async {
      await sut.delete(key);

      verify(localStorage.deleteItem(key)).called(1);
    });

    test('Should throw if delete throws', () async {
      when(localStorage.deleteItem(any)).thenThrow(Exception());

      final future = sut.delete(key);

      expect(future, throwsA(const TypeMatcher<Exception>()));
    });
  });

  group('fetch', () {
    test('Shoul call LocalStorage with correct value', () async {
      when(localStorage.getItem(any)).thenAnswer((_) async => 'any');

      await sut.fetch(key);

      verify(localStorage.getItem(key));
    });

    test('Shoul return same value as localStorage', () async {
      final fetchResult = faker.randomGenerator.string(10);

      when(localStorage.getItem(any)).thenAnswer((_) async => fetchResult);

      final result = await sut.fetch(key);

      expect(result, equals(fetchResult));
    });

    test('Shoul throw if getItem throws', () async {
      when(localStorage.getItem(any)).thenThrow(Exception());

      final future = sut.fetch(key);

      expect(future, throwsA(const TypeMatcher<Exception>()));
    });
  });
}
