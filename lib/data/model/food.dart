class Food {
  final String name;
  final String imagePath;
  final double score;

  const Food({
    required this.name,
    required this.imagePath,
    required this.score,
  });

  @override
  String toString() {
    return 'Food(name: $name, imagePath: $imagePath, score: $score)';
  }
}

class FoodDetail {
  final String strMeal;
  final String strCategory;
  final String strArea;
  final String strMealThumb;
  final String strInstructions;
  final List<String> ingredients;
  final List<String> measures;

  const FoodDetail({
    required this.strMeal,
    required this.strCategory,
    required this.strArea,
    required this.strMealThumb,
    required this.strInstructions,
    required this.ingredients,
    required this.measures,
  });
}
