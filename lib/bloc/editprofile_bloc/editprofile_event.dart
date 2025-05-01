part of 'editprofile_bloc.dart';

@immutable
sealed class EditprofileEvent {}

final class EditprofileSubmitted extends EditprofileEvent {
  final Map<String, dynamic> updatedFields;

  EditprofileSubmitted({required this.updatedFields});
}
