import 'package:brainwavesocialapp/common/common.dart';
import 'package:brainwavesocialapp/domain/domain.dart';
import 'package:brainwavesocialapp/presentation/utils/user_util.dart';
import 'package:flutter/material.dart';

class RenderUsers extends StatelessWidget {
  const RenderUsers(
      {super.key,
      required this.users,
      required this.currentUser,
      required this.followers,
      required this.onFollow,
      required this.onUnfollow,
      required this.onNavigateToProfile,
      this.toFolow = false});

  final List<AppUser> users;
  final List<String> followers;
  final void Function(String) onFollow;
  final void Function(String) onUnfollow;
  final void Function(String) onNavigateToProfile;
  final bool toFolow;
  final AppUser currentUser;

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: users.length,
      itemBuilder: (context, index) {
        final user = users[index];
        final hasFollowed = followers.contains(user.uid);

        return Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: ListTile(
                leading: UserAvatar(
                  photoUrl: user.avatar,
                ),
                title: Text(user.name),
                onTap: () {
                  onNavigateToProfile(user.uid);
                },
              ),
            ),
            if (!UserUtil.isUserBlocked(currentUser, user))
              ElevatedButton(
                onPressed: () {
                  if (hasFollowed) {
                    onUnfollow(user.uid);
                  } else {
                    onFollow(user.uid);
                  }
                },
                child: Text(
                  hasFollowed ? 'Unfollow' : 'Follow',
                ),
              )
          ],
        );
      },
    );
  }
}
