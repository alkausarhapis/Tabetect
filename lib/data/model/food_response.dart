import 'meal.dart';

class FoodResponse {
  final List<Meal> meals;

  FoodResponse({required this.meals});

  factory FoodResponse.fromJson(Map<String, dynamic> json) {
    final rawMeals = json['meals'];
    return FoodResponse(
      meals: rawMeals == null
          ? []
          : (rawMeals as List)
                .map((e) => Meal.fromJson(e as Map<String, dynamic>))
                .toList(),
    );
  }

  Map<String, dynamic> toJson() => {
    'meals': meals.map((e) => e.toJson()).toList(),
  };
}
