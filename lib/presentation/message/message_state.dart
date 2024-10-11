import 'package:brainwavesocialapp/domain/domain.dart';
import 'package:brainwavesocialapp/domain/usecases/user_message_usercase.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final sendMessageStateProvider =
    FutureProvider.autoDispose.family<void, List<String>>(
  (ref, data) async {
    return ref.watch(userMessageCaseProvider).sentMessage(data[0], data[1]);
  },
);

final messagesProvider = StreamProvider.autoDispose<List<ChatMessage>>(
  (ref) {
    return ref.watch(userMessageCaseProvider).getMessages();
  },
);

final singleMessageProvider =
    StreamProvider.autoDispose.family<List<ChatMessage>, String>(
  (ref, toEmail) {
    return ref.watch(userMessageCaseProvider).getSingleChatMessages(toEmail);
  },
);
