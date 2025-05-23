import 'package:flutter/material.dart';
import 'package:stream_messages_sample/Data/Model/message.dart';
import 'package:stream_messages_sample/ViewModel/messages_view_model.dart';
import 'package:stream_messages_sample/Widgets/message_widget.dart';

class MessageListView extends StatefulWidget {
  const MessageListView({super.key, required this.viewModel});

  final MessagesViewModel viewModel;

  @override
  State<MessageListView> createState() => _MessageListViewState();
}

class _MessageListViewState extends State<MessageListView> {
  final _scrollController = ScrollController();
  final GlobalKey<AnimatedListState> _animatedListKey = GlobalKey();

  @override
  void initState() {
    widget.viewModel.addListener(_scrollToNewMessage);
    super.initState();
  }

  void _scrollToNewMessage() {
    if (!_scrollController.hasClients || widget.viewModel.messages.isEmpty) {
      return;
    }
    final index = widget.viewModel.messages.length - 1;

    _animatedListKey.currentState?.insertItem(index);

    _scrollController.animateTo(
      _scrollController.position.maxScrollExtent,
      duration: Duration(milliseconds: 200),
      curve: Curves.bounceIn,
    );
  }

  @override
  void dispose() {
    widget.viewModel.removeListener(_scrollToNewMessage);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: widget.viewModel,
      builder:
          (context, child) => AnimatedList(
            key: _animatedListKey,
            physics: const BouncingScrollPhysics(),
            controller: _scrollController,
            initialItemCount: widget.viewModel.messages.length,
            itemBuilder: (context, index, animation) {
              final message = widget.viewModel.messages[index];
              return SizeTransition(
                sizeFactor: animation,
                axisAlignment: 0.0,
                child: MessageCell(message: message, index: index),
              );
            },
          ),
    );
  }
}

class MessageCell extends StatelessWidget {
  const MessageCell({super.key, required this.message, required this.index});

  final Message message;
  final int index;

  @override
  Widget build(BuildContext context) {
    return Container(
      key: ValueKey(message.id),
      height: 80,
      decoration: BoxDecoration(
        border: Border(
          top:
              index == 0
                  ? BorderSide(color: Colors.grey.shade200)
                  : BorderSide.none,
          bottom: BorderSide(color: Colors.grey.shade200),
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.only(top: 20),
        child: MessageWidget(message: message),
      ),
    );
  }
}
