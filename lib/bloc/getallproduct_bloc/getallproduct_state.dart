part of 'getallproduct_bloc.dart';

@immutable
sealed class GetallproductState {}

final class GetallproductInitial extends GetallproductState {}

final class GetallproductLoading extends GetallproductState {}

final class GetallproductSuccess extends GetallproductState {
  final List<ProductDataModel> productDataModel;
  GetallproductSuccess(this.productDataModel);
}
//?tambahkan List jika hasilnya berupa list

final class GetallproductError extends GetallproductState {
  final String error;

  GetallproductError(this.error);
}
