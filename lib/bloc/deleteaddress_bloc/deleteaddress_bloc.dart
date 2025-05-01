import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';

import '../../api/request_api.dart';

part 'deleteaddress_event.dart';
part 'deleteaddress_state.dart';

class DeleteaddressBloc extends Bloc<DeleteaddressEvent, DeleteaddressState> {
  final RequestApiHeader requestApiHeader;

  DeleteaddressBloc({required this.requestApiHeader})
      : super(DeleteaddressInitial()) {
    on<Deleteaddress>((event, emit) async {
      emit(DeleteaddressLoading());
      try {
        // Panggil API untuk hapus alamat
        final response = await requestApiHeader.deleteAddress(event.addressId);

        // Pastikan response memiliki message
        final message = response['message'] ?? "Alamat berhasil dihapus";

        emit(DeleteaddressSuccess(message));
      } catch (e) {
        emit(DeleteaddressError(e.toString()));
      }
    });
  }
}
