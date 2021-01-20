import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:geldstroom/core/bloc/auth/auth_cubit.dart';
import 'package:geldstroom/core/bloc_ui/bottom_navigation/bottom_navigation_cubit.dart';

class MockAuthCubit extends MockBloc<AuthState> implements AuthCubit {}

void main() {
  group('BottomNavigationCubit', () {
    final authCubit = MockAuthCubit();

    blocTest<BottomNavigationCubit, BottomNavigationState>(
      'changeSelectedIndex',
      build: () => BottomNavigationCubit(authCubit),
      act: (cubit) => cubit.changeSelectedIndex(1),
      expect: [BottomNavigationState(selectedIndex: 1)],
    );
    blocTest<BottomNavigationCubit, BottomNavigationState>(
      'clear',
      build: () => BottomNavigationCubit(authCubit),
      act: (cubit) => cubit.clear(),
      expect: [BottomNavigationState.initial()],
    );

    blocTest<BottomNavigationCubit, BottomNavigationState>(
      'call clear when user logged out',
      build: () {
        whenListen(authCubit, Stream.value(AuthState.unauthenticated()));
        return BottomNavigationCubit(authCubit);
      },
      expect: [BottomNavigationState.initial()],
    );
  });
}
