part of 'getshippingcost_bloc.dart';

@immutable
sealed class GetshippingcostEvent {}

final class GetshippingcostSubmitted extends GetshippingcostEvent {
  final Map<String, dynamic> updatedFields;

  GetshippingcostSubmitted({required this.updatedFields});
}
