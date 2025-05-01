import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:minimal_app/api/request_api.dart';

part 'deletecart_event.dart';
part 'deletecart_state.dart';

class DeletecartBloc extends Bloc<DeletecartEvent, DeletecartState> {
  final RequestApiHeader requestApiHeader;

  DeletecartBloc({required this.requestApiHeader})
      : super(DeletecartInitial()) {
    on<Deletecart>((event, emit) async {
      emit(DeletecartLoading());
      try {
        // Panggil API untuk hapus cart
        final response = await requestApiHeader.deleteCart(event.cartId);

        // Pastikan response memiliki message
        final message = response['message'] ?? "Cart berhasil dihapus";

        emit(DeletecartSuccess(message));
      } catch (e) {
        emit(DeletecartError(e.toString()));
      }
    });
  }
}
