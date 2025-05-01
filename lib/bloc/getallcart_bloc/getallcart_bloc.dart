import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:minimal_app/api/request_api.dart';
import 'package:minimal_app/models/list_cart_model.dart';

part 'getallcart_event.dart';
part 'getallcart_state.dart';

class GetallcartBloc extends Bloc<GetallcartEvent, GetallcartState> {
  final RequestApiHeader requestApiHeader;

  GetallcartBloc({required this.requestApiHeader})
      : super(GetallcartInitial()) {
    on<Getallcart>((event, emit) async {
      emit(GetallcartLoading());
      try {
        final cartDataModel = await requestApiHeader.getAllCart();
        emit(GetallcartSuccess(cartDataModel));
      } catch (e) {
        emit(GetallcartError(e.toString()));
      }
    });
  }
}
