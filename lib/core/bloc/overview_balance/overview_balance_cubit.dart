import 'package:bloc/bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:geldstroom/core/bloc/auth/auth_cubit.dart';
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
    this._overviewRangeCubit,
    this._authCubit,
  ) : super(OverviewBalanceState.initial()) {
    _overviewRangeCubit.listen((overviewRangeState) {
      fetch();
    });

    _authCubit.listen((authState) {
      authState.maybeWhen(
        unauthenticated: clear,
        orElse: () {},
      );
    });
  }

  final ITransactionService _service;
  final OverviewRangeCubit _overviewRangeCubit;
  final AuthCubit _authCubit;

  Future<void> fetch() async {
    emit(state.copyWith(status: Status.loading()));
    final dto = GetBalanceDto(
      categoryId: 'ALL',
      start: _overviewRangeCubit.state.dateRange.start,
      end: _overviewRangeCubit.state.dateRange.end,
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
