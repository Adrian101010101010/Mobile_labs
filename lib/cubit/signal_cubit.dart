import 'package:flutter_bloc/flutter_bloc.dart';

class SignalCubit extends Cubit<List<String>> {
  SignalCubit() : super([]);

  void addEvent(String event) {
    emit([...state, event]);
  }

  void clearEvents() {
    emit([]);
  }

  void loadInitialEvents(List<String> initialEvents) {
    emit(initialEvents);
  }
}
