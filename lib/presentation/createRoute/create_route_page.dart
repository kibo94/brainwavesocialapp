import 'package:brainwavesocialapp/common/common.dart';
import 'package:brainwavesocialapp/domain/entity/chat.dart';
import 'package:brainwavesocialapp/presentation/chats/chats_state.dart';
import 'package:brainwavesocialapp/presentation/profile/state/profile_state.dart';
import 'package:brainwavesocialapp/presentation/search/search_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class CreateGroupPage extends ConsumerWidget {
  CreateGroupPage({
    super.key,
  });
  final ScrollController _scrollController = ScrollController();
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final chats = ref.watch(chatsProvider);
    final currentUser = ref.watch(currentUserStateProvider).valueOrNull;
    final searchUsers = ref.watch(searchUsersStateProvider);

    return CommonPageScaffold(
      centerTitle: false,
      title: "Create Group",
      child: Column(
        children: [],
      ),
    );
  }
}
