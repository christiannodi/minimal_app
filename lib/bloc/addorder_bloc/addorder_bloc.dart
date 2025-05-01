import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';

import '../../api/request_api.dart';
import '../../models/add_address_model.dart';

part 'addorder_event.dart';
part 'addorder_state.dart';

class AddorderBloc extends Bloc<AddorderEvent, AddorderState> {
  final RequestApiHeader requestApiHeader;

  AddorderBloc({required this.requestApiHeader}) : super(AddorderInitial()) {
    on<AddorderSubmitted>((event, emit) async {
      emit(AddorderLoading());
      try {
        final request = AddAddressModel(updatedFields: event.updatedFields);
        print("📡 Sending data to API: ${request.toJson()}"); // Debugging
        await requestApiHeader.addOrder(request);
        emit(AddorderSuccess("Add Address Success"));
      } catch (e) {
        final errorMessage = e.toString().replaceFirst('Exception: ', '');
        emit(AddorderError(errorMessage));
      }
    });
  }
}
