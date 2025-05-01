part of 'addcart_bloc.dart';

@immutable
sealed class AddcartEvent {}

final class AddcartSubmitted extends AddcartEvent {
  final Map<String, dynamic> updatedFields;

  AddcartSubmitted({required this.updatedFields});
}
