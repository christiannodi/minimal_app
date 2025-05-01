import 'package:bloc/bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:meta/meta.dart';
import 'dart:io';

import 'package:minimal_app/api/request_api.dart';

part 'editavatar_event.dart';
part 'editavatar_state.dart';

class EditavatarBloc extends Bloc<EditavatarEvent, EditavatarState> {
  final RequestApiHeader requestApiHeader;

  EditavatarBloc({required this.requestApiHeader})
      : super(EditavatarInitial()) {
    on<Pickavatar>(_onPickAvatar);
    on<UploadAvatar>(_onUploadAvatar);
  }

  Future<void> _onPickAvatar(
      EditavatarEvent event, Emitter<EditavatarState> emit) async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      emit(EditavatarPickedState(pickedFile.path));
    }
  }

  Future<void> _onUploadAvatar(
      UploadAvatar event, Emitter<EditavatarState> emit) async {
    emit(EditavatarLoading());
    try {
      await requestApiHeader.uploadAvatar(event.file.path);
      emit(EditavatarSuccess());
    } catch (e) {
      emit(EditavatarError(e.toString()));
    }
  }
}
