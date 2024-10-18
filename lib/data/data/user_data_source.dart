import 'package:brainwavesocialapp/constants/collections.dart';
import 'package:brainwavesocialapp/data/models/chat.dart';
import 'package:brainwavesocialapp/data/models/message.dart';
import 'package:firebase_cloud_firestore/firebase_cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../exceptions/app_exceptions.dart';
import '../interfaces/user_interface.dart';
import '../models/post.dart';
import '../models/userinfo.dart';

class _UserRemoteDataSource implements UserRepository {
  const _UserRemoteDataSource(
    this.databaseDataSource,
  );

  final FirebaseFirestore databaseDataSource;

  @override
  Future<void> createUser(UserInfoDataModel user) {
    try {
      return databaseDataSource
          .collection(CollectionsName.users.name)
          .doc(user.uid)
          .set(
            user.toJson(),
            SetOptions(merge: true),
          );
    } on FirebaseException catch (e) {
      throw AppFirebaseException(e.code, e.message ?? 'An error occurred');
    } catch (e) {
      throw const UnknownException();
    }
  }

  @override
  Stream<UserInfoDataModel> getExtraUserInfo(String uid) {
    return databaseDataSource
        .collection(CollectionsName.users.name)
        .doc(uid)
        .snapshots()
        .map(
          (event) => UserInfoDataModel.fromJson(
            {
              ...event.data()!,
              'uid': event.id,
            },
          ),
        );
  }

  @override
  Future<List<PostDataModel>> getUserPosts(String uid) {
    return databaseDataSource
        .collection(CollectionsName.posts.name)
        .where('ownerId', isEqualTo: uid)
        .orderBy('timestamp', descending: true)
        .limit(10)
        .withConverter(
          fromFirestore: (snapshot, _) {
            return PostDataModel.fromJson({
              ...snapshot.data()!,
              'uid': snapshot.id,
            });
          },
          toFirestore: (data, _) => data.toJson(),
        )
        .get()
        .then((value) => value.docs
            .map(
              (e) => e.data(),
            )
            .toList());
  }

  @override
  Future<List<UserInfoDataModel>> searchUsers() {
    return databaseDataSource
        .collection(
          CollectionsName.users.name,
        )
        .get()
        .then(
      (value) {
        return value.docs
            .map(
              (e) => UserInfoDataModel.fromJson(
                {
                  ...e.data(),
                  'uid': e.id,
                },
              ),
            )
            .toList();
      },
    );
  }

  @override
  Stream<List<String>?> getFollowings(
    String uid,
  ) {
    return databaseDataSource
        .collection(CollectionsName.following.name)
        .doc(uid)
        .collection(CollectionsName.users.name)
        .snapshots()
        .map(
          (event) => event.docs.map((e) => e.id).toList(),
        )
        .asBroadcastStream();
  }

  @override
  @override
  Future<void> followUser(
    String currentUserId,
    String idUserToFollow,
  ) async {
    await databaseDataSource
        .collection(CollectionsName.following.name)
        .doc(currentUserId)
        .collection(CollectionsName.users.name)
        .doc(idUserToFollow)
        .set(
      {
        'timestamp': FieldValue.serverTimestamp(),
      },
      SetOptions(merge: true),
    );

    await databaseDataSource
        .collection(CollectionsName.followers.name)
        .doc(idUserToFollow)
        .collection(CollectionsName.users.name)
        .doc(currentUserId)
        .set(
      {
        'timestamp': FieldValue.serverTimestamp(),
      },
      SetOptions(merge: true),
    );
  }

  @override
  Future<void> unFollowUser(
    String currentUserId,
    String idUserToUnfollow,
  ) async {
    await databaseDataSource
        .collection(CollectionsName.following.name)
        .doc(currentUserId)
        .collection(CollectionsName.users.name)
        .doc(idUserToUnfollow)
        .delete();

    await databaseDataSource
        .collection(CollectionsName.followers.name)
        .doc(idUserToUnfollow)
        .collection(CollectionsName.users.name)
        .doc(currentUserId)
        .delete();
  }

  @override
  Future<void> editUserProfile({
    required String uid,
    required String firstName,
    required String lastName,
    required String bio,
  }) {
    return databaseDataSource
        .collection(CollectionsName.users.name)
        .doc(uid)
        .update(
      {
        'firstName': firstName,
        'lastName': lastName,
        'bio': bio,
      },
    );
  }

