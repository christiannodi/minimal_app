part of 'editavatar_bloc.dart';

@immutable
sealed class EditavatarState {}

final class EditavatarInitial extends EditavatarState {}

final class EditavatarPickedState extends EditavatarState {
  final String filePath;

  EditavatarPickedState(this.filePath);
}

final class EditavatarLoading extends EditavatarState {}

final class EditavatarSuccess extends EditavatarState {}

final class EditavatarError extends EditavatarState {
  final String error;

  EditavatarError(this.error);
}
