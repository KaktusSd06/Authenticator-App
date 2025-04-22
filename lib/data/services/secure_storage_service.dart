import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class SecureStorageService {
  static final FlutterSecureStorage _storage = FlutterSecureStorage();
  static FlutterSecureStorage get instance => _storage;
}
