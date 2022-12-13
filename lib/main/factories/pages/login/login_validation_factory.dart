import 'package:fordev/main/builders/builders.dart';

import '../../../../presentation/protocols/protocols.dart';
import '../../../../validation/protocols/protocols.dart';
import '../../../composites/composites.dart';

Validation makeLoginValidationFactory() {
  return ValidationComposite(makeLoginValidation());
}

List<FieldValidation> makeLoginValidation() {
  return [
    ...ValidationBuilder.field('email').email().required().build(),
    ...ValidationBuilder.field('password').required().min(3).build(),
  ];
}
