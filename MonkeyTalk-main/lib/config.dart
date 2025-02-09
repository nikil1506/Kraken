import 'package:flutter/material.dart';
export 'package:flutter/material.dart';
export 'package:flutter/foundation.dart';
export 'utils/extensions.dart';
export 'utils/dimensions.dart';

extension BuildContextExtension on BuildContext {
  ColorScheme get colorScheme => Theme.of(this).colorScheme;

  TextTheme get textTheme => Theme.of(this).textTheme;

  void pop([dynamic result]) => Navigator.of(this).pop(result);

  Future push(Widget widget) {
    return Navigator.of(this).push(MaterialPageRoute(builder: (_) => widget));
  }

  Future pushReplacement(Widget widget) {
    return Navigator.of(this)
        .pushReplacement(MaterialPageRoute(builder: (_) => widget));
  }
}
