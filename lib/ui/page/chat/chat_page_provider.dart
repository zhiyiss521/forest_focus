import 'package:flutter/cupertino.dart';

import '../../../core/model/chat_message.dart';
import '../../../core/model/firend.dart';

class ChatPageProvider extends ChangeNotifier {
  final Friend friend;

  ChatPageProvider(this.friend);

  final TextEditingController textController =
  TextEditingController();

  final FocusNode focusNode = FocusNode();

  final ScrollController scrollController =
  ScrollController();

  final List<ChatMessage> messages = [];

  bool get canSend =>
      textController.text.trim().isNotEmpty;

  void sendMessage() {
    final text = textController.text.trim();

    if (text.isEmpty) {
      return;
    }

    final now = DateTime.now();

    messages.add(
      ChatMessage(
        content: text,
        isMine: true,
        time:
        '${now.hour.toString().padLeft(2, '0')}:'
            '${now.minute.toString().padLeft(2, '0')}',
      ),
    );

    textController.clear();

    notifyListeners();

    _scrollToBottom();
  }

  void _scrollToBottom() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!scrollController.hasClients) {
        return;
      }

      scrollController.animateTo(
        scrollController.position.maxScrollExtent,
        duration: const Duration(
          milliseconds: 250,
        ),
        curve: Curves.easeOut,
      );
    });
  }

  @override
  void dispose() {
    textController.dispose();
    focusNode.dispose();
    scrollController.dispose();
    super.dispose();
  }
}