import '../../api/request_api.dart';
import '../../models/add_address_model.dart';
import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';

part 'editaddress_event.dart';
part 'editaddress_state.dart';

class EditaddressBloc extends Bloc<EditaddressEvent, EditaddressState> {
  final RequestApiHeader requestApiHeader;

  EditaddressBloc({required this.requestApiHeader})
      : super(EditaddressInitial()) {
    on<Editaddress>((event, emit) async {
      emit(EditaddressLoading());
      try {
        final request = AddAddressModel(updatedFields: event.updatedFields);
        print("📡 Sending data to API: ${request.toJson()}"); // Debugging
        await requestApiHeader.editAddress(event.addressId, request);
        emit(EditaddressSuccess("Edit Address Success"));
      } catch (e) {
        final errorMessage = e.toString().replaceFirst('Exception: ', '');
        emit(EditaddressError(errorMessage));
      }
    });
  }
}
