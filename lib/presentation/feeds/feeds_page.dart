import 'package:brainwavesocialapp/common/common.dart';
import 'package:brainwavesocialapp/data/utils/modals.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../profile/state/profile_state.dart';
import 'feed_state.dart';

class FeedsPage extends ConsumerWidget {
  FeedsPage({super.key});

  final ScrollController scrollController = ScrollController();
  final controller = TextEditingController(text: '');

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final currentUser = ref.watch(currentUserStateProvider);
    final unreadCount = ref.watch(unreadChatsProvider);
    final posts = ref.watch(feedStateProvider);

    if (currentUser.isLoading || posts.isLoading) {
      return const CommonPageScaffold(
        title: 'Loading...',
        child: CircularProgressIndicator(),
      );
    }

    if (!currentUser.hasValue || currentUser.hasError) {
      return CommonPageScaffold(
        title: 'Error',
        child: ElevatedButton(
          onPressed: () {
            ref.read(signOutStateProvider);
          },
          child: const Text('You are not logged in!'),
        ),
      );
    }

    return posts.when(
      data: (posts) {
        return CommonPageScaffold(
          title: 'Your Feed',
          leading: TextButton(
            child: UserAvatar(
              photoUrl: currentUser.value!.avatar,
            ),
            onPressed: () {
              AppRouter.go(
                context,
                RouterNames.userProfilePage,
                pathParameters: {
                  'userId': currentUser.value!.uid,
                },
              );
            },
          ),
          actions: [
            Row(
              children: [
                GestureDetector(
                  onTap: () => {
                    AppRouter.go(
                      context,
                      RouterNames.chats,
                    )
                  },
                  child: Stack(
                    children: [
                      const Padding(
                        padding: EdgeInsets.all(8.0),
                        child: Icon(Icons.message_outlined),
                      ),
                      if (unreadCount.value! > 0)
                        Container(
                            width: 22,
                            height: 22,
                            alignment: Alignment.center,
                            decoration: BoxDecoration(
                                color: Colors.redAccent,
                                borderRadius: BorderRadius.circular(20)),
                            child: Text(
                              unreadCount.value.toString(),
                              style: const TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold),
                            )),
                    ],
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.add_circle_outline),
                  onPressed: () {
                    Modals.showPostModal(
                      context,
                      controller,
                      () {
                        ref.read(
                          createPostStateProvider(
                            controller.text,
                          ),
                        );
                        AppRouter.go(
                          context,
                          RouterNames.userProfilePage,
                          pathParameters: {
                            'userId': currentUser.value!.uid,
                          },
                        );
                        controller.clear();
                        AppRouter.pop(context);
                      },
                    );
                  },
                ),
              ],
            ),
          ],
          bottomNavigationBar: BottomNavigationBar(
            onTap: (int index) {
              if (index == 0) {
                AppRouter.go(context, RouterNames.feedsPage);
              } else if (index == 1) {
                AppRouter.go(context, RouterNames.searchPage);
              } else if (index == 2) {
                AppRouter.go(context, RouterNames.notificationsPage);
              } else if (index == 3) {
                AppRouter.go(context, RouterNames.settingsPage);
              }
            },
            items: const [
              BottomNavigationBarItem(
                icon: Icon(Icons.home),
                label: 'Home',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.search),
                label: 'Search',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.notifications),
                label: 'Notifications',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.settings),
                label: 'Setting',
              ),
            ],
          ),
          child: posts.isEmpty
              ? const Center(
                  child: Text('No Posts Yet! Start following.'),
                )
              : SingleChildScrollView(
                  // physics: const NeverScrollableScrollPhysics(),
                  child: ListView.builder(
                    controller: scrollController,
                    itemCount: posts.length,
                    shrinkWrap: true,
                    itemBuilder: (context, index) {
                      return PostCard(
                        currentUserId: currentUser.value!.uid,
                        post: posts[index],
                        onToggleLike: () {
                          ref.read(
                            togglePostLikeProvider(posts[index].uid),
                          );
                        },
                        onReshare: () {},
                      );
                    },
                  ),
                ),
        );
      },
      loading: () {
        return const CommonPageScaffold(
          title: 'Loading feed...',
          child: Center(
            child: CircularProgressIndicator(),
          ),
        );
      },
      error: (error, stackTrace) {
        debugPrint('Error: $error');
        return const CommonPageScaffold(
          title: 'Error',
          child: Text('Error Loading Posts!'),
        );
      },
    );
  }
}
