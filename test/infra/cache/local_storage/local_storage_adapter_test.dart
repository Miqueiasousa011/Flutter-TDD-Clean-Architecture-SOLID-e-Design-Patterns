import 'package:faker/faker.dart';
import 'package:localstorage/localstorage.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:test/test.dart';

import 'local_storage_adapter_test.mocks.dart';

class LocalStorageAdapter {
  final LocalStorage _localStorage;

  LocalStorageAdapter({required LocalStorage localStorage})
      : _localStorage = localStorage;

  Future<void> save({required String key, required dynamic value}) async {
    await _localStorage.deleteItem(key);
    await _localStorage.setItem(key, value);
  }
}

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
  });
}
