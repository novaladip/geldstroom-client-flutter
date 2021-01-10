import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:geldstroom/core/bloc/overview_balance/overview_balance_cubit.dart';
import 'package:geldstroom/core/bloc_ui/ui_bloc.dart';

import '../../../helper_tests/hydrated_bloc.dart';

class MockOverviewBalanceCubit extends MockBloc<OverviewBalanceState>
    implements OverviewBalanceCubit {}

void main() {
  initHydratedBloc();
  group('OverviewRangeCubit', () {
    OverviewRangeCubit overviewRangeCubit;
    OverviewBalanceCubit overviewBalanceCubit;

    setUp(() {
      overviewBalanceCubit = MockOverviewBalanceCubit();
      overviewRangeCubit = OverviewRangeCubit(overviewBalanceCubit);
    });

    tearDown(() {
      overviewRangeCubit.close();
    });

    test('initial state is correct', () {
      expect(overviewRangeCubit.state, OverviewRangeState.weekly());
    });

    group('toJson/fromJson', () {
      test('work properly', () {
        expect(
          overviewRangeCubit.fromJson(overviewRangeCubit.state.toJson),
          overviewRangeCubit.state,
        );

        // fromJson montly
        expect(
          OverviewRangeState.fromJson({'range': 'monthly'}),
          OverviewRangeState.monthly(),
        );
      });
    });

    group('onChangeRange', () {
      final weekly = OverviewRangeState.weekly();
      final monthly = OverviewRangeState.monthly();

      blocTest<OverviewRangeCubit, OverviewRangeState>(
        'emits correct range for OverviewRangeState.weekly',
        build: () => OverviewRangeCubit(overviewBalanceCubit),
        act: (cubit) => cubit.onChangeRange(weekly),
        expect: <OverviewRangeState>[weekly],
        verify: (cubit) {
          expect(cubit.state.currentValue, 'Weekly');
          verify(overviewBalanceCubit.fetch(weekly)).called(1);
        },
      );

      blocTest<OverviewRangeCubit, OverviewRangeState>(
        'emits correct range for OverviewRangeState.monthly',
        build: () => OverviewRangeCubit(overviewBalanceCubit),
        act: (cubit) => cubit.onChangeRange(monthly),
        expect: <OverviewRangeState>[monthly],
        verify: (cubit) {
          expect(cubit.state.currentValue, 'Monthly');
          verify(overviewBalanceCubit.fetch(monthly)).called(1);
        },
      );
    });
  });
}
