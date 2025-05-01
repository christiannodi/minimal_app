part of 'getuserdata_bloc.dart';

@immutable
sealed class GetuserdataState {}

final class GetuserdataInitial extends GetuserdataState {}

final class GetuserdataLoading extends GetuserdataState {}

final class GetuserdataSuccess extends GetuserdataState {
  final UserDataModel userDataModel;
  GetuserdataSuccess(this.userDataModel);
}

final class GetuserdataError extends GetuserdataState {
  final String error;

  GetuserdataError(this.error);
}
