import 'package:flutter/foundation.dart' show debugPrint;
import 'package:infinity_scroll_feed_sample/Core/repository_abstract.dart';
import 'package:infinity_scroll_feed_sample/Core/view_data_abstract.dart';

class FeedPresenter {
  final RepositoryAbstract repository;
  late ViewDataAbstract view;

  FeedPresenter({required this.repository});

  void loadData() {
    debugPrint("Loading data from presenter");
    final page = (view.payload?.page ?? 0) + 1;
    repository.loadData(
      page: page,
      onComplete: view.loadData,
      onError: () {
        debugPrint("An error occured when loading data");
      },
    );
  }
}
