import '../../api/request_api.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../models/session_model.dart';

part 'login_event.dart';
part 'login_state.dart';

class LoginBloc extends Bloc<LoginEvent, LoginState> {
  final RequestApi requestApi;
  LoginBloc({required this.requestApi}) : super(LoginInitial()) {
    //!on<blabla> itu class yg ada modelsnya
    on<LoginRequest>((event, emit) async {
      emit(LoginLoading());
      try {
        final session = await requestApi.login(event.username, event.password);
        emit(LoginSuccess(session));
      } catch (e) {
        emit(LoginError(e.toString()));
      }
    });
  }
}
