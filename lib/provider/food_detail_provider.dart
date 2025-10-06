import 'package:flutter/material.dart';
import 'package:tabetect/data/api/api_service.dart';
import 'package:tabetect/static/food_detail_state.dart';
import 'package:tabetect/static/global_state.dart';

class FoodDetailProvider extends ChangeNotifier {
  final ApiService _foodApiService;
  final GlobalState _globalState;

  FoodDetailProvider(this._foodApiService, this._globalState);

  FoodDetailState _currentDetailState = FoodDetailIdleState();

  FoodDetailState get currentDetailState => _currentDetailState;

  Future<void> loadFoodDetails(String foodName) async {
    try {
      _currentDetailState = FoodDetailLoadingState();
      notifyListeners();
      _globalState.setLoading(true);
      _globalState.clearError();

      final foodResponse = await _foodApiService.getFoodDetail(foodName);
      if (foodResponse.meals.isEmpty) {
        _currentDetailState = FoodDetailErrorState(
          "No detailed information found for this food",
        );
        notifyListeners();
        _globalState.setError("Food details not available in TheMealDB");
      } else {
        _currentDetailState = FoodDetailLoadedState(foodResponse.meals);
        notifyListeners();
      }
    } catch (error) {
      final errorMessage = "Failed to load food details: ${error.toString()}";
      _currentDetailState = FoodDetailErrorState(errorMessage);
      notifyListeners();
      _globalState.setError(errorMessage);
    } finally {
      _globalState.setLoading(false);
    }
  }

  void clearFoodDetails() {
    _currentDetailState = FoodDetailIdleState();
    notifyListeners();
  }
}
