import 'package:flutter/material.dart';
import 'package:tabetect/data/api/api_service.dart';
import 'package:tabetect/static/detail_result_state.dart';
import 'package:tabetect/static/global_state.dart';

class DetailProvider extends ChangeNotifier {
  final ApiService _service;
  final GlobalState _globalState;

  DetailProvider(this._service, this._globalState);

  DetailResultState _resultState = DetailNoneResultState();

  DetailResultState get resultState => _resultState;

  Future<void> fetchDetailFood(String name) async {
    try {
      _resultState = DetailLoadingResultState();
      notifyListeners();
      _globalState.setLoading(true);
      _globalState.clearError();

      final result = await _service.getFoodDetail(name);
      if (result.meals.isEmpty) {
        _resultState = DetailErrorResultState(
          "No detailed information found for this food",
        );
        notifyListeners();
        _globalState.setError("Food details not available in themealdb");
      } else {
        _resultState = DetailLoadedResultState(result.meals);
        notifyListeners();
      }
    } catch (e) {
      final errorMessage = "Failed to load food details: ${e.toString()}";
      _resultState = DetailErrorResultState(errorMessage);
      notifyListeners();
      _globalState.setError(errorMessage);
    } finally {
      _globalState.setLoading(false);
    }
  }

  void reset() {
    _resultState = DetailNoneResultState();
    notifyListeners();
  }
}
