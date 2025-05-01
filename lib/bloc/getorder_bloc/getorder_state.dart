part of 'getorder_bloc.dart';

@immutable
sealed class GetorderState {}

final class GetorderInitial extends GetorderState {}

final class GetorderLoading extends GetorderState {}

final class GetorderSuccess extends GetorderState {
  final List<OrderListDataModel> orderListDataModel;
  GetorderSuccess(this.orderListDataModel);
}

final class GetorderError extends GetorderState {
  final String error;

  GetorderError(this.error);
}
