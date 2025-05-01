part of 'getorder_bloc.dart';

@immutable
sealed class GetorderpaidState {}

final class GetorderpaidInitial extends GetorderpaidState {}

final class GetorderpaidLoading extends GetorderpaidState {}

final class GetorderpaidSuccess extends GetorderpaidState {
  final List<OrderListDataModel> orderListDataModel;
  GetorderpaidSuccess(this.orderListDataModel);
}

final class GetorderpaidError extends GetorderpaidState {
  final String error;

  GetorderpaidError(this.error);
}
