import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';

import '../../api/request_api.dart';
import '../../models/add_address_model.dart';
import '../../models/list_shippingcost_model.dart';

part 'getshippingcost_event.dart';
part 'getshippingcost_state.dart';

class GetshippingcostBloc
    extends Bloc<GetshippingcostEvent, GetshippingcostState> {
  final RequestApiHeader requestApiHeader;

  GetshippingcostBloc({required this.requestApiHeader})
      : super(GetshippingcostInitial()) {
    on<GetshippingcostSubmitted>((event, emit) async {
      emit(GetshippingcostLoading());
      try {
        // Langsung kirim Map, tanpa konversi ke model
        final shippingModel =
            await requestApiHeader.getShippingCost(event.updatedFields);
        emit(GetshippingcostSuccess(shippingModel));
      } catch (e) {
        emit(GetshippingcostError(e.toString()));
      }
    });
  }
}
