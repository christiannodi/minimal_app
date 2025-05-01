part of 'addorder_bloc.dart';

@immutable
sealed class AddorderState {}

final class AddorderInitial extends AddorderState {}

final class AddorderLoading extends AddorderState {}

final class AddorderSuccess extends AddorderState {
  final String message;

  AddorderSuccess(this.message);
}

final class AddorderError extends AddorderState {
  final String error;

  AddorderError(this.error);
}
