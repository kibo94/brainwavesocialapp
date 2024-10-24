import 'package:brainwavesocialapp/domain/domain.dart';
import 'package:brainwavesocialapp/domain/usecases/user_message_usercase.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final feedStateProvider = StreamProvider.autoDispose<List<Post>>(
  (ref) {
    return ref.watch(feedUseCaseProvider).getFeedPosts();
  },
);

final createPostStateProvider = FutureProvider.autoDispose.family<void, String>(
  (ref, content) async {
    return ref.watch(feedUseCaseProvider).createPost(content);
  },
);

final signOutStateProvider = Provider<Future<void>>(
  (ref) {
    return ref.watch(userUseCaseProvider).signOut();
  },
);
final unreadChatsProvider = StreamProvider.autoDispose<int>(
  (ref) {
    return ref.watch(userMessageCaseProvider).getUnreadChatsCount();
  },
);
