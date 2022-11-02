import '../../../domain/entities/entities.dart';
import '../../../domain/helpers/helpers.dart';
import '../../../domain/usecases/usecases.dart';
import '../../cache/cache.dart';

class LocalSaveCorrentAccount implements SaveCurrentAccountUsecase {
  final SaveSegureCacheStorage _saveSecureCacheStorage;

  LocalSaveCorrentAccount({
    required SaveSegureCacheStorage saveSecureCacheStorage,
  }) : _saveSecureCacheStorage = saveSecureCacheStorage;

  @override
  Future<void> save(AccountEntity account) async {
    try {
      await _saveSecureCacheStorage.save(key: 'token', value: account.token);
    } catch (e) {
      throw DomainError.unexpected;
    }
  }
}
