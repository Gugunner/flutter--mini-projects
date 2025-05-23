import 'package:flutter/material.dart';
import 'package:stream_messages_sample/Data/Model/message.dart';
import 'package:stream_messages_sample/ViewModel/messages_view_model.dart';
import 'package:stream_messages_sample/Widgets/message_list_view.dart';

class MessagePage extends StatefulWidget {
  const MessagePage({super.key});

  @override
  State<MessagePage> createState() => _MessagePageState();
}

class _MessagePageState extends State<MessagePage> {
  final messageViewModel = MessagesViewModel();
  int count = 1;

  @override
  void initState() {
    messageViewModel.startStream();
    super.initState();
  }

  @override
  void dispose() {
    messageViewModel.dispose();
    messageViewModel.stopStream();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        minimum: EdgeInsets.only(left: 16, right: 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: 20),
            Center(child: Text("Stream Messages Sample")),
            SizedBox(height: 20),
            Expanded(child: MessageListView(viewModel: messageViewModel)),
            OutlinedButton(
              onPressed: () {
                final message = Message(
                  id: count,
                  primaryText: "User -> $count",
                  secondaryText: "Local Message",
                );
                messageViewModel.send(message);
                count += 1;
              },
              child: Text("Send"),
            ),
          ],
        ),
      ),
    );
  }
}
