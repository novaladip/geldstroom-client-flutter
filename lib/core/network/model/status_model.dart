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
abstract class FormStatusData<Data> with _$FormStatusData<Data> {
  const factory FormStatusData.idle() = FormStatusDataIdle;
  const factory FormStatusData.loading() = FormStatusDataLoading;
  const factory FormStatusData.success({@required Data data}) =
      FormStatusDataSuccess;
  const factory FormStatusData.error({@required ServerError error}) =
      FormStatusDataError;
}

@freezed
abstract class FetchStatus with _$FetchStatus {
  const factory FetchStatus.initial() = FetchStatusInitial;
  const factory FetchStatus.loadInProgress() = FetchStatusLoadInProgress;
  const factory FetchStatus.loadSuccess() = FetchStatusLoadSuccess;
  const factory FetchStatus.loadFailure({@required ServerError error}) =
      FetchStatusLoadFailure;
  const factory FetchStatus.refreshInProgress() = FetchStatusRefreshInProgress;
  const factory FetchStatus.refreshFailure({@required ServerError error}) =
      FetchStatusRefreshFailure;
  const factory FetchStatus.fetchMoreInProgress() =
      FetchStatusFetchMoreInProgress;
  const factory FetchStatus.fetchMoreFailure({@required ServerError error}) =
      FetchStatusFetchMoreFailure;
}
