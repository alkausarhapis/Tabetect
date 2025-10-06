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
