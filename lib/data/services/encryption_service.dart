import 'dart:convert';
import 'dart:math';
import 'package:encrypt/encrypt.dart' as encrypt;
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class EncryptionService {
  static const _keyStorageKey = 'encryption_key';
  final _secureStorage = const FlutterSecureStorage();

  Future<encrypt.Encrypter> _getEncrypter() async {
    String? key = await _secureStorage.read(key: _keyStorageKey);

    if (key == null) {
      final newKey = List<int>.generate(32, (_) => Random.secure().nextInt(256));
      key = base64UrlEncode(newKey);
      await _secureStorage.write(key: _keyStorageKey, value: key);
    }

    final keyBytes = base64Url.decode(key);
    final aesKey = encrypt.Key(keyBytes);
    return encrypt.Encrypter(encrypt.AES(aesKey));
  }

  Future<String> encryptText(String plainText) async {
    final encrypter = await _getEncrypter();
    final iv = encrypt.IV.fromLength(16);
    final encrypted = encrypter.encrypt(plainText, iv: iv);
    return encrypted.base64;
  }

  Future<String> decryptText(String encryptedText) async {
    final encrypter = await _getEncrypter();
    final iv = encrypt.IV.fromLength(16);
    return encrypter.decrypt64(encryptedText, iv: iv);
  }
}
