import 'package:flutter/material.dart';

class WidgetIcon extends StatelessWidget {
  final IconData icon;
  const WidgetIcon({
    super.key,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    return Icon(
      icon,
      color: Colors.white,
      size: width * 0.09,
    );
  }
}
