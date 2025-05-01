part of 'getcount_bloc.dart';

@immutable
sealed class GetcountState {}

final class GetcountInitial extends GetcountState {}

final class GetcountLoading extends GetcountState {}

final class GetcountSuccess extends GetcountState {
  final CountDataModel countDataModel;
  GetcountSuccess(this.countDataModel);
}

final class GetcountError extends GetcountState {
  final String error;

  GetcountError(this.error);
}
