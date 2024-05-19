import 'package:task_manager/local_storage/local_storage.dart';
import 'package:task_manager/local_storage/secure_storage.dart';
import 'package:task_manager/models/user_model.dart';
import 'package:task_manager/services/api_services.dart';

class AuthRepository {
  AuthRepository() {
    getUser();
  }
  static late User user;
  static Future<User> login(String username, String password) async {
    user = await ApiClient.login(username, password);
    SecureStorage.setAcceessToken(user.token);
    await LocalStorage.saveUser(user);

    return user;
  }

  static Future<User> getUser() async {
    user = await LocalStorage.getUser();
    return user;
  }

  static Future<String?> getAccessToken() async {
    return await SecureStorage.getAccessToken();
  }
}
