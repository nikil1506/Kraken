import 'package:flutter/material.dart';

class Dimens {
  Dimens._privateConstructor();

  static const EdgeInsets horizontalPadding =
      EdgeInsets.symmetric(horizontal: 15);

  static const EdgeInsets iconPadding =
      EdgeInsets.symmetric(horizontal: 15, vertical: 15);
}

enum Gap { xxs, xs, s, m, l }

class GapBox extends StatelessWidget {
  final Gap gap;

  const GapBox({super.key, required this.gap});

  @override
  Widget build(BuildContext context) {
    switch (gap) {
      case Gap.xxs:
        return const SizedBox(
          height: 10,
          width: 10,
        );
      case Gap.xs:
        return const SizedBox(
          height: 20,
          width: 20,
        );
      case Gap.s:
        return const SizedBox(
          height: 30,
          width: 30,
        );
      case Gap.m:
        return const SizedBox(
          height: 50,
          width: 50,
        );
      case Gap.l:
        return const SizedBox(
          height: 60,
          width: 60,
        );
    }
  }
}
