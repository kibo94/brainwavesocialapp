import 'package:brainwavesocialapp/common/common.dart';
import 'package:brainwavesocialapp/data/models/chat_group.dart';
import 'package:brainwavesocialapp/presentation/create-group/create_group_state.dart';
import 'package:brainwavesocialapp/presentation/profile/state/profile_state.dart';
import 'package:brainwavesocialapp/presentation/search/search_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class CreateGroupPage extends ConsumerStatefulWidget {
  const CreateGroupPage({super.key});

  @override
  ConsumerState<CreateGroupPage> createState() => _CreateGroupPageState();
}

class _CreateGroupPageState extends ConsumerState<CreateGroupPage> {
  late ScrollController _scrollController;
  List<GroupUser> usersForCreatingAGroup = [];

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController();
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final currentUser = ref.watch(currentUserStateProvider).valueOrNull;
    final searchUsers = ref.watch(searchUsersStateProvider);

    return CommonPageScaffold(
      centerTitle: false,
      title: "Create Group",
      child: searchUsers.when(
        data: (users) {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              // Content above the list
              const Padding(
                padding: EdgeInsets.all(8.0),
                child: Text(
                  'Selected Users for Group Chat:',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
              ),
              if (usersForCreatingAGroup.isNotEmpty)
                SizedBox(
                  height: 120, // Optional height, adjust as needed
                  child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    itemCount: usersForCreatingAGroup.length,
                    itemBuilder: (context, index) {
                      final selectedUser = usersForCreatingAGroup[index];
                      return Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 8.0),
                        child: Stack(
                          children: [
                            Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                CircleAvatar(
                                  backgroundImage:
                                      NetworkImage(selectedUser.imgUrl),
                                  radius: 30,
                                ),
                                Container(
                                    alignment: Alignment.center,
                                    width: 100,
                                    child: Text(
                                      selectedUser.email,
                                      textAlign: TextAlign.center,
                                    )),
                              ],
                            ),
                            Positioned(
                                right: 10,
                                top: 0,
                                child: GestureDetector(
                                    onTap: () => {
                                          setState(() {
                                            usersForCreatingAGroup.removeWhere(
                                                (us) =>
                                                    us.email ==
                                                    selectedUser.email);
                                          })
                                        },
                                    child: const Icon(Icons.close))),
                          ],
                        ),
                      );
                    },
                  ),
                ),
              // Divider between content and user list
              const Divider(),
              // List of users below
              Expanded(
                child: ListView.builder(
                  controller: _scrollController,
                  itemCount: users.length,
                  itemBuilder: (context, index) {
                    final user = users[index];
                    final userAdded = usersForCreatingAGroup
                        .any((usGroup) => usGroup.email == user.email);

                    return Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: ListTile(
                            leading: UserAvatar(
                              photoUrl: user.avatar,
                            ),
                            title: Text(user.name),
                          ),
                        ),
                        GestureDetector(
                          onTap: () {
                            if (!userAdded) {
                              setState(() {
                                usersForCreatingAGroup.add(GroupUser(
                                    email: user.email!, imgUrl: user.avatar));
                              });
                            } else {
                              setState(() {
                                usersForCreatingAGroup.removeWhere(
                                    (us) => us.email == user.email);
                              });
                            }
                          },
                          child: Text(userAdded
                              ? "Remove from group"
                              : "Add to group chat"),
                        ),
                      ],
                    );
                  },
                ),
              ),
              if (usersForCreatingAGroup.isNotEmpty)
                Container(
                  margin: EdgeInsets.only(bottom: 20),
                  child: HighlightButton(
                      text: "Create group",
                      onPressed: () async {
                        setState(() {
                          usersForCreatingAGroup.insert(
                              0,
                              GroupUser(
                                imgUrl: currentUser!.avatar,
                                email: currentUser.email!,
                              ));
                        });
                        ref.read(createChatProvider(usersForCreatingAGroup));
                        setState(() {
                          usersForCreatingAGroup = [];
                        });
                        AppRouter.go(
                          context,
                          RouterNames.chats,
                        );
                        // make sure the form is valid
                        // before submitting
                      }),
                ),
            ],
          );
        },
        error: (error, _) {
          return Text('Error: $error');
        },
        loading: () {
          return const Center(
            child: CircularProgressIndicator(),
          );
        },
      ),
    );
  }
}
