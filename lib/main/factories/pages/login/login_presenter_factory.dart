import 'package:fordev/main/factories/pages/login/login_validation_factory.dart';

import '../../../../presentation/presenters/presenters.dart';
import '../../usecases/usecases.dart';

StreamLoginPresenter loginPresenterFactory() {
  return StreamLoginPresenter(
    validation: makeLoginValidationFactory(),
    authenticationUsecase: makeRemoteAuthenticationUsecase(),
  );
}
