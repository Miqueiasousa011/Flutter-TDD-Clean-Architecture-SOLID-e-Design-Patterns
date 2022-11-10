import '../entities/entities.dart';

abstract class LoadCurrentAccountUsecase {
  Future<AccountEntity?> load();
}
