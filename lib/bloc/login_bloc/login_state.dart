part of 'login_bloc.dart';

@immutable
sealed class LoginState {}

final class LoginInitial extends LoginState {}

final class LoginLoading extends LoginState {}

final class LoginSuccess extends LoginState {
  final SessionModel sessionModel;

  LoginSuccess(this.sessionModel);
}

final class LoginError extends LoginState {
  final String error;

  LoginError(this.error);
}
