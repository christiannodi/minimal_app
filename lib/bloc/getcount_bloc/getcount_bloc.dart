import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:minimal_app/models/count_model.dart';

import '../../api/request_api.dart';

part 'getcount_event.dart';
part 'getcount_state.dart';

class GetcountBloc extends Bloc<GetcountEvent, GetcountState> {
  final RequestApiHeader requestApiHeader;

  GetcountBloc({required this.requestApiHeader}) : super(GetcountInitial()) {
    on<GetCount>((event, emit) async {
      emit(GetcountLoading());
      try {
        final countDataModel = await requestApiHeader.getCount();
        emit(GetcountSuccess(countDataModel));
      } catch (e) {
        emit(GetcountError(e.toString()));
      }
    });
  }
}
