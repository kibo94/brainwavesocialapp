import 'package:brainwavesocialapp/constants/collections.dart';

class ChatUtils {
  static Future<String?> getChatId(
      String fromUserEmail, String toUserEmail, databaseDataSource) async {
    final chatCollection =
        databaseDataSource.collection(CollectionsName.chats.name);
    final querySnapshot = await chatCollection
        .where('type', isNotEqualTo: 'group')
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
}
