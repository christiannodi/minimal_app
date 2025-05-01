part of 'getallcart_bloc.dart';

@immutable
sealed class GetallcartState {}

final class GetallcartInitial extends GetallcartState {}

final class GetallcartLoading extends GetallcartState {}

final class GetallcartSuccess extends GetallcartState {
  final List<CartDataModel> cartDataModel;
  GetallcartSuccess(this.cartDataModel);
}

final class GetallcartError extends GetallcartState {
  final String error;

  GetallcartError(this.error);
}
