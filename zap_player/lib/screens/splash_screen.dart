import 'package:flutter/material.dart';
import 'package:zap_player/screens/bottomnav_screen.dart';


class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    _gotohome();
    super.initState();
  }

  _gotohome() async {
    await Future.delayed(const Duration(seconds: 3));
    if (mounted) {
      Navigator.of(context).pushReplacement(MaterialPageRoute(builder: ((context) {
        return const BottomNav();
      })));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Image.asset(
        'assets/images/splash_screen_logo.png',
        height: MediaQuery.of(context).size.height * 0.25,
      ),
    );
  }
}
