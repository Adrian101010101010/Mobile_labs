import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

enum RegisterStatus { initial, loading, success, failure }

class RegisterState {
  final RegisterStatus status;
  final String? errorMessage;

  const RegisterState({
    this.status = RegisterStatus.initial,
    this.errorMessage,
  });

  RegisterState copyWith({RegisterStatus? status, String? errorMessage}) {
    return RegisterState(
      status: status ?? this.status,
      errorMessage: errorMessage,
    );
  }
}

class RegisterCubit extends Cubit<RegisterState> {
  final FlutterSecureStorage _storage;

  RegisterCubit(this._storage) : super(const RegisterState());

  Future<void> register(String email, String password) async {
    if (email.isEmpty || password.isEmpty) {
      emit(
        state.copyWith(
          status: RegisterStatus.failure,
          errorMessage: 'Email and password cannot be empty',
        ),
      );
      return;
    }

    emit(state.copyWith(status: RegisterStatus.loading));

    await _storage.write(key: 'email', value: email);
    await _storage.write(key: 'password', value: password);

    emit(state.copyWith(status: RegisterStatus.success));
  }
}
