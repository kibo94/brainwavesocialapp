import 'package:brainwavesocialapp/common/common.dart';
import 'package:brainwavesocialapp/data/utils/modals.dart';
import 'package:flutter/material.dart';

import '../../domain/entity/post.dart';
import '../../domain/entity/user.dart';

class PostHeader extends StatelessWidget {
  const PostHeader(
      {super.key,
      required this.post,
      this.postOwner,
      required this.currentUserId,
      this.onDelete,
      this.onUpdate});

  final Post post;
  final AppUser? postOwner;
  final String currentUserId;
  final VoidCallback? onDelete;
  final void Function(String value)? onUpdate;
  @override
  Widget build(BuildContext context) {
    final controller = TextEditingController(text: post.content);
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                postOwner!.email!.isNotEmpty ? postOwner!.email! : "unknown",
                // postOwner?.name ?? 'unknown',
                style: Theme.of(context).textTheme.titleSmall,
              ),
              if (post.location != null)
                Text(
                  post.location!,
                  style: Theme.of(context).textTheme.bodySmall,
                ),
            ],
          ),
        ),
        if (postOwner != null &&
            postOwner!.uid == currentUserId &&
            onDelete != null)
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              IconButton(
                onPressed: onDelete,
                icon: const Icon(
                  Icons.delete_forever_outlined,
                ),
              ),
              IconButton(
                onPressed: () => {
                  controller.text = post.content,
                  Modals.showPostModal(context, controller, () {
                    onUpdate!(controller.text);
                    AppRouter.go(
                      context,
                      RouterNames.userProfilePage,
                      pathParameters: {'userId': currentUserId},
                    );
                    controller.clear();
                    AppRouter.pop(context);
                  })
                },
                icon: const Icon(Icons.edit_outlined),
              )
            ],
          ),
      ],
    );
  }
}
