part of 'paynow_bloc.dart';

@immutable
sealed class PaynowEvent {}

final class Paynow extends PaynowEvent {
  final int orderId;
  final Map<String, dynamic> updatedFields;

  Paynow(this.orderId, this.updatedFields);
}
