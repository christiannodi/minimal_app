part of 'deletecart_bloc.dart';

@immutable
sealed class DeletecartState {}

final class DeletecartInitial extends DeletecartState {}

final class DeletecartLoading extends DeletecartState {}

final class DeletecartSuccess extends DeletecartState {
  final String message;

  DeletecartSuccess(this.message);
}

final class DeletecartError extends DeletecartState {
  final String error;

  DeletecartError(this.error);
}
