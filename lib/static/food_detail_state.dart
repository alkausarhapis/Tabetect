import 'package:tabetect/data/model/meal.dart';

sealed class FoodDetailState {}

class FoodDetailIdleState extends FoodDetailState {}

class FoodDetailLoadingState extends FoodDetailState {}

class FoodDetailLoadedState extends FoodDetailState {
  final List<Meal> mealDetails;

  FoodDetailLoadedState(this.mealDetails);
}

class FoodDetailErrorState extends FoodDetailState {
  final String errorMessage;

  FoodDetailErrorState(this.errorMessage);
}
