import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class SecureStorage {
  static const _secureStorage = FlutterSecureStorage();
  static Future<void> setAcceessToken(String? token) async {
    await _secureStorage.write(key: 'accessToken', value: token);
  }

  static Future<String?> getAccessToken() async {
    return await _secureStorage.read(key: 'accessToken');
  }
}
