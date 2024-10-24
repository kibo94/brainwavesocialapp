import 'package:brainwavesocialapp/domain/domain.dart';
import 'package:brainwavesocialapp/domain/usecases/user_message_usercase.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tuple/tuple.dart';

final sendMessageStateProvider =
    FutureProvider.autoDispose.family<void, List<String>>(
  (ref, data) async {
    return ref
        .watch(userMessageCaseProvider)
        .sentMessage(data[0], data[1], data[2]);
  },
);

final messagesProvider = StreamProvider.autoDispose<List<ChatMessage>>(
  (ref) {
    return ref.watch(userMessageCaseProvider).getMessages();
  },
);

final singleMessageProvider = StreamProvider.autoDispose
    .family<List<ChatMessage>, Tuple3<String, bool, String>>(
  (ref, data) {
    final message = data.item1; // First string parameter
    final toUser = data.item2; // Second string parameter
    final chatId = data.item3;
    return ref
        .watch(userMessageCaseProvider)
        .getSingleChatMessages(message, toUser, chatId);
  },
);
