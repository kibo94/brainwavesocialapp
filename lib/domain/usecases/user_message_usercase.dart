import 'package:brainwavesocialapp/data/data.dart';
import 'package:brainwavesocialapp/domain/domain.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

abstract interface class UserMessageUseCase {
  Future<void> sentMessage(String message, String user2Email);
  Stream<List<ChatMessage>> getMessages();
  Stream<List<ChatMessage>> getSingleChatMessages(String toEmail);
}

class _UserMessageUseCase implements UserMessageUseCase {
  const _UserMessageUseCase(this._userRepository, this._authRepository);
  final UserRepository _userRepository;
  final AuthRepository _authRepository;

  @override
  Future<void> sentMessage(String message, String user2Email) {
    final user = _authRepository.currentUser;
    return _userRepository.sendMessage(user.email!, message, user2Email);
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
  Stream<List<ChatMessage>> getSingleChatMessages(String toEmail) async* {
    final user = _authRepository.currentUser;
    final messages =
        _userRepository.getSingleChatMessages(user.email!, toEmail).map(
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