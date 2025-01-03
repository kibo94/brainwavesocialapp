import 'package:brainwavesocialapp/data/data.dart';
import 'package:brainwavesocialapp/domain/domain.dart';
import 'package:brainwavesocialapp/presentation/utils/user_util.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tuple/tuple.dart';

import '../../common/common.dart';
import 'state/profile_state.dart';
import 'widgets/profile_header.dart';
import 'widgets/profile_info.dart';

class UserProfilePage extends ConsumerWidget {
  const UserProfilePage({
    super.key,
    required this.userId,
  });

  final String userId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final requestedUser = ref.watch(userProfileProvider(userId));
    final userPosts = ref.watch(userPostsProvider(userId));
    final currentUser = ref.watch(currentUserStateProvider).valueOrNull;
    final followers = ref.watch(userFollowersCount(userId)).valueOrNull ?? 0;
    final following = ref.watch(userFollowingCount(userId)).valueOrNull ?? 0;

    if (currentUser == null) {
      return const CommonPageScaffold(
        title: 'NotFound',
        child: Text('You are not logged in!'),
      );
    }

    return requestedUser.when(
      data: (user) {
        if (user == null) {
          return const CommonPageScaffold(
            title: 'NotFound',
            child: Text('User Not Found!'),
          );
        }
        return CommonPageScaffold(
          title: user.name,
          actions: userId == user.uid
              ? [
                  IconButton(
                    icon: const Icon(Icons.logout_outlined),
                    onPressed: () {
                      ref.read(signOutProvider);
                    },
                  ),
                ]
              : null,
          child: SingleChildScrollView(
            child: Column(
              children: [
                ProfileHeader(
                  coverImageUrl: user.cover,
                  profileImageUrl: user.avatar,
                  uid: user.uid,
                  currentUserId: currentUser.uid,
                ),
                ProfileInfo(
                  name: user.name,
                  email: user.email,
                  bio: user.bio,
                ),
                const Divider(),
                !UserUtil.isUserBlocked(currentUser, user)
                    ? Column(
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              Text('$following Following'),
                              Text('$followers Followers'),
                              if (user.id != currentUser.uid)
                                IconButton(
                                  onPressed: () => {
                                    AppRouter.go(
                                        context, RouterNames.messagePage,
                                        pathParameters: {
                                          'toUserId': user.email!,
                                          "isGroupChat": "false",
                                          "groupId": "null",
                                        })
                                  },
                                  icon: const Icon(Icons.message_outlined),
                                ),
                              if (user.id != currentUser.uid)
                                _buildPopupMenu(
                                  context,
                                  user,
                                  ref,
                                  currentUser,
                                )
                            ],
                          ),
                          const Divider(),
                          GapWidgets.h24,
                          if (userPosts.isLoading)
                            const CircularProgressIndicator(),
                          if (userPosts.hasError)
                            const Text('Error Loading Posts!'),
                          if (userPosts.hasValue &&
                              userPosts.value != null &&
                              userPosts.value!.isEmpty)
                            const Text('No Posts Yet!'),
                          if (userPosts.hasValue && userPosts.value != null)
                            for (int i = 0; i < userPosts.value!.length; i++)
                              PostCard(
                                currentUserId: currentUser.uid,
                                post: userPosts.value![i],
                                onToggleLike: () {
                                  ref.read(
                                    togglePostLikeProvider(
                                        userPosts.value![i].uid),
                                  );
                                },
                                onReshare: () {},
                                onUpdate: (String ct) {
                                  Post post = userPosts.value![i];
                                  var updatedPost = PostDataModel(
                                    uid: post.uid,
                                    ownerId: post.ownerId,
                                    content: ct,
                                    timestamp: post.timestamp,
                                  );

                                  ref.read(
                                      updatePostStateProvider(updatedPost));
                                },
                                onDelete: () {
                                  ref.read(
                                    deletePostProvider(userPosts.value![i].uid),
                                  );
                                },
                              ),
                        ],
                      )
                    : const Padding(
                        padding: EdgeInsets.only(top: 20),
                        child: Center(
                          child: Text("You are blocked by this user"),
                        ),
                      )
              ],
            ),
          ),
        );
      },
      error: (error, _) {
        return CommonPageScaffold(
          title: 'Error',
          child: Text('Error: $error'),
        );
      },
      loading: () => const CircularProgressIndicator(),
    );
  }

  Widget _buildPopupMenu(
      BuildContext context, AppUser user, WidgetRef ref, AppUser userToBlock) {
    var isUserBlocked = UserUtil.isUserBlocked(
      user,
      userToBlock,
    );
    return PopupMenuButton<String>(
      icon: const Icon(Icons.more_vert),
      padding: const EdgeInsets.all(4),
      onSelected: (value) {
        switch (value) {
          case 'block':
            ref.read(blockUserProvider(
              Tuple2(user, userToBlock.email!),
            ));
            break;

          case 'unblock':
            ref.read(blockUserProvider(
              Tuple2(user, userToBlock.email!),
            ));
            break;
        }
      },
      itemBuilder: (BuildContext context) {
        return [
          // PopupMenuItem<String>(
          //   value: 'edit',
          //   child: Row(
          //     children: [
          //       Icon(Icons.edit),
          //       SizedBox(width: 8),
          //       Text('Edit Chat'),
          //     ],
          //   ),
          // ),
          PopupMenuItem<String>(
            value: !isUserBlocked ? 'block' : "unblock",
            padding: const EdgeInsets.all(4),
            child: Row(
              children: [
                const Icon(Icons.block),
                const SizedBox(width: 8),
                Text('${!isUserBlocked ? "Block" : "Unblock"} user'),
              ],
            ),
          ),
        ];
      },
    );
  }
}
