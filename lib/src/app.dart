import 'package:flutter/material.dart';

import 'package:scanner_mobile/src/screens/initial_screen.dart';

class ScannerApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData.light(),
      home: InitialScreen()
    );
  }
}