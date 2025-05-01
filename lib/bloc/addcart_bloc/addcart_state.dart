part of 'addcart_bloc.dart';

@immutable
sealed class AddcartState {}

final class AddcartInitial extends AddcartState {}

final class AddcartLoading extends AddcartState {}

final class AddcartSuccess extends AddcartState {
  final String message;

  AddcartSuccess(this.message);
}

final class AddcartError extends AddcartState {
  final String error;

  AddcartError(this.error);
}
