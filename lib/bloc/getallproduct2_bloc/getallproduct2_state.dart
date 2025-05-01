part of 'getallproduct2_bloc.dart';

@immutable
sealed class Getallproduct2State {}

final class Getallproduct2Initial extends Getallproduct2State {}

final class Getallproduct2Loading extends Getallproduct2State {}

final class Getallproduct2Success extends Getallproduct2State {
  final List<ProductDataModel> productDataModel;
  Getallproduct2Success(this.productDataModel);
}
//?tambahkan List jika hasilnya berupa list

final class Getallproduct2Error extends Getallproduct2State {
  final String error;

  Getallproduct2Error(this.error);
}
