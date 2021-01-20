part of 'profile_cubit.dart';

@freezed
abstract class ProfileState with _$ProfileState {
  const factory ProfileState.loadInProgress() = _ProfileStateLoadInProgress;
  const factory ProfileState.loadSucess(Profile profile) =
      _ProfileStateLoadSuccess;
  const factory ProfileState.loadFailure(ServerError error) =
      _ProfileStateLoadFailure;
}
