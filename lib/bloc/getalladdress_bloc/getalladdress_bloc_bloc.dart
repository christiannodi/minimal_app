import '../../api/request_api.dart';
import '../../models/list_address_model.dart';
import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';

part 'getalladdress_bloc_event.dart';
part 'getalladdress_bloc_state.dart';

class GetalladdressBloc extends Bloc<GetalladdressEvent, GetalladdressState> {
  final RequestApiHeader requestApiHeader;

  GetalladdressBloc({required this.requestApiHeader})
      : super(GetalladdressInitial()) {
    on<Getalladdress>((event, emit) async {
      emit(GetalladdressLoading());
      try {
        final addressDataModel = await requestApiHeader.getAllAddress();
        emit(GetalladdressSuccess(addressDataModel));
      } catch (e) {
        emit(GetalladdressError(e.toString()));
      }
    });
  }
}
