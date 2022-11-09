import 'package:flutter_secure_storage/flutter_secure_storage.dart';

import '../../data/cache/save_secure_cache_storeage.dart';

class LocalStorageAdapter implements SaveSegureCacheStorage {
  final FlutterSecureStorage secureStorage;

  LocalStorageAdapter({
    required this.secureStorage,
  });

  @override
  Future<void> saveSecure({required String key, required String value}) async {
    await secureStorage.write(key: key, value: value);
  }

  Future<void> fetchSecure({required String key}) async {
    await secureStorage.read(key: key);
  }
}
