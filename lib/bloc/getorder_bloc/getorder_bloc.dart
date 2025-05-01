import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:minimal_app/models/list_order_model.dart';

import '../../api/request_api.dart';

part 'getorder_event.dart';
part 'getorder_state.dart';

class  GetorderBloc extends Bloc<GetorderEvent, GetorderState> {
  final RequestApiHeader requestApiHeader;

  GetorderBloc({required this.requestApiHeader}) : super(GetorderInitial()) {
    on<Getorder>((event, emit) async {
      emit(GetorderLoading());
      try {
        final orderListDataModel = await requestApiHeader.getAllOrder();
        emit(GetorderSuccess(orderListDataModel));
      } catch (e) {
        emit(GetorderError(e.toString()));
      }
    });
  }
}
