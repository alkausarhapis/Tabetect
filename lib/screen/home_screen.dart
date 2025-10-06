import 'dart:io';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tabetect/data/model/food.dart';
import 'package:tabetect/provider/home_provider.dart';
import 'package:tabetect/provider/image_classification_provider.dart';
import 'package:tabetect/screen/food_detail_screen.dart';
import 'package:tabetect/service/image_classification_service.dart';
import 'package:tabetect/static/food_classification_state.dart';
import 'package:tabetect/static/global_state.dart';
import 'package:tabetect/styles/colors/app_color.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        Provider(create: (context) => ImageClassificationService()),
        ChangeNotifierProvider(
          create: (context) => ImageClassificationProvider(
            context.read<ImageClassificationService>(),
          ),
        ),
        ChangeNotifierProvider(create: (context) => HomeProvider()),
        ChangeNotifierProvider(create: (context) => GlobalState()),
      ],
      child: const _HomeView(),
    );
  }
}

class _HomeView extends StatefulWidget {
  const _HomeView();

  @override
  State<_HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<_HomeView> {
  late ImageClassificationProvider classificationProvider;

  @override
  void initState() {
    super.initState();
    classificationProvider = context.read<ImageClassificationProvider>();
  }

  @override
  void dispose() {
    classificationProvider.closeClassificationService();
    super.dispose();
  }

  AppColor _getConfidenceColor(double confidence) {
    final percentage = confidence * 100;
    if (percentage >= 75) {
      return AppColor.successGreen;
    } else if (percentage >= 50) {
      return AppColor.warningYellow;
    } else {
      return AppColor.primaryRed;
    }
  }

  void _analyzeImage(String imagePath) async {
    try {
      final bytes = await File(imagePath).readAsBytes();
      await classificationProvider.classifyFoodImage(bytes);
    } catch (e) {
      if (!mounted) return;
      context.read<GlobalState>().setError(
        'Failed to analyze image: ${e.toString()}',
      );
    }
  }

  void _navigateToDetail(String foodName, String imagePath, double confidence) {
    final food = Food(name: foodName, imagePath: imagePath, score: confidence);

    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => FoodDetailScreen(food: food)),
    );
  }

  void _cropCurrentImage() {
    final homeProvider = context.read<HomeProvider>();
    if (homeProvider.selectedImageFile != null) {
      homeProvider.cropCurrentImage();
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(title: const Text('Tabetect'), centerTitle: true),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            children: [
              // Image Preview Area
              Expanded(
                flex: 3,
                child: GestureDetector(
                  onTap: () =>
                      context.read<HomeProvider>().selectImageFromGallery(),
                  child: Container(
                    width: double.infinity,
                    decoration: BoxDecoration(
                      color: theme.colorScheme.surface,
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(
                        color: theme.colorScheme.outline.withValues(alpha: 0.2),
                        width: 1,
                      ),
                    ),
                    child: Consumer<HomeProvider>(
                      builder: (context, homeProvider, child) {
                        return homeProvider.selectedImagePath == null
                            ? Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(
                                    Icons.camera_alt_outlined,
                                    size: 64,
                                    color: theme.colorScheme.onSurface
                                        .withValues(alpha: 0.4),
                                  ),
                                  const SizedBox(height: 16),
                                  Text(
                                    'Select an image',
                                    style: theme.textTheme.bodyLarge?.copyWith(
                                      color: theme.colorScheme.onSurface
                                          .withValues(alpha: 0.6),
                                    ),
                                  ),
                                ],
                              )
                            : ClipRRect(
                                borderRadius: BorderRadius.circular(16),
                                child: Image.file(
                                  File(homeProvider.selectedImagePath!),
                                  width: double.infinity,
                                  height: double.infinity,
                                  fit: BoxFit.cover,
                                ),
                              );
                      },
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 24),

              // Recognition Result
              Consumer2<ImageClassificationProvider, HomeProvider>(
                builder: (context, classificationProvider, homeProvider, child) {
                  if (classificationProvider.topFoodPrediction.isNotEmpty) {
                    final entry =
                        classificationProvider.topFoodPrediction.entries.first;
                    final foodName = entry.key;
                    final confidence = entry.value.toDouble();
                    final confidenceColor = _getConfidenceColor(confidence);

                    return Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        color: confidenceColor.color.withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(
                          color: confidenceColor.color.withValues(alpha: 0.3),
                          width: 1,
                        ),
                      ),
                      child: Column(
                        children: [
                          Text(
                            foodName,
                            style: theme.textTheme.headlineSmall?.copyWith(
                              fontWeight: FontWeight.w600,
                              color: theme.colorScheme.onSurface,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 12,
                              vertical: 6,
                            ),
                            decoration: BoxDecoration(
                              color: confidenceColor.color,
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: Text(
                              'Confidence: ${(confidence * 100).toStringAsFixed(1)}%',
                              style: theme.textTheme.bodyMedium?.copyWith(
                                color: Colors.white,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                          const SizedBox(height: 16),
                          SizedBox(
                            width: double.infinity,
                            child: ElevatedButton.icon(
                              onPressed: () => _navigateToDetail(
                                foodName,
                                homeProvider.selectedImagePath!,
                                confidence,
                              ),
                              icon: const Icon(Icons.info_outline),
                              label: const Text('View Details'),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: confidenceColor.color,
                                padding: const EdgeInsets.symmetric(
                                  vertical: 12,
                                ),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(8),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    );
                  }
                  return const SizedBox.shrink();
                },
              ),

              const SizedBox(height: 20),

              // Action Buttons
              Column(
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: OutlinedButton.icon(
                          onPressed: () => context
                              .read<HomeProvider>()
                              .selectImageFromGallery(),
                          icon: const Icon(Icons.photo_library_outlined),
                          label: const Text('Gallery'),
                          style: OutlinedButton.styleFrom(
                            padding: const EdgeInsets.symmetric(vertical: 14),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                            side: BorderSide(
                              color: theme.colorScheme.primary,
                              width: 1.5,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: OutlinedButton.icon(
                          onPressed: () => context
                              .read<HomeProvider>()
                              .selectImageFromCamera(),
                          icon: const Icon(Icons.camera_alt_outlined),
                          label: const Text('Camera'),
                          style: OutlinedButton.styleFrom(
                            padding: const EdgeInsets.symmetric(vertical: 14),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                            side: BorderSide(
                              color: theme.colorScheme.primary,
                              width: 1.5,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  Consumer<HomeProvider>(
                    builder: (context, homeProvider, child) {
                      if (homeProvider.selectedImagePath != null) {
                        return Column(
                          children: [
                            SizedBox(
                              width: double.infinity,
                              child: OutlinedButton.icon(
                                onPressed: () => _cropCurrentImage(),
                                icon: const Icon(Icons.crop),
                                label: const Text('Crop Image'),
                                style: OutlinedButton.styleFrom(
                                  padding: const EdgeInsets.symmetric(
                                    vertical: 14,
                                  ),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  side: BorderSide(
                                    color: AppColor.primaryRed.color,
                                    width: 1.5,
                                  ),
                                  foregroundColor: AppColor.primaryRed.color,
                                ),
                              ),
                            ),
                            const SizedBox(height: 12),
                          ],
                        );
                      }
                      return const SizedBox.shrink();
                    },
                  ),
                  SizedBox(
                    width: double.infinity,
                    child: Consumer2<ImageClassificationProvider, HomeProvider>(
                      builder:
                          (
                            context,
                            classificationProvider,
                            homeProvider,
                            child,
                          ) {
                            final canAnalyze =
                                classificationProvider.isServiceReady &&
                                homeProvider.selectedImagePath != null &&
                                homeProvider.selectedImagePath!.isNotEmpty;

                            return switch (classificationProvider
                                .currentState) {
                              FoodClassificationLoadingState() =>
                                ElevatedButton.icon(
                                  onPressed: null,
                                  icon: SizedBox(
                                    width: 20,
                                    height: 20,
                                    child: CircularProgressIndicator(
                                      strokeWidth: 2,
                                    ),
                                  ),
                                  label: Text('Analyzing...'),
                                ),
                              FoodClassificationErrorState(
                                errorMessage: var error,
                              ) =>
                                Column(
                                  children: [
                                    Text(
                                      'Error: $error',
                                      style: TextStyle(
                                        color: AppColor.primaryRed.color,
                                        fontSize: 12,
                                        fontWeight: FontWeight.w300,
                                      ),
                                    ),
                                    const SizedBox(height: 8),
                                    ElevatedButton.icon(
                                      onPressed: canAnalyze
                                          ? () => _analyzeImage(
                                              homeProvider.selectedImagePath!,
                                            )
                                          : null,
                                      icon: const Icon(Icons.refresh),
                                      label: const Text('Retry'),
                                    ),
                                  ],
                                ),
                              _ => ElevatedButton.icon(
                                onPressed: canAnalyze
                                    ? () => _analyzeImage(
                                        homeProvider.selectedImagePath!,
                                      )
                                    : null,
                                icon: const Icon(Icons.analytics_outlined),
                                label: Text(
                                  classificationProvider.isServiceReady
                                      ? 'Analyze'
                                      : 'Initializing...',
                                ),
                                style: ElevatedButton.styleFrom(
                                  padding: const EdgeInsets.symmetric(
                                    vertical: 14,
                                  ),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                ),
                              ),
                            };
                          },
                    ),
                  ),
                ],
              ),

              // Global Error Display
              Consumer<GlobalState>(
                builder: (context, globalState, child) {
                  if (globalState.globalError != null) {
                    return Container(
                      margin: const EdgeInsets.only(top: 16),
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: AppColor.primaryRed.color.withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(
                          color: AppColor.primaryRed.color.withValues(
                            alpha: 0.3,
                          ),
                          width: 1,
                        ),
                      ),
                      child: Row(
                        children: [
                          Icon(
                            Icons.error_outline,
                            color: AppColor.primaryRed.color,
                            size: 20,
                          ),
                          const SizedBox(width: 8),
                          Expanded(
                            child: Text(
                              globalState.globalError!,
                              style: theme.textTheme.bodySmall?.copyWith(
                                color: AppColor.primaryRed.color,
                              ),
                            ),
                          ),
                          IconButton(
                            onPressed: () => globalState.clearError(),
                            icon: Icon(
                              Icons.close,
                              color: AppColor.primaryRed.color,
                              size: 16,
                            ),
                          ),
                        ],
                      ),
                    );
                  }
                  return const SizedBox.shrink();
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
