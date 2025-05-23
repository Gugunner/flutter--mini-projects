import 'package:flutter/material.dart';
import 'package:stream_messages_sample/Data/Model/message.dart';

class MessageWidget extends StatelessWidget {
  const MessageWidget({super.key, required this.message});

  final Message message;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [Text(message.primaryText), Text(message.secondaryText)],
      ),
    );
  }
}
