import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:tabetect/service/image_classification_service.dart';
import 'package:tabetect/static/classifications_state.dart';

class ImageClassificationProvider extends ChangeNotifier {
  final ImageClassificationService _service;

  ClassificationsState _state = ClassificationsNoneState();
  ClassificationsState get state => _state;

  bool _isInitialized = false;
  bool get isInitialized => _isInitialized;

  ImageClassificationProvider(this._service) {
    _initializeService();
  }

  Future<void> _initializeService() async {
    _state = ClassificationsLoadingState();
    notifyListeners();

    try {
      await _service.initHelper();
      _isInitialized = true;
      _state = ClassificationsNoneState();
    } catch (e) {
      _state = ClassificationsErrorState(
        'Failed to initialize: ${e.toString()}',
      );
    }
    notifyListeners();
  }

  Map<String, num> _classifications = {};

  Map<String, num> get classification => Map.fromEntries(
    (_classifications.entries.toList()
          ..sort((a, b) => a.value.compareTo(b.value)))
        .reversed
        .take(1),
  );

  Future<void> runClassifications(Uint8List bytes) async {
    if (!_isInitialized) {
      _state = ClassificationsErrorState(
        'Service is not initialized yet. Please wait.',
      );
      notifyListeners();
      return;
    }

    _state = ClassificationsLoadingState();
    notifyListeners();

    try {
      _classifications = await _service.inferenceImageFileIsolate(bytes);
      _state = ClassificationsLoadedState(_classifications);
    } catch (e) {
      _state = ClassificationsErrorState(e.toString());
    }

    notifyListeners();
  }

  Future<void> close() async {
    await _service.close();
  }

  void reset() {
    _classifications = {};
    _state = ClassificationsNoneState();
    notifyListeners();
  }
}
