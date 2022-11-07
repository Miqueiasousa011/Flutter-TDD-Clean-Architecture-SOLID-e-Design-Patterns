import '../../../data/usecases/usecases.dart';
import '../../../domain/usecases/usecases.dart';
import '../cache/cache.dart';

SaveCurrentAccountUsecase makeSaveCurrentAccount() {
  return LocalSaveCorrentAccount(
    saveSecureCacheStorage: makeLocalStorageAdapter(),
  );
}
