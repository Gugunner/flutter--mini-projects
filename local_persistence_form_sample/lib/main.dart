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
          child: Column(
            children: [
              SizedBox(height: 20),
              Center(child: Text("Local Persistence Form Sample")),
              SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }
}
