import 'package:infinity_scroll_feed_sample/Core/payload_abstract.dart';

abstract class ViewDataAbstract {
  PayloadAbstract? payload;
  bool get loading;
  void loadData(PayloadAbstract data);
}
