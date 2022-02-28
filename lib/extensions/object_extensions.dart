import 'package:flutter/material.dart';

extension ObjectExtension on Object {
  // These are probably not valuable and probably make code slower.
  bool get isNotNull => this != null;
  bool get isNull => this == null;
}