  @override
  Stream<bool> userLikedAPost(String postId, String userId) {
    return databaseDataSource
        .collection(CollectionsName.posts.name)
        .doc(postId)
        .collection(CollectionsName.likes.name)
        .doc(userId)
        .snapshots()
        .map((value) => value.exists);
  }

  @override
  Future<int?> getFollowersCount(String uid) {
    return databaseDataSource
        .collection(CollectionsName.followers.name)
        .doc(uid)
        .collection(CollectionsName.users.name)
        .count()
        .get()
        .then((value) => value.count);
  }

  @override
  Future<int?> getFollowingCount(String uid) {
    return databaseDataSource
        .collection(CollectionsName.following.name)
        .doc(uid)
        .collection(CollectionsName.users.name)
        .count()
        .get()
        .then((value) => value.count);
  }

  @override
  Future<void> updateAvatarImage({required String uid, String? photoUrl}) {
    return databaseDataSource
        .collection(CollectionsName.users.name)
        .doc(uid)
        .update(
      {
        'photoUrl': photoUrl,
      },
    );
  }

  @override
  Future<void> updateCoverImage({required String uid, String? coverImageUrl}) {
    return databaseDataSource
        .collection(CollectionsName.users.name)
        .doc(uid)
        .update(
      {
        'coverImageUrl': coverImageUrl,
      },
    );
  }

  @override
  Future<void> updateUserDeviceToken(String uid, String token) {
    final ref = databaseDataSource
        .collection(
          CollectionsName.users.name,
        )
        .doc(
          uid,
        );

    return ref.set(
      {
        'deviceTokens': FieldValue.arrayUnion([token]),
      },
      SetOptions(merge: true),
    );
  }

  @override
  Stream<List<MessageDataModel>> getMessages() {
    return databaseDataSource
        .collection(CollectionsName.messages.name)
        .orderBy('timestamp', descending: false)
        .limit(50)
        .withConverter<MessageDataModel>(
          fromFirestore: MessageDataModel.fromFirestore,
          toFirestore: (post, _) => post.toJson(),
        )
        .snapshots()
        .map(
          (snapshot) => snapshot.docs
              .map(
                (e) => e.data(),
              )
              .toList(),
        );
  }

  Future<String?> getChatId(String fromUserEmail, String toUserEmail) async {
    final chatCollection =
        databaseDataSource.collection(CollectionsName.chats.name);
    final querySnapshot = await chatCollection
        .where('participants', arrayContains: fromUserEmail)
        .get();

    String? chatId;

    // // Step 2: Check if the chat exists by looking for 'toUserEmail' in the participants
    for (var doc in querySnapshot.docs) {
      List<dynamic> participants = doc['participants'];
      if (participants.contains(toUserEmail)) {
        chatId = doc.id;
        break;
      }
    }
    return chatId;
  }

  @override
  Stream<List<MessageDataModel>> getSingleChatMessages(
      String fromUserId, String toUserId) async* {
    final chatCollection = databaseDataSource.collection('chats');

    // Continuously listen for chats involving the fromUserId
    await for (var querySnapshot in chatCollection
        .where('participants', arrayContains: fromUserId)
        .snapshots()) {
      String? chatId;

      // Find the chat ID between the two users
      for (var doc in querySnapshot.docs) {
        List<String> participants =
            List<String>.from(doc.data()['participants']);
        if (participants.contains(toUserId)) {
          chatId = doc.id;
          break;
        }
      }

      if (chatId != null) {
        // Listen for messages in real-time and reset unread counts for both users
        final chatDocRef = chatCollection.doc(chatId);

        // Listen for real-time updates in the 'messages' subcollection
        yield* chatDocRef
            .collection('messages')
            .orderBy('timestamp',
                descending: false) // Order messages by timestamp
            .snapshots()
            .asyncMap((snapshot) async {
          // Fetch the chat document to check and reset the unread count
          final chatSnapshot = await chatDocRef.get();
          if (chatSnapshot.exists) {
            final chatData = chatSnapshot.data() as Map<String, dynamic>;

            // Check if unread counts need to be reset
            final unreadCount = chatData['unreadCount'] as Map<String, dynamic>;

            // If either user has unread messages, reset their counts to 0

            await chatDocRef.update({
              'unreadCount': {
                fromUserId: 0, // Reset unread count for fromUserId
                toUserId: unreadCount[toUserId]
              },
            });
          }

          // Return the list of messages
          return snapshot.docs.map((doc) {
            return MessageDataModel.fromJson({
              ...doc.data(),
              'uid': doc.id, // Add message ID to the model
            });
          }).toList();
        });
      } else {
        // If no chat found, yield an empty list
        yield [];
      }
    }
  }

