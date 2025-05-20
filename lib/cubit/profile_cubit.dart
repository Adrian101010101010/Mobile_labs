import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class ProfileState {
  final String email;

  ProfileState({required this.email});
}

class ProfileCubit extends Cubit<ProfileState> {
  final FlutterSecureStorage _storage;

  ProfileCubit(this._storage) : super(ProfileState(email: 'Loading...')) {
    loadEmail();
  }

  Future<void> loadEmail() async {
    final email = await _storage.read(key: 'email') ?? 'No email found';
    emit(ProfileState(email: email));
  }

  Future<void> updateEmail(String newEmail) async {
    await _storage.write(key: 'email', value: newEmail);
    emit(ProfileState(email: newEmail));
  }
}
