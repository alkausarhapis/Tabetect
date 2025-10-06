import 'dart:isolate';

import 'package:flutter/services.dart';
import 'package:tabetect/service/isolate_inference.dart';
import 'package:tflite_flutter/tflite_flutter.dart';

class ImageClassificationService {
  final modelPath = 'assets/food_classifier.tflite';
  final labelsPath = 'assets/probability-labels-en.txt';

  late final Interpreter interpreter;
  late final List<String> labels;
  late Tensor inputTensor;
  late Tensor outputTensor;

  late final IsolateInference isolateInference;

  Future<void> _loadModels() async {
    final options = InterpreterOptions()
      ..useNnApiForAndroid = true
      ..useMetalDelegateForIOS = true;

    interpreter = await Interpreter.fromAsset(modelPath, options: options);
    inputTensor = interpreter.getInputTensors().first;
    outputTensor = interpreter.getOutputTensors().first;
  }

  Future<void> _loadLabels() async {
    final labelsTxt = await rootBundle.loadString(labelsPath);
    labels = labelsTxt.split("\n");
  }

  Future<void> initHelper() async {
    await _loadModels();
    await _loadLabels();

    isolateInference = IsolateInference();
    await isolateInference.start();
  }

  Future<Map<String, double>> inferenceImageFileIsolate(Uint8List bytes) async {
    var isolateModel = InferenceModel(
      bytes,
      interpreter.address,
      labels,
      inputTensor.shape,
      outputTensor.shape,
    );

    ReceivePort responsePort = ReceivePort();
    isolateInference.sendPort.send(
      isolateModel..responsePort = responsePort.sendPort,
    );

    var results = await responsePort.first;
    return results;
  }

  Future<void> close() async {
    await isolateInference.close();
  }
}
