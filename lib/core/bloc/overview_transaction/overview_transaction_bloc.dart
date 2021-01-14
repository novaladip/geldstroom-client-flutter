import 'package:bloc/bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:injectable/injectable.dart';
import 'package:rxdart/rxdart.dart';

import '../../bloc_ui/ui_bloc.dart';
import '../../network/model/model.dart';
import '../../network/network.dart';
import '../bloc.dart';

part 'overview_transaction_bloc.freezed.dart';
part 'overview_transaction_event.dart';
part 'overview_transaction_state.dart';

@lazySingleton
class OverviewTransactionBloc
    extends Bloc<OverviewTransactionEvent, OverviewTransactionState> {
  OverviewTransactionBloc(
    this._service,
    this._authCubit,
    this._overviewRangeCubit,
  ) : super(OverviewTransactionState()) {
    // listen for Authstate
    // reset state to inital when AuthState is unauthenticated
    _authCubit.listen((authState) {
      authState.maybeWhen(
        unauthenticated: () => add(OverviewTransactionEvent.clear()),
        orElse: () {},
      );
    });

    // listen for OverviewRangeState
    // add OverviewTransactionEvent.fetch everytime the
    // OverviewRangeState changed
    _overviewRangeCubit.listen((state) {
      add(OverviewTransactionEvent.fetch());
    });
  }

  final ITransactionService _service;
  final AuthCubit _authCubit;
  final OverviewRangeCubit _overviewRangeCubit;

  GetTransactionDto get _dto =>
      _overviewRangeCubit.state.when<GetTransactionDto>(
        monthly: () => GetTransactionDto.monthly(offset: state.data.length),
        weekly: () => GetTransactionDto.weekly(offset: state.data.length),
      );

  @override
  Stream<Transition<OverviewTransactionEvent, OverviewTransactionState>>
      transformEvents(
    Stream<OverviewTransactionEvent> events,
    Stream<Transition<OverviewTransactionEvent, OverviewTransactionState>>
            Function(OverviewTransactionEvent)
        transitionFn,
  ) {
    final nonDebounceStream = events.where((event) => event is! _FetchMore);
    final debounceStream = events
        .where((event) => event is _FetchMore)
        .debounceTime(Duration(milliseconds: 300));
    return super.transformEvents(
      MergeStream([nonDebounceStream, debounceStream]),
      transitionFn,
    );
  }

  @override
  Stream<OverviewTransactionState> mapEventToState(
    OverviewTransactionEvent event,
  ) async* {
    yield* event.when<Stream<OverviewTransactionState>>(
      fetch: _mapOnFetch,
      add: _mapOnAdd,
      delete: _mapOnDelete,
      fetchMore: _mapOnFetchMore,
      clear: _onClear,
    );
  }

  Stream<OverviewTransactionState> _onClear() async* {
    yield OverviewTransactionState();
  }

  Stream<OverviewTransactionState> _mapOnAdd(Transaction transaction) async* {
    yield state.copyWith(
      data: [transaction, ...state.data],
    );
  }

  Stream<OverviewTransactionState> _mapOnDelete(String id) async* {
    final newData = state.data.where((data) => data.id != id).toList();
    yield state.copyWith(data: newData);
  }

  Stream<OverviewTransactionState> _mapOnFetch() async* {
    yield state.copyWith(status: FetchStatus.loadInProgress());
    final dto = _dto.copyWith(offset: 0);
    final result = await _service.getTransactions(dto);
    yield* result.fold(
      (l) async* {
        yield state.copyWith(status: FetchStatus.loadFailure(error: l));
      },
      (r) async* {
        yield state.copyWith(
          data: r,
          status: FetchStatus.loadSuccess(),
          isReachEnd: r.length < 15,
        );
      },
    );
  }

  Stream<OverviewTransactionState> _mapOnFetchMore() async* {
    // immediately end the process if current status is FetchMoreInProgress
    // or isReachEnd is true
    if (state.status is FetchStatusFetchMoreInProgress) return;
    if (state.isReachEnd) return;

    yield state.copyWith(status: FetchStatus.fetchMoreInProgress());
    final result = await _service.getTransactions(
      _dto.copyWith(offset: state.data.length),
    );
    yield* result.fold(
      (l) async* {
        yield state.copyWith(status: FetchStatus.fetchMoreFailure(error: l));
      },
      (r) async* {
        yield state.copyWith(
          data: [...state.data, ...r],
          isReachEnd: r.length < 15,
        );
      },
    );
    yield state.copyWith(status: FetchStatus.loadSuccess());
  }
}
