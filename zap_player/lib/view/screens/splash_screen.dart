import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../controller/provider/provider_splashscreen.dart';

class SplashScreen extends StatelessWidget {
  const SplashScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    Provider.of<ProviderSplashScreen>(
      context,
      listen: false,
    ).gotoHome(context);
    return Scaffold(
      body: Center(
        child: Image.asset(
          'assets/images/zap_player_logo.png',
          height: height * 0.25,
        ),
      ),
    );
  }
}
