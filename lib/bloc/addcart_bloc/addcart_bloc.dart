import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:minimal_app/api/request_api.dart';
import 'package:minimal_app/models/add_cart_model.dart';

part 'addcart_event.dart';
part 'addcart_state.dart';

class AddcartBloc extends Bloc<AddcartEvent, AddcartState> {
  final RequestApiHeader requestApiHeader;

  AddcartBloc({required this.requestApiHeader}) : super(AddcartInitial()) {
    on<AddcartSubmitted>((event, emit) async {
      emit(AddcartLoading());
      try {
        final request = AddCartModel(updatedFields: event.updatedFields);
        print("📡 Sending data to API: ${request.toJson()}"); // Debugging
        await requestApiHeader.addCart(request);
        emit(AddcartSuccess("Add Address Success"));
      } catch (e) {
        final errorMessage = e.toString().replaceFirst('Exception: ', '');
        emit(AddcartError(errorMessage));
      }
    });
  }
}
