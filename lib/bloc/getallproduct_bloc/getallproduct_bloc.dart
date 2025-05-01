import '../../api/request_api.dart';
import '../../models/list_product_model.dart';
import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';

part 'getallproduct_event.dart';
part 'getallproduct_state.dart';

class GetallproductBloc extends Bloc<GetallproductEvent, GetallproductState> {
  final RequestApiHeader requestApiHeader;
  GetallproductBloc({required this.requestApiHeader})
      : super(GetallproductInitial()) {
    on<Getallproduct>((event, emit) async {
      emit(GetallproductLoading());
      try {
        final productDataModel = await requestApiHeader.getAllProduct();
        emit(GetallproductSuccess(productDataModel));
      } catch (e) {
        emit(GetallproductError(e.toString()));
      }
    });
  }
}
