import '../../api/request_api.dart';
import '../../models/edit_profile_model.dart';
import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';

part 'editphonenumber_event.dart';
part 'editphonenumber_state.dart';

class EditphonenumberBloc
    extends Bloc<EditphonenumberEvent, EditphonenumberState> {
  final RequestApiHeader requestApiHeader;

  EditphonenumberBloc({required this.requestApiHeader})
      : super(EditphonenumberInitial()) {
    on<EditphonenumberSubmitted>((event, emit) async {
      emit(EditphonenumberLoading());
      try {
        final request = EditProfileModel(updatedFields: event.updatedFields);
        print("📡 Sending data to API: ${request.toJson()}"); // Debugging
        await requestApiHeader.editPhoneNumber(request);
        emit(EditphonenumberSuccess("Edit Berhasil"));
      } catch (e) {
        final errorMessage = e.toString().replaceFirst('Exception: ', '');
        emit(EditphonenumberError(errorMessage));
      }
    });
  }
}
