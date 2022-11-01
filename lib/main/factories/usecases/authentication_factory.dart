import 'package:fordev/main/factories/http/http.dart';

import '../../../data/usecases/usecases.dart';

RemoteAuthenticationUsecase makeRemoteAuthenticationUsecase() {
  return RemoteAuthenticationUsecase(
    url: makeApiUrl('login'),
    httpClient: makeHttpAdapter(),
  );
}
