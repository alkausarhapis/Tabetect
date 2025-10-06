import 'package:flutter/material.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:tabetect/styles/colors/app_color.dart';

class HomeProvider extends ChangeNotifier {
  String? selectedImagePath;
  XFile? selectedImageFile;

  void _updateSelectedImage(XFile? newImageFile) {
    selectedImageFile = newImageFile;
    selectedImagePath = newImageFile?.path;
    notifyListeners();
  }

  Future<void> selectImageFromCamera() async {
    final imagePicker = ImagePicker();
    final capturedImage = await imagePicker.pickImage(
      source: ImageSource.camera,
    );

    if (capturedImage != null) {
      _updateSelectedImage(capturedImage);
    }
  }

  Future<void> selectImageFromGallery() async {
    final imagePicker = ImagePicker();
    final selectedImage = await imagePicker.pickImage(
      source: ImageSource.gallery,
    );

    if (selectedImage != null) {
      _updateSelectedImage(selectedImage);
    }
  }

  Future<void> cropCurrentImage() async {
    if (selectedImageFile != null) {
      await _cropImageAndUpdate(selectedImageFile!);
    }
  }

  Future<void> _cropImageAndUpdate(XFile imageFile) async {
    try {
      final croppedImageFile = await ImageCropper().cropImage(
        sourcePath: imageFile.path,
        uiSettings: [
          AndroidUiSettings(
            toolbarTitle: 'Crop Food Image',
            toolbarColor: AppColor.darkBlue.color,
            toolbarWidgetColor: AppColor.brokenWhite.color,
            backgroundColor: AppColor.brokenWhite.color,
            activeControlsWidgetColor: AppColor.primaryRed.color,
            dimmedLayerColor: AppColor.darkBlue.color.withValues(alpha: 0.8),
            cropFrameColor: AppColor.primaryRed.color,
            cropGridColor: AppColor.primaryRed.color.withValues(alpha: 0.5),
            initAspectRatio: CropAspectRatioPreset.square,
            lockAspectRatio: false,
            aspectRatioPresets: [
              CropAspectRatioPreset.original,
              CropAspectRatioPreset.square,
              CropAspectRatioPreset.ratio3x2,
              CropAspectRatioPreset.ratio4x3,
              CropAspectRatioPreset.ratio16x9,
            ],
          ),
          IOSUiSettings(
            title: 'Crop Food Image',
            aspectRatioLockEnabled: false,
            resetAspectRatioEnabled: true,
            aspectRatioPickerButtonHidden: false,
            aspectRatioPresets: [
              CropAspectRatioPreset.original,
              CropAspectRatioPreset.square,
              CropAspectRatioPreset.ratio3x2,
              CropAspectRatioPreset.ratio4x3,
              CropAspectRatioPreset.ratio16x9,
            ],
          ),
        ],
      );

      if (croppedImageFile != null) {
        _updateSelectedImage(XFile(croppedImageFile.path));
      }
    } catch (e) {
      debugPrint('Failed to crop image: $e');
    }
  }
}
