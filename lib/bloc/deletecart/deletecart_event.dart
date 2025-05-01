part of 'deletecart_bloc.dart';

@immutable
sealed class DeletecartEvent {}

final class Deletecart extends DeletecartEvent {
  final int cartId;
  Deletecart(this.cartId);
}