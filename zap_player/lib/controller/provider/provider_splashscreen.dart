import 'package:flutter/material.dart';

import '../../view/screens/bottomnav_screen.dart';

class ProviderSplashScreen with ChangeNotifier {
  Future<void> gotoHome(
    BuildContext context, [
    bool mounted = true,
  ]) async {
    await Future.delayed(
      const Duration(
        seconds: 3,
      ),
    );
    if (mounted) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) {
            return BottomNav();
          },
        ),
      );
    }
  }
}
