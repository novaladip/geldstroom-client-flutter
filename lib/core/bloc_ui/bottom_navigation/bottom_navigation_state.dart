part of 'bottom_navigation_cubit.dart';

@freezed
abstract class BottomNavigationState with _$BottomNavigationState {
  const factory BottomNavigationState({
    @required int selectedIndex,
  }) = _BottomNavigationState;

  factory BottomNavigationState.initial() => BottomNavigationState(
        selectedIndex: 0,
      );
}
