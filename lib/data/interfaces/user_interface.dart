import 'package:brainwavesocialapp/data/models/chat.dart';
import 'package:brainwavesocialapp/data/models/chat_group.dart';
import 'package:brainwavesocialapp/data/models/message.dart';
import '../models/post.dart';
import '../models/userinfo.dart';

abstract interface class UserRepository {
  Stream<UserInfoDataModel> getExtraUserInfo(String uid);
  Future<void> createUser(UserInfoDataModel user);
  Future<List<PostDataModel>> getUserPosts(String uid);
  Stream<List<String>?> getFollowings(String uid);
  Future<void> followUser(String currentUserId, String idUserToFollow);
  Future<void> unFollowUser(String currentUserId, String idUserToUnfollow);
  Stream<bool> userLikedAPost(String postId, String userId);

  Future<List<UserInfoDataModel>> searchUsers();
  Future<void> editUserProfile({
    required String uid,
    required String firstName,
    required String lastName,
    required String bio,
  });
  Future<int?> getFollowersCount(String uid);
  Future<int?> getFollowingCount(String uid);
  Future<void> updateUserDeviceToken(String uid, String token);
  Future<void> updateAvatarImage({
    required String uid,
    String? photoUrl,
  });
  Future<void> updateCoverImage({
    required String uid,
    String? coverImageUrl,
  });
  Future<void> createChatGroup(List<GroupUser> usersForCreatingAGroup);
  Future<void> sendMessage(
      String userId, String message, String userEmail, String groupId);
  Stream<List<MessageDataModel>> getMessages();
  Stream<List<MessageDataModel>> getSingleChatMessages(
    String fromUserId,
    String toUserId,
    bool isChatGroup,
    String chatGroupId,
  );
  Stream<List<ChatDataModel>> getAllChatsForUser(String userEmail);
  Stream<int> getUnreadChatsCount(String currentUser);
}
