import '../../api/request_api.dart';
import '../../models/register_model.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter/material.dart';

part 'register_event.dart';
part 'register_state.dart';

class RegisterBloc extends Bloc<RegisterEvent, RegisterState> {
  //? IMPORT MODEL as NAME
  final RequestApi requestApi;
  RegisterBloc({required this.requestApi}) : super(RegisterInitial()) {
    on<RegisterSubmitted>((event, emit) async {
      emit(RegisterLoading());
      try {
        //?lalu yang ini model yang dipakai API
        final request = RegisterModel(
          username: event.username,
          password: event.password,
          email: event.email,
        );

        await requestApi.register(request);

        // Kirim data response ke state success
        emit(RegisterSuccess(
            "Registrasi berhasil")); //!print username untuk result snackbar
      } catch (e) {
        // Proses pesan error untuk menghilangkan "Exception:"
        final errorMessage = e.toString().replaceFirst('Exception: ', '');
        emit(RegisterError(
            errorMessage)); // Kirim pesan error tanpa prefix "Exception:"
      }
    });
  }
}
