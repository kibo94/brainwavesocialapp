import 'package:brainwavesocialapp/common/common.dart';
import 'package:brainwavesocialapp/domain/domain.dart';
import 'package:brainwavesocialapp/presentation/message/message_state.dart';
import 'package:brainwavesocialapp/presentation/search/search_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tuple/tuple.dart';
import 'package:intl/intl.dart';

class MessagePage extends ConsumerWidget {
  final TextEditingController _controller = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  final bool isGroupChat;
  final String toUserId;
  final String groupId;

  MessagePage(
      {super.key,
      required this.toUserId,
      required this.isGroupChat,
      required this.groupId});
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final messages = ref
        .watch(singleMessageProvider(Tuple3(toUserId, isGroupChat, groupId)));

    void scrollToBottom() {
      if (_scrollController.hasClients) {
        _scrollController
            .jumpTo(_scrollController.position.maxScrollExtent + 300);
      }
    }

    SchedulerBinding.instance.addPostFrameCallback((_) {
      if (_scrollController.hasClients) {
        if (messages.value != null && messages.value!.length > 6) {
          _scrollController
              .jumpTo(_scrollController.position.maxScrollExtent + 300);
        }
      }
    });

    return Scaffold(
      appBar: AppBar(
        title: Text(!isGroupChat ? toUserId : "Grupa"),
      ),
      body: Column(
        children: [
          if (messages.isLoading) const CircularProgressIndicator(),
          // List of messages
          Expanded(
            child: ListView.builder(
              controller: _scrollController, // Attach the controller
              itemCount: messages.value != null ? messages.value?.length : 0,
              itemBuilder: (context, index) {
                final ChatMessage chatMessage = messages.value![index];

                return Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Container(
                    padding: const EdgeInsets.all(12.0),
                    decoration: const BoxDecoration(),
                    child: Align(
                      alignment: Alignment.centerLeft,
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          if (chatMessage.avatar != null)
                            CircleAvatar(
                              backgroundImage:
                                  NetworkImage(chatMessage.avatar!),
                              radius: 30,
                            ),
                          GapWidgets.w8,
                          Container(
                            width: 200,
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(6),
                                color: Colors.black26),
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    softWrap: true,
                                    chatMessage.content,
                                    style: const TextStyle(fontSize: 16),
                                  ),
                                  Text(
                                    softWrap: true,
                                    DateFormat("d MMMM HH:mm")
                                        .format(chatMessage.timestamp),
                                    style: const TextStyle(fontSize: 16),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
          // Input field and send button at the bottom
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _controller,
                    decoration: InputDecoration(
                      hintText: "Type your message",
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(20.0),
                      ),
                    ),
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.send),
                  onPressed: () {
                    String message = _controller.text.trim();
                    if (message.isNotEmpty) {
                      ref.read(sendMessageStateProvider(
                          [message, toUserId, groupId]));
                      scrollToBottom();
                      // Close the keyboard
                      FocusScope.of(context).unfocus(); // Dismiss the keyboard
                      _controller.clear();
                    }
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
