part of 'login_bloc.dart';

@immutable
sealed class LoginEvent {}

final class LoginRequest extends LoginEvent {
  final String username;
  final String password;

  LoginRequest({
    required this.username,
    required this.password,
  });
}