import 'package:flutter/cupertino.dart';
import 'package:infinity_scroll_feed_sample/Widgets/feed_page.dart';

void main() {
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return CupertinoApp(home: FeedPage());
  }
}
