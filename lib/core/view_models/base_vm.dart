import 'package:flutter/material.dart';
import 'package:logger/logger.dart';

class BaseModel extends ChangeNotifier {
  bool _busy = false;

  bool get busy => _busy;

  void setBusy(bool value) {
    _busy = value;
    notifyListeners();
  }

  log(dynamic data) {
    Logger l = Logger();
    l.d(data);
  }
}
