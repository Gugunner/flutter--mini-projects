import 'dart:ui';

import 'package:infinity_scroll_feed_sample/Core/payload_abstract.dart';

abstract class RepositoryAbstract {
  void loadData({
    int page = 1,
    Function(PayloadAbstract)? onComplete,
    VoidCallback? onError,
  });
}
