import '../../api/request_api.dart';
import '../../models/edit_profile_model.dart';
import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';

part 'editprofile_event.dart';
part 'editprofile_state.dart';

class EditprofileBloc extends Bloc<EditprofileEvent, EditprofileState> {
  final RequestApiHeader requestApiHeader;

  EditprofileBloc({required this.requestApiHeader})
      : super(EditprofileInitial()) {
    on<EditprofileSubmitted>((event, emit) async {
      emit(EditprofileLoading());
      try {
        final request = EditProfileModel(updatedFields: event.updatedFields);
        print("📡 Sending data to API: ${request.toJson()}"); // Debugging
        await requestApiHeader.editProfile(request);
        emit(EditprofileSuccess("Edit Berhasil"));
      } catch (e) {
        final errorMessage = e.toString().replaceFirst('Exception: ', '');
        emit(EditprofileError(errorMessage));
      }
    });
  }
}
