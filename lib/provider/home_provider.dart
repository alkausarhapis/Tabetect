import 'package:flutter/material.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:tabetect/styles/colors/app_color.dart';

class HomeProvider extends ChangeNotifier {
  String? imagePath;
  XFile? imageFile;

  void _setImages(XFile? value) {
    imageFile = value;
    imagePath = value?.path;
    notifyListeners();
  }

  Future<void> openCamera() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.camera);

    if (pickedFile != null) {
      _setImages(pickedFile);
    }
  }

  Future<void> openGallery() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      _setImages(pickedFile);
    }
  }

  Future<void> cropExistingImage() async {
    if (imageFile != null) {
      await _cropAndSetImage(imageFile!);
    }
  }

  Future<void> _cropAndSetImage(XFile imageFile) async {
    try {
      final CroppedFile? croppedFile = await ImageCropper().cropImage(
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

      if (croppedFile != null) {
        _setImages(XFile(croppedFile.path));
      }
    } catch (e) {
      debugPrint('Failed to crop image: $e');
    }
  }
}
