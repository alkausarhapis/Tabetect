import 'package:flutter/material.dart';

class GlobalState extends ChangeNotifier {
  static final GlobalState _instance = GlobalState._internal();
  factory GlobalState() => _instance;
  GlobalState._internal();

  String? _globalError;
  bool _isLoading = false;
  String? _currentImagePath;

  String? get globalError => _globalError;
  bool get isLoading => _isLoading;
  String? get currentImagePath => _currentImagePath;

  void setError(String? error) {
    _globalError = error;
    notifyListeners();
  }

  void setLoading(bool loading) {
    _isLoading = loading;
    notifyListeners();
  }

  void setCurrentImagePath(String? path) {
    _currentImagePath = path;
    notifyListeners();
  }

  void clearError() {
    _globalError = null;
    notifyListeners();
  }

  void reset() {
    _globalError = null;
    _isLoading = false;
    _currentImagePath = null;
    notifyListeners();
  }
}

enum ErrorType { network, camera, classification, permission, unknown }

class AppError {
  final String message;
  final ErrorType type;
  final dynamic originalError;

  AppError({required this.message, required this.type, this.originalError});

  @override
  String toString() {
    return 'AppError(type: $type, message: $message)';
  }
}
