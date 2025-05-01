part of 'getdetailedproduct_bloc.dart';

@immutable
sealed class GetdetailedproductState {}

final class GetdetailedproductInitial extends GetdetailedproductState {}

final class GetdetailedproductLoading extends GetdetailedproductState {}

final class GetdetailedproductSuccess extends GetdetailedproductState {
  final DetailProductDataModel detailProductDataModel;
  GetdetailedproductSuccess(this.detailProductDataModel);
}

final class GetdetailedproductError extends GetdetailedproductState {
  final String error;

  GetdetailedproductError(this.error);
}
