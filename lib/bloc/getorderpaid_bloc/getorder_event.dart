part of 'getorder_bloc.dart';

@immutable
sealed class GetorderpaidEvent {}

final class Getorderpaid extends GetorderpaidEvent {}

final class Getorderreview extends GetorderpaidEvent {}
