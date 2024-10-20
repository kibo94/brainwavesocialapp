import 'package:brainwavesocialapp/data/models/chat_group.dart';
import 'package:brainwavesocialapp/domain/usecases/user_chats_usecase.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final createChatProvider =
    FutureProvider.autoDispose.family<void, List<GroupUser>>(
  (ref, usersForCreatingAGroup) {
    return ref
        .watch(userChatsCaseProvider)
        .createChatGroup(usersForCreatingAGroup);
  },
);
