import 'dart:developer';
import 'package:flutter/material.dart';

abstract class BaseProvider extends ChangeNotifier {
  BuildContext? context;
  bool isLoading = true;
  String message = "";

  void setLog(String data) {
    log(data);
  }

  void setLoading([bool loading = false]) {
    if (loading) setMessage("");
    isLoading = loading;
    notifyListeners();
  }

  void setMessage(String message) => this.message = message;

}
