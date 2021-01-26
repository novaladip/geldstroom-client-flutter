part of 'request_category_cubit.dart';

@freezed
abstract class RequestCategoryState with _$RequestCategoryState {
  const factory RequestCategoryState({
    @required FetchStatus status,
    @required List<RequestCategory> data,
  }) = _RequestCategoryState;

  factory RequestCategoryState.initial() => RequestCategoryState(
        status: FetchStatus.initial(),
        data: [],
      );
}
