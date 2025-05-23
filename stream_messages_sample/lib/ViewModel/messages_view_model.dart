import 'dart:async';

import 'package:flutter/material.dart';
import 'package:stream_messages_sample/Data/Model/message.dart';

class _MessageUpdates<T extends Message> {
  final controller = StreamController<T>();
  StreamSubscription<T>? subscription;

  void dispose() {
    subscription?.cancel();
    controller.close();
  }
}

class MessagesViewModel extends ChangeNotifier {
  List<Message> messages = [];

  final _MessageUpdates _currentUpdates = _MessageUpdates<Message>();
  final _MessageUpdates _userUpdates = _MessageUpdates<Message>();
  StreamSubscription<Message>? _remoteSubscription;
  int _count = 0;

  bool get _canUpdateRemote => _remoteSubscription == null && _count < 50;

  bool get _canUpdateControllers =>
      !_userUpdates.controller.isClosed && !_currentUpdates.controller.isClosed;

  void startStream() {
    if (!_canUpdateRemote || !_canUpdateControllers) {
      return;
    }

    _remoteSubscription = _networkStream().listen(_currentUpdateHandler);

    _userUpdates.subscription = _userUpdates.controller.stream.listen(
      _currentUpdateHandler,
    );

    _currentUpdates.subscription = _currentUpdates.controller.stream.listen((
      m,
    ) {
      messages.add(m);
      notifyListeners();
    });
  }

  void stopStream() {
    _remoteSubscription?.cancel();
    _remoteSubscription = null;

    _userUpdates.dispose();
    _currentUpdates.dispose();
  }

  void _currentUpdateHandler(Message message) {
    if (!_currentUpdates.controller.isClosed) {
      _currentUpdates.controller.add(message);
    }
  }

  void send(Message message) {
    if (!_userUpdates.controller.isClosed) {
      _userUpdates.controller.add(message);
    }
  }

  Stream<Message> _networkStream() async* {
    while (_count < 50) {
      await Future.delayed(Duration(seconds: 2));
      _count += 1;
      yield Message(
        id: _count,
        primaryText: "Remote -> $_count",
        secondaryText: "Network Message",
      );
    }
  }
}
