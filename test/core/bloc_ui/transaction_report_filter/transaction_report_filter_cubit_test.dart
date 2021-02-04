// ignore_for_file: lines_longer_than_80_chars
import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:geldstroom/core/bloc_ui/transaction_report_filter/transaction_report_filter_cubit.dart';
import 'package:jiffy/jiffy.dart';

void main() {
  group('TransactionReportFilterCubit', () {
    final today = Jiffy().startOf(Units.DAY);

    blocTest<TransactionReportFilterCubit, TransactionReportFilterState>(
      'changeStart',
      build: () => TransactionReportFilterCubit(),
      act: (cubit) => cubit.changeStart(today),
      expect: [TransactionReportFilterState.initial().copyWith(start: today)],
    );

    blocTest<TransactionReportFilterCubit, TransactionReportFilterState>(
      'changeStart with same value as end',
      build: () => TransactionReportFilterCubit(),
      act: (cubit) => cubit
        ..changeEnd(today)
        ..changeStart(today),
      expect: [
        TransactionReportFilterState.initial().copyWith(end: today),
        TransactionReportFilterState.initial()
            .copyWith(start: today, end: today.add(Duration(days: 1))),
      ],
    );

    blocTest<TransactionReportFilterCubit, TransactionReportFilterState>(
      'changeEnd',
      build: () => TransactionReportFilterCubit(),
      act: (cubit) => cubit.changeEnd(today.add(Duration(days: 7))),
      expect: [
        TransactionReportFilterState.initial()
            .copyWith(end: today.add(Duration(days: 7)))
      ],
    );

    blocTest<TransactionReportFilterCubit, TransactionReportFilterState>(
      'changeEnd, not emitting a new state when new end is less or equal to start',
      build: () => TransactionReportFilterCubit(),
      act: (cubit) => cubit.changeEnd(today),
      expect: [TransactionReportFilterState.initial().copyWith(end: today)],
    );

    blocTest<TransactionReportFilterCubit, TransactionReportFilterState>(
      'clear',
      build: () => TransactionReportFilterCubit(),
      act: (cubit) => cubit.clear(),
      expect: [TransactionReportFilterState.initial()],
    );
  });
}
