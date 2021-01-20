import 'package:bloc/bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:injectable/injectable.dart';

import '../../bloc/bloc.dart';

part 'bottom_navigation_cubit.freezed.dart';
part 'bottom_navigation_state.dart';

@lazySingleton
class BottomNavigationCubit extends Cubit<BottomNavigationState> {
  BottomNavigationCubit(this._authCubit)
      : super(BottomNavigationState.initial()) {
    // call clear when user logged out
    _authCubit.listen((state) {
      if (state is AuthStateUnauthenticated) {
        clear();
      }
    });
  }

  final AuthCubit _authCubit;

  void changeSelectedIndex(int value) {
    emit(BottomNavigationState(selectedIndex: value));
  }

  void clear() {
    emit(BottomNavigationState.initial());
  }
}
