import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

abstract class AuthService {
  Future<void> saveCredentials(String email, String password);
  Future<Map<String, String?>> getCredentials();
  Future<void> clearCredentials();
}

class AuthStorage extends ChangeNotifier implements AuthService {
  final FlutterSecureStorage _storage = const FlutterSecureStorage();

  String? _email;
  String? _password;

  String? get email => _email;
  String? get password => _password;

  Future<void> loadCredentials() async {
    final credentials = await getCredentials();
    _email = credentials['email'];
    _password = credentials['password'];
    notifyListeners();
  }

  @override
  Future<void> saveCredentials(String email, String password) async {
    _email = email;
    _password = password;
    await _storage.write(key: 'email', value: email);
    await _storage.write(key: 'password', value: password);
    notifyListeners();
  }

  @override
  Future<Map<String, String?>> getCredentials() async {
    final email = await _storage.read(key: 'email');
    final password = await _storage.read(key: 'password');
    return {'email': email, 'password': password};
  }

  @override
  Future<void> clearCredentials() async {
    _email = null;
    _password = null;
    await _storage.delete(key: 'email');
    await _storage.delete(key: 'password');
    notifyListeners();
  }
}
