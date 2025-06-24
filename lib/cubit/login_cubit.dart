import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

enum LoginStatus { initial, loading, success, failure }

class LoginState {
  final LoginStatus status;
  final String? errorMessage;

  LoginState({required this.status, this.errorMessage});

  factory LoginState.initial() => LoginState(status: LoginStatus.initial);
  factory LoginState.loading() => LoginState(status: LoginStatus.loading);
  factory LoginState.success() => LoginState(status: LoginStatus.success);
  factory LoginState.failure(String message) =>
      LoginState(status: LoginStatus.failure, errorMessage: message);
}

class LoginCubit extends Cubit<LoginState> {
  final FlutterSecureStorage _storage;

  LoginCubit(this._storage) : super(LoginState.initial());

  Future<void> login(String email, String password) async {
    if (email.isEmpty || password.isEmpty) {
      emit(LoginState.failure('Please enter email and password'));
      return;
    }

    emit(LoginState.loading());

    try {
      final savedEmail = await _storage.read(key: 'email');
      final savedPassword = await _storage.read(key: 'password');

      if (email == savedEmail && password == savedPassword) {
        emit(LoginState.success());
      } else {
        emit(LoginState.failure('Invalid email or password'));
      }
    } catch (e) {
      emit(LoginState.failure('An error occurred: $e'));
    }
  }
}
