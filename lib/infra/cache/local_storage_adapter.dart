import 'package:localstorage/localstorage.dart';

class LocalStorageAdapter {
  final LocalStorage _localStorage;

  LocalStorageAdapter({required LocalStorage localStorage})
      : _localStorage = localStorage;

  Future<void> save({required String key, required dynamic value}) async {
    await _localStorage.deleteItem(key);
    await _localStorage.setItem(key, value);
  }

  Future<void> delete(String key) async {
    await _localStorage.deleteItem(key);
  }

  Future<void> fetch(String key) async {
    await _localStorage.getItem(key);
  }
}
