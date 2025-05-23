import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return CupertinoApp(
      home: Scaffold(
        body: SafeArea(
          minimum: EdgeInsets.only(left: 16, right: 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: 20),
              Center(child: Text("Infinity Scroll Feed Sample")),
              SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }
}
