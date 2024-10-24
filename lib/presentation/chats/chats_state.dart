import 'package:brainwavesocialapp/domain/entity/chat.dart';
import 'package:brainwavesocialapp/domain/usecases/user_chats_usecase.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final chatsProvider = StreamProvider.autoDispose<List<Chat>>(
  (ref) {
    return ref.watch(userChatsCaseProvider).getAllChatsForUser();
  },
);

final deleteChatProvider = FutureProvider.autoDispose.family<void, String>(
  (ref, id) async {
    return ref.watch(userChatsCaseProvider).deleteChat(id);
  },
);
