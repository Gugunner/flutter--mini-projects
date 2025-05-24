import 'package:flutter/material.dart';
import 'package:infinity_scroll_feed_sample/Widgets/feed_view.dart';

class FeedPage extends StatelessWidget {
  const FeedPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        minimum: EdgeInsets.only(left: 16, right: 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: 40),
            Center(child: Text("Infinity Scroll Feed Sample")),
            SizedBox(height: 20),
            Expanded(child: FeedView()),
          ],
        ),
      ),
    );
  }
}
