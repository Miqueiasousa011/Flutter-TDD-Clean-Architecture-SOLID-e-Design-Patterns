import 'package:faker/faker.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:fordev/data/cache/save_secure_cache_storeage.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:test/test.dart';

import 'local_storage_adapter_test.mocks.dart';

class LocalStorageAdapter implements SaveSegureCacheStorage {
  final FlutterSecureStorage secureStorage;

  LocalStorageAdapter({
    required this.secureStorage,
  });

  @override
  Future<void> save({required String key, required String value}) async {
    await secureStorage.write(key: key, value: value);
  }
}

@GenerateMocks([FlutterSecureStorage])
void main() {
  late LocalStorageAdapter sut;
  late MockFlutterSecureStorage secureStorage;
  late String key;
  late String value;

  setUp(() {
    key = faker.lorem.word();
    value = faker.guid.guid();

    secureStorage = MockFlutterSecureStorage();
    sut = LocalStorageAdapter(secureStorage: secureStorage);
  });

  test('Should call save secure with correct values', () async {
    await sut.save(key: key, value: value);

    verify(secureStorage.write(key: key, value: value));
  });

  test('Should throw if save secure throws', () {
    when(secureStorage.write(key: key, value: value)).thenThrow(Exception());

    final future = sut.save(key: key, value: value);

    ///Significa que o adapter vai lançar uma exception qualquer
    ///Não vamos trata-la no adapter. assim não é necessário usar o bloco
    ///try catch
    expect(future, throwsA(const TypeMatcher<Exception>()));
  });
}
