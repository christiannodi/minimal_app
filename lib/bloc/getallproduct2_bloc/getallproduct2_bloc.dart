import '../../api/request_api.dart';
import '../../models/list_product_model.dart';
import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';

part 'getallproduct2_event.dart';
part 'getallproduct2_state.dart';

class Getallproduct2Bloc
    extends Bloc<Getallproduct2Event, Getallproduct2State> {
  final RequestApiHeader requestApiHeader;
  Getallproduct2Bloc({required this.requestApiHeader})
      : super(Getallproduct2Initial()) {
    on<Getallproduct2>((event, emit) async {
      emit(Getallproduct2Loading());
      try {
        final productDataModel = await requestApiHeader.getAllProduct2();
        emit(Getallproduct2Success(productDataModel));
      } catch (e) {
        emit(Getallproduct2Error(e.toString()));
      }
    });
  }
}
