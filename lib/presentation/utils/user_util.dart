import 'package:brainwavesocialapp/domain/domain.dart';

class UserUtil {
  static bool isUserBlocked(AppUser currentUser, AppUser user) {
    return currentUser.isBlockBy!.contains(user.email);
  }
}
