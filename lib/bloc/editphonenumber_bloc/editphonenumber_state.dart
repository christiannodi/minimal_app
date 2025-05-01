part of 'editphonenumber_bloc.dart';

@immutable
sealed class EditphonenumberState {}

final class EditphonenumberInitial extends EditphonenumberState {}

final class EditphonenumberLoading extends EditphonenumberState {}

final class EditphonenumberSuccess extends EditphonenumberState {
  final String message;

  EditphonenumberSuccess(this.message);
}

final class EditphonenumberError extends EditphonenumberState {
  final String error;

  EditphonenumberError(this.error);
}
