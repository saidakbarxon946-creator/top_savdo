import 'package:flutter/material.dart';

class ConnectivityWrapper extends StatelessWidget {
  final Widget child;
  const ConnectivityWrapper({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    // In Flutter Web / Desktop, online connectivity state is active by default
    return Stack(
      children: [
        child,
      ],
    );
  }
}
