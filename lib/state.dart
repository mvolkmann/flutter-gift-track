import 'package:flutter/material.dart';

class AppState extends ChangeNotifier {
  var _adding = false;

  bool get adding => _adding;

  set adding(bool a) {
    _adding = a;
    notifyListeners();
  }
}
