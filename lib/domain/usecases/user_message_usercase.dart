import 'package:brainwavesocialapp/data/data.dart';
import 'package:brainwavesocialapp/domain/domain.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

abstract interface class UserMessageUseCase {
  Future<void> sentMessage(String message, String user2Email, String groupId);
  Stream<List<ChatMessage>> getMessages();
  Stream<int> getUnreadChatsCount();
  Stream<List<ChatMessage>> getSingleChatMessages(
      String toUserId, bool isChatGroup, String chatGroupId);
}

class _UserMessageUseCase implements UserMessageUseCase {
  const _UserMessageUseCase(this._userRepository, this._authRepository);
  final UserRepository _userRepository;
  final AuthRepository _authRepository;

  @override
  Future<void> sentMessage(String message, String user2Email, String groupId) {
    final user = _authRepository.currentUser;
    return _userRepository.sendMessage(
        user.email!, message, user2Email, groupId);
  }

  @override
  Stream<int> getUnreadChatsCount() async* {
    final user = _authRepository.currentUser;
    var count = _userRepository.getUnreadChatsCount(user.email!);
    yield* count;
  }

  @override
  Stream<List<ChatMessage>> getMessages() async* {
    final messages = _userRepository.getMessages().map(
          (event) => event
              .map(
                (message) => ChatMessage.fromDataModel(message),
              )
              .toList(),
        );

    yield* messages;
  }

  @override
  Stream<List<ChatMessage>> getSingleChatMessages(
      String toUserId, bool isChatGroup, String chatGroupId) async* {
    final user = _authRepository.currentUser;
    final messages = _userRepository
        .getSingleChatMessages(user.email!, toUserId, isChatGroup, chatGroupId)
        .map(
          (event) => event
              .map(
                (message) => ChatMessage.fromDataModel(message),
              )
              .toList(),
        );

    yield* messages;
  }
}

final userMessageCaseProvider = Provider<UserMessageUseCase>(
  (ref) => _UserMessageUseCase(
      ref.watch(userRepositoryProvider), ref.watch(authRepositoryProvider)),
);
