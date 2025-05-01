part of 'deleteaddress_bloc.dart';

@immutable
sealed class DeleteaddressState {}

final class DeleteaddressInitial extends DeleteaddressState {}

final class DeleteaddressLoading extends DeleteaddressState {}

final class DeleteaddressSuccess extends DeleteaddressState {
  final String message;

  DeleteaddressSuccess(this.message);
}

final class DeleteaddressError extends DeleteaddressState {
  final String error;

  DeleteaddressError(this.error);
}
