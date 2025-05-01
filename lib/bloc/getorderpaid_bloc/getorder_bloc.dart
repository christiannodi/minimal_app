import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:minimal_app/models/list_order_model.dart';

import '../../api/request_api.dart';

part 'getorder_event.dart';
part 'getorder_state.dart';

class GetorderpaidBloc extends Bloc<GetorderpaidEvent, GetorderpaidState> {
  final RequestApiHeader requestApiHeader;

  GetorderpaidBloc({required this.requestApiHeader})
      : super(GetorderpaidInitial()) {
    on<Getorderpaid>((event, emit) async {
      emit(GetorderpaidLoading());
      try {
        final orderListDataModel = await requestApiHeader.getAllOrderPaid();
        emit(GetorderpaidSuccess(orderListDataModel));
      } catch (e) {
        emit(GetorderpaidError(e.toString()));
      }
    });

    on<Getorderreview>((event, emit) async {
      emit(GetorderpaidLoading());
      try {
        final orderListDataModel = await requestApiHeader.getAllOrderReview();
        emit(GetorderpaidSuccess(orderListDataModel));
      } catch (e) {
        emit(GetorderpaidError(e.toString()));
      }
    });
  }
}
