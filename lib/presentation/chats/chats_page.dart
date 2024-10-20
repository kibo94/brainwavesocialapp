import 'package:brainwavesocialapp/common/common.dart';
import 'package:brainwavesocialapp/domain/entity/chat.dart';
import 'package:brainwavesocialapp/presentation/chats/chats_state.dart';
import 'package:brainwavesocialapp/presentation/profile/state/profile_state.dart';
import 'package:brainwavesocialapp/presentation/search/search_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class ChatsPage extends ConsumerWidget {
  ChatsPage({
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
      withPadding: true,
      actions: [
        Padding(
          padding: const EdgeInsets.only(right: 16),
          child: GestureDetector(
            onTap: () {
              AppRouter.go(
                context,
                RouterNames.createGroup,
              );
            },
            child: const Row(
              children: [
                Text(
                  "Create Group",
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                GapWidgets.w8,
                Icon(
                  Icons.add_circle_outline,
                )
              ],
            ),
          ),
        )
      ],
      title: "Chats",
      child: Column(
        children: [
          Expanded(
            child: ListView.builder(
              controller: _scrollController, // Attach the controller
              itemCount: chats.value != null ? chats.value?.length : 0,
              itemBuilder: (context, index) {
                final Chat chat = chats.value![index];
                bool isChatGroup = chat.type != "group";
                var unreadMessages = chat.unreadCount[currentUser?.email];
                final secondUser = chat.participants.firstWhere(
                    (participant) => participant != currentUser!.email);
                return Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Align(
                    alignment: Alignment.centerLeft,
                    child: GestureDetector(
                      onTap: () {
                        AppRouter.go(
                          context,
                          RouterNames.messagePage,
                          pathParameters: {
                            "toUserId": secondUser,
                            "isGroupChat": isChatGroup.toString(),
                            "groupId": chat.chatId
                          },
                        );
                      },
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          UserAvatar(
                              photoUrl: isChatGroup
                                  ? searchUsers.value!
                                      .firstWhere(
                                          (user) => user.email == secondUser)
                                      .photoUrl!
                                  : ""),
                          GapWidgets.w8,
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              isChatGroup
                                  ? Text(secondUser)
                                  : Column(
                                      children: chat.participants
                                          .map((participant) =>
                                              Text(participant))
                                          .toList(),
                                    ),
                              Text(
                                softWrap: true,
                                unreadMessages != null && unreadMessages > 1
                                    ? '$unreadMessages messages'
                                    : chat.lastMessage,
                                style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: unreadMessages != null &&
                                            unreadMessages != null &&
                                            unreadMessages > 0
                                        ? FontWeight.bold
                                        : FontWeight.normal),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
