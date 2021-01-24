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
    this._transactionCreateCubit,
    this._transactionEditCubit,
    this._transactionDeleteCubit,
    this._authCubit,
  ) : super(OverviewBalanceState.initial()) {
    _authCubit.listen((authState) {
      authState.maybeWhen(
        unauthenticated: clear,
        orElse: () {},
      );
    });

    _overviewRangeCubit.listen((overviewRangeState) {
      fetch();
    });

    _transactionCreateCubit.listen((transactionCreateState) {
      if (transactionCreateState is FormStatusDataSuccess<Transaction>) {
        fetch();
      }
    });

    _transactionEditCubit.listen((transactionEditState) {
      transactionEditState.maybeWhen(
        success: (_) => fetch(),
        orElse: () {},
      );
    });

    _transactionDeleteCubit.listen(
      (transactionDeleteState) {
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
  final TransactionCreateCubit _transactionCreateCubit;
  final TransactionEditCubit _transactionEditCubit;
  final TransactionDeleteCubit _transactionDeleteCubit;

  Future<void> fetch() async {
    emit(state.copyWith(status: Status.loading()));
    final dto = BalanceFilterDto(
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
