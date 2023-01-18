import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';

import '../../view/screens/search_screen.dart';

class ProviderHomeScreen with ChangeNotifier {
  void requestPermission() async {
    await Permission.storage.request();
    notifyListeners();
    FocusManager.instance.primaryFocus?.unfocus();
  }

  void gotoSearch(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) {
          return const SearchPage();
        },
      ),
    );
  }
}
