part of 'getalladdress_bloc_bloc.dart';

@immutable
sealed class GetalladdressState {}

final class GetalladdressInitial extends GetalladdressState {}

final class GetalladdressLoading extends GetalladdressState {}

final class GetalladdressSuccess extends GetalladdressState {
  final List<AddressDataModel> addressDataModel;
  GetalladdressSuccess(this.addressDataModel);
}

final class GetalladdressError extends GetalladdressState {
  final String error;

  GetalladdressError(this.error);
}
