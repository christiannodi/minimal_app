part of 'deleteaddress_bloc.dart';

@immutable
sealed class DeleteaddressEvent {}

final class Deleteaddress extends DeleteaddressEvent {
  final int addressId;
  Deleteaddress(this.addressId);
}
