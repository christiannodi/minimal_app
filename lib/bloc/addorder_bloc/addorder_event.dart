part of 'addorder_bloc.dart';

@immutable
sealed class AddorderEvent {}

final class AddorderSubmitted extends AddorderEvent {
  final Map<String, dynamic> updatedFields;

  AddorderSubmitted({required this.updatedFields});
}
