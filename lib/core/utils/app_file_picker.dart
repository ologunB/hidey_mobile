import 'dart:io' as io;

import 'package:image_picker/image_picker.dart';
import 'package:image_cropper/image_cropper.dart';

class AppFilePicker {
  //
  static Future<CroppedFile?> cropImage(io.File imageFile) async {
    return await ImageCropper().cropImage(
      sourcePath: imageFile.path,
      aspectRatioPresets: io.Platform.isAndroid
          ? [
              CropAspectRatioPreset.square,
              CropAspectRatioPreset.ratio3x2,
              CropAspectRatioPreset.original,
              CropAspectRatioPreset.ratio4x3,
              CropAspectRatioPreset.ratio16x9
            ]
          : [
              CropAspectRatioPreset.original,
              CropAspectRatioPreset.square,
              CropAspectRatioPreset.ratio3x2,
              CropAspectRatioPreset.ratio4x3,
              CropAspectRatioPreset.ratio5x3,
              CropAspectRatioPreset.ratio5x4,
              CropAspectRatioPreset.ratio7x5,
              CropAspectRatioPreset.ratio16x9
            ],
    );
  }

  static Future<io.File?> pickImage({
    ImageSource source = ImageSource.gallery,
  }) async {
    try {
      final ImagePicker picker = ImagePicker();

      final XFile? result = await picker.pickImage(source: source);

      if (result != null) {
        io.File file = io.File(result.path);

        // final selectedFile = result;
        // final crop = await cropImage(io.File(selectedFile.path));
        // io.File compressedFile = await FlutterNativeImage.compressImage(
        //   crop!.path,
        //   percentage: 100,
        //   quality: 100,
        //   targetHeight: 150,
        //   targetWidth: 150,
        // );

        return file;
      } else {
        return null;
      }
    } catch (e) {
      return null;
    }
  }
}
