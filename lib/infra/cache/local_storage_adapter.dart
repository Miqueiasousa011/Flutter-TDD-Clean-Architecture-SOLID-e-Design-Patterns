import 'package:localstorage/localstorage.dart';

import '../../data/cache/cache.dart';

class LocalStorageAdapter implements CacheStorage {
  final LocalStorage _localStorage;

  LocalStorageAdapter({required LocalStorage localStorage})
      : _localStorage = localStorage;

  @override
  Future<void> save({required String key, required dynamic value}) async {
    await _localStorage.deleteItem(key);
    await _localStorage.setItem(key, value);
  }

  @override
  Future<void> delete(String key) async {
    await _localStorage.deleteItem(key);
  }

  @override
  Future<dynamic> fetch(String key) async {
    return await _localStorage.getItem(key);
  }
}
