import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:geldstroom/core/bloc/auth/auth_cubit.dart';
import 'package:geldstroom/core/bloc/balance_report/balance_report_cubit.dart';
import 'package:geldstroom/core/bloc_ui/bottom_navigation/bottom_navigation_cubit.dart';
import 'package:mockito/mockito.dart';

class MockAuthCubit extends MockBloc<AuthState> implements AuthCubit {}

class MockBalanceReportCubit extends MockBloc<BalanceReportState>
    implements BalanceReportCubit {}

void main() {
  group('BottomNavigationCubit', () {
    AuthCubit authCubit;
    BalanceReportCubit balanceReportCubit;
    BottomNavigationCubit subject;

    setUp(() {
      authCubit = MockAuthCubit();
      balanceReportCubit = MockBalanceReportCubit();
      subject = BottomNavigationCubit(
        balanceReportCubit,
        authCubit: authCubit,
      );
    });

    tearDown(() {
      authCubit.close();
      balanceReportCubit.close();
      subject.close();
    });

    blocTest<BottomNavigationCubit, BottomNavigationState>(
      'changeSelectedIndex',
      build: () => subject,
      act: (cubit) => cubit.changeSelectedIndex(1),
      expect: [
        BottomNavigationState(selectedIndex: 1),
      ],
    );

    blocTest<BottomNavigationCubit, BottomNavigationState>(
      'call balanceReportCubit.refresh when ReportPage is selected',
      build: () => subject,
      act: (cubit) => cubit
        ..changeSelectedIndex(1)
        ..changeSelectedIndex(2)
        ..changeSelectedIndex(1),
      wait: Duration(seconds: 1),
      expect: [
        BottomNavigationState(selectedIndex: 1),
        BottomNavigationState(selectedIndex: 2),
        BottomNavigationState(selectedIndex: 1),
      ],
      verify: (_) {
        verify(balanceReportCubit.refresh()).called(1);
      },
    );
    blocTest<BottomNavigationCubit, BottomNavigationState>(
      'clear',
      seed: BottomNavigationState(selectedIndex: 2),
      build: () => subject,
      act: (cubit) => cubit.clear(),
      expect: [BottomNavigationState.initial()],
    );

    blocTest<BottomNavigationCubit, BottomNavigationState>(
      'call clear when user logged out',
      build: () {
        whenListen(authCubit, Stream.value(AuthState.unauthenticated()));
        return BottomNavigationCubit(
          balanceReportCubit,
          authCubit: authCubit,
        );
      },
      expect: [BottomNavigationState.initial()],
    );
  });
}
