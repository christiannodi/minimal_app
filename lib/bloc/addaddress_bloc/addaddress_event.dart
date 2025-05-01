part of 'addaddress_bloc.dart';

@immutable
sealed class AddaddressEvent {}

final class AddaddressSubmitted extends AddaddressEvent {
  final Map<String, dynamic> updatedFields;

  AddaddressSubmitted({required this.updatedFields});
}
