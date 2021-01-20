import 'package:bloc/bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:injectable/injectable.dart';

part 'bottom_navigation_state.dart';
part 'bottom_navigation_cubit.freezed.dart';

@lazySingleton
class BottomNavigationCubit extends Cubit<BottomNavigationState> {
  BottomNavigationCubit() : super(BottomNavigationState.initial());

  void changeSelectedIndex(int value) {
    emit(BottomNavigationState(selectedIndex: value));
  }

  void clear() {
    emit(BottomNavigationState.initial());
  }
}
