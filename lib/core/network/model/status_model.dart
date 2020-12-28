import 'package:freezed_annotation/freezed_annotation.dart';

import 'model.dart';

part 'status_model.freezed.dart';

@freezed
abstract class FormStatus with _$FormStatus {
  const factory FormStatus.idle() = FormStatusIdle;
  const factory FormStatus.loading() = FormStatusLoading;
  const factory FormStatus.success() = FormStatusSuccess;
  const factory FormStatus.error({@required ServerError error}) =
      FormStatusError;
}

@freezed
abstract class FetchStatus<T> with _$FetchStatus<T> {
  const factory FetchStatus.initial() = FetchStatusInitial;
  const factory FetchStatus.loading() = FetchStatusLoading;
  const factory FetchStatus.loaded({
    @required T data,
    @required StatusLoaded status,
  }) = FetchStatusLoaded;
  const factory FetchStatus.error({
    @required ServerError error,
  }) = FetchStatusError;
}

enum StatusLoadedErrorType { refresh, fetchmore }

@freezed
abstract class StatusLoaded with _$StatusLoaded {
  const factory StatusLoaded.refresh() = StatusLoadedRefresh;
  const factory StatusLoaded.fetchMore() = StatusLoadedFetchMore;
  const factory StatusLoaded.error({
    @required StatusLoadedErrorType type,
    @required ServerError error,
  }) = StatusLoadedError;
}
