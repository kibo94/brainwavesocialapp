import 'package:brainwavesocialapp/domain/domain.dart';
import 'package:brainwavesocialapp/domain/usecases/user_message_usercase.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final sendMessageStateProvider =
    FutureProvider.autoDispose.family<void, String>(
  (ref, message) async {
    return ref.watch(userMessageCaseProvider).sentMessage(message);
  },
);

final messagesProvider = StreamProvider.autoDispose<List<ChatMessage>>(
  (ref) {
    return ref.watch(userMessageCaseProvider).getMessages();
  },
);
