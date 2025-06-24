import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

sealed class ProfileState {}

class ProfileLoading extends ProfileState {}

class ProfileLoaded extends ProfileState {
  final String email;
  ProfileLoaded(this.email);
}

class ProfileError extends ProfileState {
  final String message;
  ProfileError(this.message);
}

class ProfileCubit extends Cubit<ProfileState> {
  final FlutterSecureStorage _storage;

  ProfileCubit(this._storage) : super(ProfileLoading()) {
    loadEmail();
  }

  Future<void> loadEmail() async {
    emit(ProfileLoading());
    try {
      final email = await _storage.read(key: 'email');
      if (email == null) {
        emit(ProfileError('Email not found'));
      } else {
        emit(ProfileLoaded(email));
      }
    } catch (e) {
      emit(ProfileError('Failed to load email: $e'));
    }
  }

  Future<void> updateEmail(String newEmail) async {
    try {
      await _storage.write(key: 'email', value: newEmail);
      emit(ProfileLoaded(newEmail));
    } catch (e) {
      emit(ProfileError('Failed to update email: $e'));
    }
  }
}
