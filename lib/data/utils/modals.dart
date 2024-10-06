import "package:brainwavesocialapp/common/common.dart";
import "package:flutter/material.dart";

class Modals {
  static showPostModal(
    BuildContext context,
    TextEditingController? controller,
    createPostCallback,
  ) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: false,
      builder: (BuildContext context) {
        return SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Center(
                  child: Text(
                    'Create Post',
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                ),
                GapWidgets.h16,
                TextField(
                  controller: controller,
                  maxLines: null,
                  minLines: 9,
                  decoration: const InputDecoration(
                    hintText: "What's happening?",
                    border: OutlineInputBorder(),
                  ),
                ),
                GapWidgets.h16,
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    IconButton(
                      icon: const Icon(Icons.image),
                      onPressed: () async {},
                    ),
                    FilledButton.icon(
                      icon: const Icon(Icons.send),
                      label: const Text('Post'),
                      onPressed: createPostCallback,
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
