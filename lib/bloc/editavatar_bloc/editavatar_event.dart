part of 'editavatar_bloc.dart';

@immutable
sealed class EditavatarEvent {}

final class Pickavatar extends EditavatarEvent {

}


final class UploadAvatar extends EditavatarEvent {
  final File file;

  UploadAvatar(this.file);
}
