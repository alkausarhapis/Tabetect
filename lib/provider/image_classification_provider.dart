import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:tabetect/service/image_classification_service.dart';
import 'package:tabetect/static/food_classification_state.dart';

class ImageClassificationProvider extends ChangeNotifier {
  final ImageClassificationService _classificationService;

  FoodClassificationState _currentState = FoodClassificationIdleState();
  FoodClassificationState get currentState => _currentState;

  bool _isServiceReady = false;
  bool get isServiceReady => _isServiceReady;

  ImageClassificationProvider(this._classificationService) {
    _initializeClassificationService();
  }

  Future<void> _initializeClassificationService() async {
    _currentState = FoodClassificationLoadingState();
    notifyListeners();

    try {
      await _classificationService.initHelper();
      _isServiceReady = true;
      _currentState = FoodClassificationIdleState();
    } catch (error) {
      _currentState = FoodClassificationErrorState(
        'Initialization failed: ${error.toString()}',
      );
    }
    notifyListeners();
  }

  Map<String, num> _foodClassificationResults = {};

  Map<String, num> get topFoodPrediction => Map.fromEntries(
    (_foodClassificationResults.entries.toList()
          ..sort((a, b) => a.value.compareTo(b.value)))
        .reversed
        .take(1),
  );

  Future<void> classifyFoodImage(Uint8List imageBytes) async {
    if (!_isServiceReady) {
      _currentState = FoodClassificationErrorState(
        'Classification service is still initializing. Please wait.',
      );
      notifyListeners();
      return;
    }

    _currentState = FoodClassificationLoadingState();
    notifyListeners();

    try {
      _foodClassificationResults = await _classificationService
          .inferenceImageFileIsolate(imageBytes);
      _currentState = FoodClassificationCompletedState(
        _foodClassificationResults,
      );
    } catch (error) {
      _currentState = FoodClassificationErrorState(error.toString());
    }

    notifyListeners();
  }

  Future<void> closeClassificationService() async {
    await _classificationService.close();
  }

  void resetClassificationResults() {
    _foodClassificationResults = {};
    _currentState = FoodClassificationIdleState();
    notifyListeners();
  }
}
