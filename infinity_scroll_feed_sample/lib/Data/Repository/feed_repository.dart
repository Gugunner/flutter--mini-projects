import 'dart:ui';

import 'package:infinity_scroll_feed_sample/Core/payload_abstract.dart';
import 'package:infinity_scroll_feed_sample/Core/repository_abstract.dart';
import 'package:infinity_scroll_feed_sample/Data/Model/feed_payload.dart';

class FeedRepository implements RepositoryAbstract {
  @override
  void loadData({
    int page = 1,
    Function(PayloadAbstract)? onComplete,
    VoidCallback? onError,
  }) {
    if (page > 5) return;
    Future.delayed(Duration(seconds: 2), () {
      final feeds = List.generate(
        20,
        (idx) => ("Feed ${idx + 1}", "Page $page"),
      );
      final payload = FeedPayload(page: page, totalPages: 5, feeds: feeds);
      onComplete?.call(payload);
    });
  }
}
