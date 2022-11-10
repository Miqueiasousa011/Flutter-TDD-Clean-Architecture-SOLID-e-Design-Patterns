import 'package:fordev/presentation/presenters/presenters.dart';

import '../../../../ui/pages/splash/splash.dart';
import '../../usecases/local_load_current_account.dart';

SplashPresenter makeGexSplashPresenter() {
  return GetxSplashPresenter(loadCurrentAccount: makeLocalCurrentAccout());
}
