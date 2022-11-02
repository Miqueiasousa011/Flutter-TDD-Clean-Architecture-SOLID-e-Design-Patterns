import '../entities/entities.dart';

abstract class SaveCurrentAccountUsecase {
  Future<void> save(AccountEntity account);
}
