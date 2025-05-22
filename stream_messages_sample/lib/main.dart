import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:stream_messages_sample/Widgets/message_list_view.dart';

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
            children: [
              SizedBox(height: 20),
              Center(child: Text("Stream Messages Sample")),
              SizedBox(height: 20),
              Expanded(child: MessageListView()),
            ],
          ),
        ),
      ),
    );
  }
}
