sealed class FoodClassificationState {}

class FoodClassificationIdleState extends FoodClassificationState {}

class FoodClassificationLoadingState extends FoodClassificationState {}

class FoodClassificationCompletedState extends FoodClassificationState {
  final Map<String, num> classificationResults;

  FoodClassificationCompletedState(this.classificationResults);
}

class FoodClassificationErrorState extends FoodClassificationState {
  final String errorMessage;

  FoodClassificationErrorState(this.errorMessage);
}
