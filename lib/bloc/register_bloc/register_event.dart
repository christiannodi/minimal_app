part of 'register_bloc.dart';

@immutable
sealed class RegisterEvent {}

final class RegisterSubmitted extends RegisterEvent {
  final String username;
  final String password;
  final String email;

  RegisterSubmitted({
    required this.username,
    required this.password,
    required this.email,
  });
}
