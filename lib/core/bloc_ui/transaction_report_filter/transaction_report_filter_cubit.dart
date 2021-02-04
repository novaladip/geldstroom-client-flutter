import 'package:bloc/bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:injectable/injectable.dart';
import 'package:jiffy/jiffy.dart';

part 'transaction_report_filter_state.dart';
part 'transaction_report_filter_cubit.freezed.dart';

@lazySingleton
class TransactionReportFilterCubit extends Cubit<TransactionReportFilterState> {
  TransactionReportFilterCubit()
      : super(TransactionReportFilterState.initial());

  void changeStart(DateTime start) {
    if (start.isAfter(state.end) || start.isAtSameMomentAs(state.end)) {
      emit(
        state.copyWith(
          start: start,
          end: start.add(Duration(days: 1)),
        ),
      );
      return;
    }

    emit(state.copyWith(start: start));
  }

  void changeEnd(DateTime end) {
    if (state.start.isAfter(end) || state.start.isAtSameMomentAs(end)) return;
    emit(state.copyWith(end: end));
  }

  void clear() {
    emit(TransactionReportFilterState.initial());
  }
}
