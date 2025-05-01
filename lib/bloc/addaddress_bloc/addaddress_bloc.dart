import '../../api/request_api.dart';
import '../../models/add_address_model.dart';
import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';

part 'addaddress_event.dart';
part 'addaddress_state.dart';

class AddaddressBloc extends Bloc<AddaddressEvent, AddaddressState> {
  final RequestApiHeader requestApiHeader;

  AddaddressBloc({required this.requestApiHeader})
      : super(AddaddressInitial()) {
    on<AddaddressSubmitted>((event, emit) async {
      emit(AddaddressLoading());
      try {
        final request = AddAddressModel(updatedFields: event.updatedFields);
        print("📡 Sending data to API: ${request.toJson()}"); // Debugging
        await requestApiHeader.addAddress(request);
        emit(AddaddressSuccess("Add Address Success"));
      } catch (e) {
        final errorMessage = e.toString().replaceFirst('Exception: ', '');
        emit(AddaddressError(errorMessage));
      }
    });
  }
}
