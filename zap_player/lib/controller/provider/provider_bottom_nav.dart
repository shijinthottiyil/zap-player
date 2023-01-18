import 'package:flutter/material.dart';

class ProviderBottomNav with ChangeNotifier {
  int selectIndex = 0;
  void onTapFn(int value) {
    selectIndex = value;
    notifyListeners();
  }
}
