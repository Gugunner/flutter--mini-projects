import 'package:flutter/cupertino.dart';
import 'package:infinity_scroll_feed_sample/Core/payload_abstract.dart';
import 'package:infinity_scroll_feed_sample/Core/view_data_abstract.dart';
import 'package:infinity_scroll_feed_sample/Data/Model/feed_payload.dart';
import 'package:infinity_scroll_feed_sample/Data/Repository/feed_repository.dart';
import 'package:infinity_scroll_feed_sample/Presenter/feed_presenter.dart';
import 'package:infinity_scroll_feed_sample/Widgets/feed_list_view.dart';

class FeedView extends StatefulWidget {
  const FeedView({super.key});

  @override
  State<FeedView> createState() => _FeedViewState();
}

class _FeedViewState extends State<FeedView> implements ViewDataAbstract {
  final List<(String, String)> _feeds = [];
  final presenter = FeedPresenter(repository: FeedRepository());

  @override
  PayloadAbstract? payload;
  @override
  bool loading = false;

  @override
  void initState() {
    presenter.view = this;
    loading = true;
    presenter.loadData();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return FeedListView(
      feeds: _feeds,
      loadingData: loading,
      payload: payload,
      onLoadData: onLoadData,
    );
  }

  void onLoadData() {
    presenter.loadData();
    setState(() {
      loading = true;
    });
  }

  @override
  void loadData(PayloadAbstract data) {
    assert(data is FeedPayload);
    _feeds.addAll(data.data as List<(String, String)>);
    payload = data;
    loading = false;
    setState(() {});
  }
}
