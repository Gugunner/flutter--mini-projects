import 'package:flutter/material.dart';
import 'package:stream_messages_sample/Data/Model/Message.dart';
import 'package:stream_messages_sample/Widgets/message_widget.dart';

class MessageListView extends StatelessWidget {
  const MessageListView({super.key});

  @override
  Widget build(BuildContext context) {
    final messages = List.generate(
      10,
      (idx) => Message(
        id: idx,
        primaryText: "Remote -> $idx",
        secondaryText: "Network Message",
      ),
    );
    return ListView.builder(
      itemCount: messages.length,
      itemBuilder: (context, index) {
        final message = messages[index];
        return MessageCell(message: message, index: index);
      },
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
