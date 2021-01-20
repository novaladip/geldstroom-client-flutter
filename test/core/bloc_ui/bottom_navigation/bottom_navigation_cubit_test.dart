import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:geldstroom/core/bloc_ui/bottom_navigation/bottom_navigation_cubit.dart';

void main() {
  group('BottomNavigationCubit', () {
    blocTest<BottomNavigationCubit, BottomNavigationState>(
      'changeSelectedIndex',
      build: () => BottomNavigationCubit(),
      act: (cubit) => cubit.changeSelectedIndex(1),
      expect: [BottomNavigationState(selectedIndex: 1)],
    );
    blocTest<BottomNavigationCubit, BottomNavigationState>(
      'clear',
      build: () => BottomNavigationCubit(),
      act: (cubit) => cubit.clear(),
      expect: [BottomNavigationState.initial()],
    );
  });
}
