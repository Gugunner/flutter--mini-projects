import 'package:infinity_scroll_feed_sample/Core/payload_abstract.dart';

class FeedPayload implements PayloadAbstract {
  int _page = 1;
  int _totalPages = 1;
  List _data = [];

  FeedPayload({
    required int page,
    required int totalPages,
    required List<Object> feeds,
  }) {
    assert(feeds is List<(String, String)>);
    _page = page;
    _totalPages = totalPages;
    _data = feeds;
  }

  @override
  int get page => _page;

  @override
  int get totalPages => _totalPages;

  @override
  List get data => _data;
}
