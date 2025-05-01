part of 'editaddress_bloc.dart';

@immutable
sealed class EditaddressState {}

final class EditaddressInitial extends EditaddressState {}

final class EditaddressLoading extends EditaddressState {}

final class EditaddressSuccess extends EditaddressState {
  final String message;

  EditaddressSuccess(this.message);
}

final class EditaddressError extends EditaddressState {
  final String error;

  EditaddressError(this.error);
}
