import 'package:brainwavesocialapp/common/common.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class NotificationPage extends ConsumerWidget {
  const NotificationPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // final searchUsers = ref.watch(searchUsersStateProvider);
    // final followers = ref.watch(currentUserFollowingsStateProvider);

    return CommonPageScaffold(
      title: 'Notification',
      child: Text('NotificationPage'),
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
    );
  }
}
