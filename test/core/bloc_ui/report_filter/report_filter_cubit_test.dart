// ignore_for_file: lines_longer_than_80_chars
import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:geldstroom/core/bloc_ui/ui_bloc.dart';
import 'package:jiffy/jiffy.dart';

void main() {
  group('ReportFilterCubit', () {
    final today = Jiffy().startOf(Units.DAY);

    blocTest<ReportFilterCubit, ReportFilterState>(
      'changeStart',
      build: () => ReportFilterCubit(),
      act: (cubit) => cubit.changeStart(today),
      expect: [ReportFilterState.initial().copyWith(start: today)],
    );

    blocTest<ReportFilterCubit, ReportFilterState>(
      'changeStart with same value as end',
      build: () => ReportFilterCubit(),
      act: (cubit) => cubit
        ..changeEnd(today)
        ..changeStart(today),
      expect: [
        ReportFilterState.initial().copyWith(end: today),
        ReportFilterState.initial()
            .copyWith(start: today, end: today.add(Duration(days: 1))),
      ],
    );

    blocTest<ReportFilterCubit, ReportFilterState>(
      'changeEnd',
      build: () => ReportFilterCubit(),
      act: (cubit) => cubit.changeEnd(today.add(Duration(days: 7))),
      expect: [
        ReportFilterState.initial().copyWith(end: today.add(Duration(days: 7)))
      ],
    );

    blocTest<ReportFilterCubit, ReportFilterState>(
      'changeEnd, not emitting a new state when new end is less or equal to start',
      build: () => ReportFilterCubit(),
      act: (cubit) => cubit.changeEnd(today),
      expect: [ReportFilterState.initial().copyWith(end: today)],
    );

    blocTest<ReportFilterCubit, ReportFilterState>(
      'clear',
      build: () => ReportFilterCubit(),
      act: (cubit) => cubit.clear(),
      expect: [ReportFilterState.initial()],
    );
  });
}
