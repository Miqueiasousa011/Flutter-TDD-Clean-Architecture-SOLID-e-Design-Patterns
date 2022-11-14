import 'package:fordev/data/usecases/usecases.dart';
import 'package:fordev/domain/usecases/add_account_usecase.dart';
import 'package:fordev/main/factories/http/api_url_factory.dart';

import '../http/http_factory.dart';

AddAccountUsecase makeRemoteAddAccountUsecase() {
  return RemoteAddAccount(
    httpClient: makeHttpAdapter(),
    url: makeApiUrl('signup'),
  );
}
