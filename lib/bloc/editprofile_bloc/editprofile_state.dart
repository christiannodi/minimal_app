part of 'editprofile_bloc.dart';

@immutable
sealed class EditprofileState {}

final class EditprofileInitial extends EditprofileState {}

final class EditprofileLoading extends EditprofileState {}

final class EditprofileSuccess extends EditprofileState {
  final String message;

  EditprofileSuccess(this.message);
}

final class EditprofileError extends EditprofileState {
  final String error;

  EditprofileError(this.error);
}
