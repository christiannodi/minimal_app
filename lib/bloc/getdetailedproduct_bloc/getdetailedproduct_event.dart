part of 'getdetailedproduct_bloc.dart';

@immutable
sealed class GetdetailedproductEvent {}

final class Getdetailproduct extends GetdetailedproductEvent {
  final int productId;
  Getdetailproduct(this.productId);
}
