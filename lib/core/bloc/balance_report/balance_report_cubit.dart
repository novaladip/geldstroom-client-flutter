import 'package:bloc/bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:injectable/injectable.dart';

import '../../bloc_ui/ui_bloc.dart';
import '../../network/dto/dto.dart';
import '../../network/model/model.dart';
import '../../network/service/service.dart';
import '../bloc.dart';

part 'balance_report_cubit.freezed.dart';
part 'balance_report_state.dart';

@lazySingleton
class BalanceReportCubit extends Cubit<BalanceReportState> {
  BalanceReportCubit(
    this._service,
    this._authCubit,
    this._transactionReportFilterCubit,
  ) : super(BalanceReportState.initial()) {
    _authCubit.listen((state) {
      // call clear when user loggedout
      if (state is AuthStateUnauthenticated) clear();
    });

    _transactionReportFilterCubit.listen((state) {
      // call fetch everytime TransactionReportFilterState is changed
      fetch();
    });
  }

  final ITransactionService _service;
  final AuthCubit _authCubit;
  final TransactionReportFilterCubit _transactionReportFilterCubit;

  BalanceFilterDto get _dto => BalanceFilterDto(
        categoryId: 'ALL',
        start: _transactionReportFilterCubit.state.start,
        end: _transactionReportFilterCubit.state.end,
      );

  Future<void> fetch() async {
    emit(state.copyWith(status: FetchStatus.loadInProgress()));
    final result = await _service.getBalanceReport(_dto);
    result.fold(
      (l) {
        emit(state.copyWith(status: FetchStatus.loadFailure(error: l)));
      },
      (r) {
        emit(state.copyWith(status: FetchStatus.loadSuccess(), data: r));
      },
    );
  }

  void clear() {
    emit(BalanceReportState.initial());
  }
}
