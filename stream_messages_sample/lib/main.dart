import 'package:flutter/cupertino.dart';
import 'package:stream_messages_sample/Widgets/message_page.dart';

void main() {
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return CupertinoApp(home: MessagePage());
  }
}
