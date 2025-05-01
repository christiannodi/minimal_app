part of 'paynow_bloc.dart';

@immutable
sealed class PaynowState {}

final class PaynowInitial extends PaynowState {}

final class PaynowLoading extends PaynowState {}

final class PaynowSuccess extends PaynowState {
  final String message;

  PaynowSuccess(this.message);
}

final class PaynowError extends PaynowState {
  final String error;

  PaynowError(this.error);
}
