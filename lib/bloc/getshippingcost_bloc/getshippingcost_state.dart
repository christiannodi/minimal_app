part of 'getshippingcost_bloc.dart';

@immutable
sealed class GetshippingcostState {}

final class GetshippingcostInitial extends GetshippingcostState {}

final class GetshippingcostLoading extends GetshippingcostState {}

final class GetshippingcostSuccess extends GetshippingcostState {
  final List<ShippingcostDataModel> shippingcostDataModel; // Ubah ke List

  GetshippingcostSuccess(this.shippingcostDataModel);
}

final class GetshippingcostError extends GetshippingcostState {
  final String error;

  GetshippingcostError(this.error);
}