  @override
  Stream<int> getUnreadChatsCount(String currentUserId) async* {
    final chatCollection = databaseDataSource.collection('chats');

    // Listen for real-time changes in the chats collection where currentUserId is a participant
    await for (var querySnapshot in chatCollection
        .where('participants', arrayContains: currentUserId)
        .snapshots()) {
      int unreadChatsCount = 0;

      // Loop through each chat document in the snapshot
      for (var doc in querySnapshot.docs) {
        final data = doc.data();

        // Check if the 'unreadCount' field exists and if currentUserId has unread messages
        if (data.containsKey('unreadCount') &&
            data['unreadCount'][currentUserId] != null) {
          final unreadCountForUser = data['unreadCount'][currentUserId];

          // Increment count if the unread count for the user is greater than 0
          if (unreadCountForUser > 0) {
            unreadChatsCount++;
          }
        }
      }

      // Emit the updated unread chats count
      yield unreadChatsCount;
    }
  }

  @override
  Stream<List<ChatDataModel>> getAllChatsForUser(String userEmail) {
    return databaseDataSource
        .collection(CollectionsName.chats.name)
        .where(
          'participants',
          arrayContains:
              userEmail, // Fetch all chats where the user is a participant
        )
        .orderBy('lastMessageTimestamp',
            descending: true) // Order by last message timestamp, descending
        .limit(100)
        .withConverter<ChatDataModel>(
          fromFirestore: (snapshot, _) => ChatDataModel.fromJson(
            {
              ...snapshot.data()!,
              'chatId': snapshot.id, // Add chatId to the model
            },
          ),
          toFirestore: (chat, _) => chat.toJson(),
        )
        .snapshots()
        .map(
          (snapshot) => snapshot.docs.map((e) => e.data()).toList(),
        );
  }

  @override
  Future<void> sendMessage(
      String fromUserEmail, String message, String toUserEmail) async {
    try {
      var chatCollection =
          databaseDataSource.collection(CollectionsName.chats.name);
      String? chatId = await getChatId(fromUserEmail, toUserEmail);

      // // Step 3: If chat does not exist, create a new one
      if (chatId == null) {
        final newChat = {
          'type': "private",
          'participants': [fromUserEmail, toUserEmail],
          'lastMessage': message,
          'lastMessageTimestamp': FieldValue.serverTimestamp(),
          'unreadCount': {
            fromUserEmail: 0, // Sender has no unread messages
            toUserEmail: 1 // Recipient has one unread message
          },
        };
        final chatDoc = await chatCollection.add(newChat);
        chatId = chatDoc.id;
      } else {
        // Step 4: If the chat exists, increment unread count for recipient
        final chatDoc = chatCollection.doc(chatId);
        // Get the current chat document data
        final chatSnapshot = await chatDoc.get();
        if (chatSnapshot.exists) {
          final chatData = chatSnapshot.data() as Map<String, dynamic>;
          final unreadCount = chatData['unreadCount'] as Map<String, dynamic>;

          // Increment the unread count for the recipient
          final newUnreadCount = unreadCount[toUserEmail] != null
              ? unreadCount[toUserEmail] + 1
              : 1;

          await chatDoc.update({
            'lastMessage': message,
            'lastMessageTimestamp': FieldValue.serverTimestamp(),
            'unreadCount': {
              fromUserEmail: 0,
              toUserEmail: newUnreadCount,
            }
          });
        }
      }

      // Step 5: Create the new message data
      final newMessage = MessageDataModel(
        uid: '',
        content: message,
        messageType: "text",
        readBy: [fromUserEmail],
        senderId: fromUserEmail,
        timestamp: DateTime.now(),
      );

      // Step 6: Add the message to the 'messages' subcollection in the chat
      final messageCollection =
          chatCollection.doc(chatId).collection('messages');
      await messageCollection
          .withConverter<MessageDataModel>(
            fromFirestore: (snapshot, _) => MessageDataModel.fromJson({
              ...snapshot.data()!,
              'uid': snapshot.id,
            }),
            toFirestore: (post, _) => post.toJson(),
          )
          .add(newMessage);
    } catch (e) {
      throw const FireBaseException();
    }
  }
}

final userDataSourceProvider = Provider(
  (ref) => _UserRemoteDataSource(FirebaseFirestore.instance),
);
