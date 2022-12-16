import 'package:flutter/material.dart';
import 'package:fordev/ui/helpers/helpers.dart';

import '../components/components.dart';

mixin UIErrorManager {
  void handleError(BuildContext context, Stream<UIError?> stream) {
    stream.listen((error) {
      if (error != null) {
        showErrorMessage(context, error.description);
      }
    });
  }
}
