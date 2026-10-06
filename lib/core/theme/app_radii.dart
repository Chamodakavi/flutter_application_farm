import 'package:flutter/widgets.dart';

/// Corner radii (spec §10.3).
abstract final class AppRadii {
  static const double card = 20;
  static const double hero = 24;
  static const double input = 12;
  static const double button = 14;
  static const double sheet = 24;
  static const double pill = 999;

  static final cardBorder = BorderRadius.circular(card);
  static final heroBorder = BorderRadius.circular(hero);
  static final inputBorder = BorderRadius.circular(input);
  static final buttonBorder = BorderRadius.circular(button);
  static final pillBorder = BorderRadius.circular(pill);
  static const sheetBorder = BorderRadius.vertical(top: Radius.circular(sheet));
}
