import 'package:dismantlorapp/main.dart';
import 'package:dismantlorapp/src/user/user_config.dart';

class UserHelper {
  static void setUserId(String userId) {
    getIt<UserConfig>().setUserId(userId);
  }

  static String getUserId() {
    return getIt<UserConfig>().getUserId();
  }
}