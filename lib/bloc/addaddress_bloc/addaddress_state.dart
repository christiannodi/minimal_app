part of 'addaddress_bloc.dart';

@immutable
sealed class AddaddressState {}

final class AddaddressInitial extends AddaddressState {}

final class AddaddressLoading extends AddaddressState {}

final class AddaddressSuccess extends AddaddressState {
  final String message;

  AddaddressSuccess(this.message);
}

final class AddaddressError extends AddaddressState {
  final String error;

  AddaddressError(this.error);
}
