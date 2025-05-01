import '../../api/request_api.dart';
import '../../models/detail_product_model.dart';
import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';

part 'getdetailedproduct_event.dart';
part 'getdetailedproduct_state.dart';

class GetdetailedproductBloc
    extends Bloc<GetdetailedproductEvent, GetdetailedproductState> {
  final RequestApiHeader requestApiHeader;
  GetdetailedproductBloc({required this.requestApiHeader})
      : super(GetdetailedproductInitial()) {
    on<Getdetailproduct>((event, emit) async {
      emit(GetdetailedproductLoading());
      try {
        final detailProductDataModel =
            await requestApiHeader.getDetailedProduct(event.productId);
        emit(GetdetailedproductSuccess(detailProductDataModel));
      } catch (e) {
        emit(GetdetailedproductError(e.toString()));
      }
    });
  }
}
