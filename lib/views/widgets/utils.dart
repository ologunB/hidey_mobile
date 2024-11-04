import 'dart:io';

import 'package:external_path/external_path.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:mms_app/core/models/directory_model.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';

class Utils {
  static void offKeyboard() async {
    await SystemChannels.textInput.invokeMethod<dynamic>('TextInput.hide');
  }

  static String getByteSize(int val) {
    if (val < 1024 * 1024) {
      return (val / (1024)).toStringAsFixed(2) + ' KB';
    } else if (val < 1024 * 1024 * 1024) {
      return (val / (1024 * 1024)).toStringAsFixed(2) + ' MB';
    } else {
      return '0.0';
    }
  }

  static getImageType(
    DirectoryModel? dir, {
    bool? multipleFolders,
    bool? folderLocked,
    bool? fileLocked,
  }) {
    String name = dir?.name ?? '';
    List<String> images = ['png', 'jpeg', 'jpg'];
    List<String> videos = [
      'mp4',
      'mpeg',
      'mkv',
      'm4a',
      '3gp',
      '3g2',
      '3gp',
      'mov'
    ];
    String ext = name.split('.').last.toLowerCase();
    if (ext == 'pdf') {
      return 'type-pdf';
    } else if (ext == 'txt') {
      return 'type-txt';
    } else if (images.contains(ext)) {
      return 'type-image';
    } else if (videos.contains(ext)) {
      return 'type-video';
    } else if (folderLocked == true) {
      return 'type-locked-folder';
    } else if (multipleFolders == true) {
      return 'type-folders';
    } else if (dir?.parentID != null) {
      return 'type-folder';
    } else if (dir?.directoryID != null) {
      // unknown file
      return 'type-file';
    } else {
      return 'type-folder';
    }
  }

  static String? isValidPassword(String? value) {
    value = value!.trim();
    if (value.trim().isEmpty) {
      return "Password is required";
    } else if (value.trim().length < 6) {
      return "Password is too short";
    } else if (!value.trim().contains(RegExp(r'[0-9]'))) {
      return "Password must contain a number";
    } else if (!value.trim().contains(RegExp(r'[a-z]'))) {
      return "Password must contain a lowercase letter";
    } else if (!value.trim().contains(RegExp(r'[A-Z]'))) {
      return "Password must contain a uppercase letter";
    } else if (!value.trim().contains(RegExp(r'[!@#$%^&*(),.?":{}|<>]'))) {
      return "Password must contain a special character";
    }
    return null;
  }

  static bool isVideoFile(String filePath) {
    // Get the file extension
    String extension = filePath.split('.').last.toLowerCase();

    // Check if the extension corresponds to a video file
    return extension == 'mp4' ||
        extension == 'mov' ||
        extension == 'avi' ||
        extension == 'mkv' ||
        extension == 'wmv';
  }

  static String? isValidName(String? value, String type, int length) {
    if (value!.isEmpty) {
      return '$type cannot be Empty';
    } else if (value.length < length) {
      return '$type is too short';
    } else if (value.length > 50) {
      return '$type max length is 50';
    }
    return null;
  }

  static String? validateEmail(String? value) {
    value = value!.trim();
    final RegExp regex = RegExp(
        r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$');
    if (value.isEmpty) {
      return 'Email cannot be empty';
    } else if (!regex.hasMatch(value)) {
      return 'Enter valid email';
    } else {
      return null;
    }
  }

  static void unfocusKeyboard(BuildContext context) {
    final FocusScopeNode currentFocus = FocusScope.of(context);

    if (!currentFocus.hasPrimaryFocus) {
      currentFocus.unfocus();
      return;
    }
    currentFocus.unfocus();
  }

  Future<bool> checkPermission() async {
    if (Platform.isAndroid) {
      final PermissionStatus status = await Permission.storage.status;
      if (status != PermissionStatus.granted) {
        final PermissionStatus result = await Permission.storage.request();
        if (result == PermissionStatus.granted) {
          return true;
        }
      } else {
        return true;
      }
    } else {
      return true;
    }
    return false;
  }

  static Future<String> findLocalPath() async {
    final Directory directory = Platform.isAndroid
        ? Directory(await ExternalPath.getExternalStoragePublicDirectory(
            ExternalPath.DIRECTORY_DOWNLOADS))
        : await getApplicationDocumentsDirectory();

    return directory.path;
  }
}

extension customStringExtension on String {
  toTitleCase() {
    final words = this.toString().toLowerCase().split(' ');
    var newWord = '';
    for (var word in words) {
      if (word.isNotEmpty)
        newWord += '${word[0].toUpperCase()}${word.substring(1)} ';
    }

    return newWord;
  }

  toImage() {
    return 'assets/images/' + this + '.png';
  }

  toAmount() {
    return NumberFormat("#,##0.00", "en_US")
        .format(double.tryParse(this) ?? 0.00);
  }

  getSingleInitial() {
    return this.split('')[0].toUpperCase();
  }

  sanitizeToDouble() {
    return double.tryParse(this.replaceAll(",", ""));
  }
}

extension sizeExtension on int {
  String toMB() {
    return NumberFormat("#,##0.00", "en_US").format(this * 0.000001);
  }
}
