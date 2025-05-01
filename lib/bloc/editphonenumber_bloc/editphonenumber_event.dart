part of 'editphonenumber_bloc.dart';

@immutable
sealed class EditphonenumberEvent {}

final class EditphonenumberSubmitted extends EditphonenumberEvent {
  final Map<String, dynamic> updatedFields;

  EditphonenumberSubmitted({required this.updatedFields});
}
