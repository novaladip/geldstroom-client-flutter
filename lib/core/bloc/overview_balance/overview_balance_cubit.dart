import 'package:bloc/bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:injectable/injectable.dart';

import '../../bloc_ui/overview_range/overview_range_cubit.dart';
import '../../network/network.dart';
import '../../network/service/service.dart';

part 'overview_balance_cubit.freezed.dart';
part 'overview_balance_state.dart';

@lazySingleton
class OverviewBalanceCubit extends Cubit<OverviewBalanceState> {
  OverviewBalanceCubit(
    this._service,
  ) : super(OverviewBalanceState.initial());

  final ITransactionService _service;

  Future<void> fetch(OverviewRangeState overviewRangeState) async {
    emit(state.copyWith(status: Status.loading()));
    var dto = overviewRangeState.when<GetBalanceDto>(
      monthly: () => GetBalanceDto.monthly(),
      weekly: () => GetBalanceDto.weekly(),
    );
    final result = await _service.getBalance(dto);
    result.fold((l) {
      emit(state.copyWith(status: Status.error(error: l)));
    }, (r) {
      emit(state.copyWith(status: Status.loaded(), data: r));
    });
  }

  void clear() {
    emit(OverviewBalanceState.initial());
  }
}
