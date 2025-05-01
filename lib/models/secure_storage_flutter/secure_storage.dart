import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class SecureStorageHelper {
  final FlutterSecureStorage _storage = const FlutterSecureStorage();

  // Save a key-value pair
  Future<void> save(String key, String value) async {
    await _storage.write(key: key, value: value);
  }

  // Retrieve a value by key
  Future<String?> read(String key) async {
    return await _storage.read(key: key);
  }

  // Delete a value by key
  Future<void> delete(String key) async {
    await _storage.delete(key: key);
  }

  // Clear all storage
  Future<void> clear() async {
    await _storage.deleteAll();
  }

  Future<String?> getAccessToken() async {
    return await _storage.read(key: 'access_token');
  }

  Future<String?> getRefreshToken() async {
    return await _storage.read(key: 'refresh_token');
  }
}
