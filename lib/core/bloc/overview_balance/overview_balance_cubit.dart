import 'package:bloc/bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:injectable/injectable.dart';

import '../../bloc_ui/overview_range/overview_range_cubit.dart';
import '../../network/network.dart';
import '../../network/service/service.dart';
import '../bloc.dart';

part 'overview_balance_cubit.freezed.dart';
part 'overview_balance_state.dart';

@lazySingleton
class OverviewBalanceCubit extends Cubit<OverviewBalanceState> {
  OverviewBalanceCubit(
    this._service,
    this._overviewRangeCubit,
    this._transactionEditCubit,
    this._transactionDeleteCubit,
    this._authCubit,
  ) : super(OverviewBalanceState.initial()) {
    _overviewRangeCubit.listen((overviewRangeState) {
      fetch();
    });

    _transactionEditCubit.listen((transactionEditState) {
      transactionEditState.maybeWhen(
        success: (_) => fetch(),
        orElse: () {},
      );
    });

    _authCubit.listen((authState) {
      authState.maybeWhen(
        unauthenticated: clear,
        orElse: () {},
      );
    });

    _transactionDeleteCubit.listen(
      (transactionDeleteState) {
        // if onDeleteSuccessIds is not equal to lastDeletedIds, then fetch data
        if (_prevTransactionDeleteState != transactionDeleteState &&
            transactionDeleteState
                .shouldListenDeleteSuccess(_prevTransactionDeleteState)) {
          _prevTransactionDeleteState = transactionDeleteState;
          fetch();
        }
      },
    );
  }
  var _prevTransactionDeleteState = TransactionDeleteState.initial();
  final ITransactionService _service;
  final AuthCubit _authCubit;
  final OverviewRangeCubit _overviewRangeCubit;
  final TransactionEditCubit _transactionEditCubit;
  final TransactionDeleteCubit _transactionDeleteCubit;

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
