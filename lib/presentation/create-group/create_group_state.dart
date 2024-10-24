import 'package:brainwavesocialapp/data/models/chat_group.dart';
import 'package:brainwavesocialapp/domain/usecases/user_chats_usecase.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final createChatProvider =
    FutureProvider.autoDispose.family<String, List<GroupUser>>(
  (ref, usersForCreatingAGroup) async {
    // Use the provider that creates the chat group and returns the chat ID as a Future<String>
    return ref
        .watch(userChatsCaseProvider)
        .createChatGroup(usersForCreatingAGroup);
  },
);
