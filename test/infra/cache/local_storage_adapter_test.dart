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

  setUp(() {
    secureStorage = MockFlutterSecureStorage();
    sut = LocalStorageAdapter(secureStorage: secureStorage);
  });

  test('Should call save secure with correct values', () async {
    const key = 'token';
    final value = faker.guid.guid();

    await sut.save(key: key, value: value);

    verify(secureStorage.write(key: key, value: value));
  });
}
