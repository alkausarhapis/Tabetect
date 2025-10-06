import 'package:flutter/material.dart';

enum AppColor {
  darkBlue("Dark Blue", Color(0xFF3B3962)),
  primaryRed("Primary Red", Color(0xFFEA3447)),
  brokenWhite("Broken White", Color(0xFFF3EAEE));

  const AppColor(this.name, this.color);
  final String name;
  final Color color;
}
