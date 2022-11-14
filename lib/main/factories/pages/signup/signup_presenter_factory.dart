import 'package:fordev/main/factories/usecases/save_current_account_factory.dart';
import 'package:fordev/presentation/presenters/presenters.dart';

import '../../../../ui/pages/signup/signup.dart';
import '../../usecases/add_accounty_factory.dart';
import 'signup_validation_factory.dart';

SignUpPresenter getxSignUpPresenter() {
  return GetxSignUpPresenter(
    validation: makeSignUpValidation(),
    addAccountUsecase: makeRemoteAddAccountUsecase(),
    saveCurrentAccount: makeSaveCurrentAccount(),
  );
}
