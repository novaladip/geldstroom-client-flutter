part of 'overview_range_cubit.dart';

@freezed
abstract class OverviewRangeState with _$OverviewRangeState {
  const factory OverviewRangeState.weekly() = _Weekly;
  const factory OverviewRangeState.monthly() = _Monthly;

  factory OverviewRangeState.initial() => OverviewRangeState.weekly();

  factory OverviewRangeState.fromJson(Map<String, dynamic> json) {
    if (json['range'] == 'weekly') {
      return OverviewRangeState.weekly();
    }
    return OverviewRangeState.monthly();
  }
}

extension OverviewRangeStateX on OverviewRangeState {
  String get currentValue => when<String>(
        weekly: () => 'weekly',
        monthly: () => 'monthly',
      );

  Map<String, dynamic> get toJson => {
        'range': when<String>(
          weekly: () => 'weekly',
          monthly: () => 'monthly',
        ),
      };
}
