import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:minimal_app/models/add_address_model.dart';

import '../../api/request_api.dart';

part 'paynow_event.dart';
part 'paynow_state.dart';

class PaynowBloc extends Bloc<PaynowEvent, PaynowState> {
  final RequestApiHeader requestApiHeader;

  PaynowBloc({required this.requestApiHeader}) : super(PaynowInitial()) {
    on<Paynow>((event, emit) async {
      emit(PaynowLoading());
      try {
        // Panggil API untuk hapus alamat
        final request = AddAddressModel(updatedFields: event.updatedFields);

        print("📡 Sending data to API: ${request.toJson()}"); // Debugging

        await requestApiHeader.payNow(event.orderId, request);
        emit(PaynowSuccess("Edit Address Success"));
      } catch (e) {
        emit(PaynowError(e.toString()));
      }
    });
  }
}
