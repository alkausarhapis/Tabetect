import 'package:tabetect/data/model/food_response.dart';

abstract class DetailResultState {}

class DetailNoneResultState extends DetailResultState {}

class DetailLoadingResultState extends DetailResultState {}

class DetailLoadedResultState extends DetailResultState {
  final List<Meal> result;

  DetailLoadedResultState(this.result);
}

class DetailErrorResultState extends DetailResultState {
  final String errorMsg;

  DetailErrorResultState(this.errorMsg);
}
