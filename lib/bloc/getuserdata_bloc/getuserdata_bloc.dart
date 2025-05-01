import '../../api/request_api.dart';
import '../../models/user_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'getuserdata_event.dart';
part 'getuserdata_state.dart';

class GetuserdataBloc extends Bloc<GetuserdataEvent, GetuserdataState> {
  final RequestApiHeader requestApiHeader;
  GetuserdataBloc({required this.requestApiHeader})
      : super(GetuserdataInitial()) {
    on<GetUser>((event, emit) async {
      emit(GetuserdataLoading());
      try {
        final userDataModel = await requestApiHeader.getUserInfo();
        emit(GetuserdataSuccess(userDataModel));
      } catch (e) {
        emit(GetuserdataError(e.toString()));
      }
    });

  }
}
