part of 'editaddress_bloc.dart';

@immutable
sealed class EditaddressEvent {}

final class Editaddress extends EditaddressEvent {
  final int addressId;
  final Map<String, dynamic> updatedFields;

  Editaddress({required this.updatedFields, required this.addressId});
}
