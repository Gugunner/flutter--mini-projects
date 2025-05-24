import 'package:flutter/material.dart';
import 'package:infinity_scroll_feed_sample/Core/payload_abstract.dart';

class FeedListView extends StatefulWidget {
  const FeedListView({
    super.key,
    required this.feeds,
    this.loadingData = false,
    this.payload,
    this.onLoadData,
  });

  final PayloadAbstract? payload;
  final List<(String, String)> feeds;
  final bool loadingData;
  final VoidCallback? onLoadData;

  @override
  State<FeedListView> createState() => _FeedListViewState();
}

class _FeedListViewState extends State<FeedListView> {
  final _scrollController = ScrollController();

  @override
  void initState() {
    _scrollController.addListener(_scrollHandler);
    super.initState();
  }

  @override
  void dispose() {
    _scrollController.removeListener(_scrollHandler);
    _scrollController.dispose();
    super.dispose();
  }

  void _scrollHandler() {
    if (!_scrollController.hasClients ||
        (widget.payload?.page != null &&
            widget.payload?.page == widget.payload?.totalPages)) {
      return;
    }

    if (_scrollController.position.pixels >=
            _scrollController.position.maxScrollExtent - 100 &&
        !widget.loadingData) {
      widget.onLoadData?.call();
    }
  }

  int get _itemCount => widget.feeds.length + (widget.loadingData ? 1 : 0);

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      controller: _scrollController,
      itemCount: _itemCount,
      itemBuilder: (context, index) {
        return Container(
          decoration: BoxDecoration(
            border: Border(
              top:
                  index == 0
                      ? BorderSide(color: Colors.grey.shade200)
                      : BorderSide.none,
              bottom: BorderSide(color: Colors.grey.shade200),
            ),
          ),
          height: 80,
          child: Builder(
            builder: (context) {
              if (widget.loadingData && index == _itemCount - 1) {
                return Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    CircularProgressIndicator(color: Colors.grey.shade300),
                  ],
                );
              }
              final feed = widget.feeds[index];
              return Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(feed.$1),
                  Expanded(child: SizedBox()),
                  Text(feed.$2),
                ],
              );
            },
          ),
        );
      },
    );
  }
}
