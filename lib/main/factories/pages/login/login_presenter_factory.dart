import 'package:fordev/main/factories/pages/login/login_validation_factory.dart';

import '../../../../presentation/presenters/presenters.dart';
import '../../../../ui/pages/pages.dart';
import '../../usecases/usecases.dart';

LoginPresenter streamLoginPresenterFactory() {
  return StreamLoginPresenter(
    validation: makeLoginValidationFactory(),
    authenticationUsecase: makeRemoteAuthenticationUsecase(),
  );
}

LoginPresenter getXLoginPresenterFactory() {
  return GetXLoginPresenter(
    validation: makeLoginValidationFactory(),
    authenticationUsecase: makeRemoteAuthenticationUsecase(),
  );
}
