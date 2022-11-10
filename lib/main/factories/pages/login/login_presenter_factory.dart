import '../../../../presentation/presenters/presenters.dart';
import '../../../../ui/pages/pages.dart';
import '../../usecases/save_current_account_factory.dart';
import '../../usecases/usecases.dart';
import '../pages.dart';

// LoginPresenter streamLoginPresenterFactory() {
//   return StreamLoginPresenter(
//     validation: makeLoginValidationFactory(),
//     authenticationUsecase: makeRemoteAuthenticationUsecase(),
//   );
// }

LoginPresenter getXLoginPresenterFactory() {
  return GetXLoginPresenter(
    validation: makeLoginValidationFactory(),
    authenticationUsecase: makeRemoteAuthenticationUsecase(),
    saveCurrentAccount: makeSaveCurrentAccount(),
  );
}
