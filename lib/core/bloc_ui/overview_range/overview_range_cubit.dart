import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:hydrated_bloc/hydrated_bloc.dart';
import 'package:injectable/injectable.dart';

import '../../bloc/bloc.dart';

part 'overview_range_cubit.freezed.dart';
part 'overview_range_state.dart';

@lazySingleton
class OverviewRangeCubit extends HydratedCubit<OverviewRangeState> {
  OverviewRangeCubit(this._overviewBalanceCubit)
      : super(OverviewRangeState.initial());

  final OverviewBalanceCubit _overviewBalanceCubit;

  void onChangeRange(OverviewRangeState newState) {
    emit(newState);
    _overviewBalanceCubit.fetch(newState);
  }

  @override
  Map<String, dynamic> toJson(OverviewRangeState state) {
    return state.toJson;
  }

  @override
  OverviewRangeState fromJson(Map<String, dynamic> json) {
    return OverviewRangeState.fromJson(json);
  }
}
