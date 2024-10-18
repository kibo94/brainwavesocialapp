import 'package:brainwavesocialapp/data/data.dart';
import 'package:brainwavesocialapp/domain/entity/chat.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

abstract interface class UserChatsUseCase {
  Stream<List<Chat>> getAllChatsForUser();
}

class _UserMessageUseCase implements UserChatsUseCase {
  const _UserMessageUseCase(this._userRepository, this._authRepository);
  final UserRepository _userRepository;
  final AuthRepository _authRepository;

  @override
  Stream<List<Chat>> getAllChatsForUser() async* {
    final user = _authRepository.currentUser;
    final chats = _userRepository.getAllChatsForUser(user.email!).map(
          (event) => event
              .map(
                (message) => Chat.fromDataModel(message),
              )
              .toList(),
        );

    yield* chats;
  }
}

final userChatsCaseProvider = Provider<UserChatsUseCase>(
  (ref) => _UserMessageUseCase(
      ref.watch(userRepositoryProvider), ref.watch(authRepositoryProvider)),
);
