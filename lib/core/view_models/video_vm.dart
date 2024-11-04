import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:dio/dio.dart';
import 'package:external_path/external_path.dart';
import 'package:ffmpeg_kit_flutter_full_gpl/ffmpeg_kit.dart';
import 'package:ffmpeg_kit_flutter_full_gpl/ffprobe_kit.dart';
import 'package:ffmpeg_kit_flutter_full_gpl/ffprobe_session.dart';
import 'package:ffmpeg_kit_flutter_full_gpl/return_code.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/cupertino.dart';
import 'package:mms_app/core/apis/encryption_tool.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:provider/provider.dart';
import 'package:uuid/uuid.dart';
import 'package:watcher/watcher.dart';

import '../../locator.dart';
import '../../views/widgets/colors.dart';
import '../../views/widgets/snackbar.dart';
import '../apis/video_api.dart';
import '../blocs/directory_bloc.dart';
import '../models/directory_model.dart';
import '../models/task_model.dart';
import '../navigation/navigator.dart';
import '../utils/custom_exception.dart';
import 'base_vm.dart';
import 'directory_vm.dart';

class VideoViewModel extends BaseModel {
  final VideoApi _api = locator<VideoApi>();
  String? error;

  Future<bool> _checkPermission() async {
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

  Future<String?> getVideoPath() async {
    bool val = await _checkPermission();
    if (!val) return null;
    FilePickerResult? result = await FilePicker.platform.pickFiles();

    if (result != null) {
      File picked = File(result.files.single.path!);
      return picked.path;
    } else
      return null;
  }

  Future<dynamic> createUploadSession(String dirId,
      {bool? pick = true, String? path}) async {
    String? videoPath;
    if (pick == true) {
      videoPath = await getVideoPath();
    } else {
      videoPath = path;
    }

    if (videoPath == null) return;
    setBusy(true);
    try {
      String sessionId = await _api.createUploadSession();
      watchFileSystem(videoPath, sessionId, dirId);
      setBusy(false);
    } on CustomException catch (e) {
      error = e.message;
      setBusy(false);
    }
    return null;
  }

  void watchFileSystem(String videoPath, String sessionId, String dirId) async {
    String outputPath = '$_localDirPath/$sessionId';
    Directory videoDir = Directory(outputPath);
    if (!videoDir.existsSync()) await videoDir.create();
    _encodeVideo(videoPath, sessionId, dirId);

    var watcher = DirectoryWatcher(outputPath);
    eventWatcher = watcher.events.listen((we) {
      _uploadChunk(we, sessionId);
    });
  }

  StreamSubscription? eventWatcher;
  var resolutions = [4320, 2160, 1080, 720, 480, 240];

  Completer? completer;

  Future<String> formatVideoType(String input, String sessionId) async {
    String mime = input.split('.').last;

    completer = Completer();
    String id = Uuid().v4();
    String newLoc = '$_localDirPath/$sessionId/$id.mp4';

    // convert to .mp4 if its .MOV
    if (mime == 'MOV') {
      String arg = '-i $input -vcodec h264 -acodec mp2 $newLoc';
      await FFmpegKit.executeWithArgumentsAsync(arg.split(' '), (a) {
        completer?.complete();
        log('I am done converting to mp4');
      });
      while (!completer!.isCompleted) {
        await Future.delayed(Duration(seconds: 1));
      }
      return newLoc;
    } else {
      return input;
    }
  }

  setEncodingBusy(bool state, String id, int progress, {int total = 12}) {
    if (state) {
      ZTask zTask = ZTask(
        message: 'Encoding Video',
        id: id,
        type: ZTaskType.CREATE_FILE,
        total: total,
        progress: progress,
      );
      directoryBloc.tasksToCheck[id] = zTask;
      directoryBloc.setAllTasks(directoryBloc.tasksToCheck);
      directoryBloc.tasksToCheck[id]?.progress = 2;
      directoryBloc.tasksToCheck[id]?.total = 10;
      directoryBloc.setAllTasks(directoryBloc.tasksToCheck);
    } else {
      directoryBloc.tasksToCheck.remove(id);
      directoryBloc.setAllTasks(directoryBloc.tasksToCheck);
    }
  }

  Future<void> _encodeVideo(
      String input, String sessionId, String dirId) async {
    setEncodingBusy(true, sessionId, 0);
    String oldLoc = await formatVideoType(input, sessionId);
    String newLoc = '$_localDirPath/$sessionId';

    // Get video width and height using FFprobe
    var ffProbeCmd =
        "-v error -select_streams v:0 -show_entries stream=width,height -of csv=s=x:p=0 $oldLoc";
    FFprobeSession session = await FFprobeKit.execute(ffProbeCmd);
    if (!ReturnCode.isSuccess(await session.getReturnCode())) {
      log('something bad happened');
      return;
    }

    var videoInfo = await session.getOutput();

    List<int> dimens = videoInfo!
        .trim()
        .split("x")
        .map((e) => int.parse(e))
        .toList(); // WxH 1920x1080x --> [1920, 1080]
    var width = dimens[0];
    var height = dimens[1];

    var resParams = [
      "-filter:v scale=ceil(iw*(4320/ih)/2)*2:4320 -c:v libx264 -preset medium -b:v 20000k -c:a aac -b:a 320k",
      "-filter:v scale=ceil(iw*(2160/ih)/2)*2:2160 -c:v libx264 -preset medium -b:v 10000k -c:a aac -b:a 320k",
      "-filter:v scale=ceil(iw*(1080/ih)/2)*2:1080 -c:v libx264 -preset medium -b:v 5000k -c:a aac -b:a 192k",
      "-filter:v scale=ceil(iw*(720/ih)/2)*2:720 -c:v libx264 -preset medium -b:v 2500k -c:a aac -b:a 128k",
      "-filter:v scale=ceil(iw*(480/ih)/2)*2:480 -c:v libx264 -preset medium -b:v 1000k -c:a aac -b:a 128k",
      "-filter:v scale=ceil(iw*(240/ih)/2)*2:240 -c:v libx264 -preset medium -b:v 600k -c:a aac -b:a 64k"
    ];
    var ffmpegCmd = ['-i', oldLoc];
    var masterPlaylist = "#EXTM3U\n#EXT-X-VERSION:3\n";

    int total = 0;
    for (int i = 0; i < resParams.length; i++) {
      var res = resolutions[i];
      var params = resParams[i];
      if (height >= res) {
        var resOutput = "$newLoc"; // "$newLoc/${res}p"
        _createFolder(resOutput);
        ffmpegCmd.addAll(params.split(" "));
        ffmpegCmd.add("-hls_time");
        ffmpegCmd.add("10");
        ffmpegCmd.add("-hls_list_size");
        ffmpegCmd.add("0");
        ffmpegCmd.add("-f");
        ffmpegCmd.add("hls");
        ffmpegCmd.add("$resOutput/${res}p.m3u8");
        var bandwidth = res * 1000;
        var newWidth = (res * width) / height;
        var resolution = '${newWidth.toInt()}x$res';
        masterPlaylist =
            "$masterPlaylist#EXT-X-STREAM-INF:BANDWIDTH=$bandwidth,RESOLUTION=$resolution\n";
        masterPlaylist = "$masterPlaylist${res}p/${res}p.m3u8\n";
        total = total + 1;
      }
    }
    setEncodingBusy(true, sessionId, 0, total: total);

    await _createMasterFile(masterPlaylist, newLoc);
    await _createEncryptionKey(newLoc);

    FFmpegKit.executeWithArgumentsAsync(ffmpegCmd, (a) {
      log('I am done');
      setEncodingBusy(false, sessionId, 12);
      _uploadManifests(input, sessionId, dirId);
    }).then((session) async {
      final returnCode = await session.getReturnCode();

      if (ReturnCode.isSuccess(returnCode)) {
        log('SUCCESS');
        // SUCCESS
      } else if (ReturnCode.isCancel(returnCode)) {
        log('CANCEL');
        // CANCEL
      } else {
        log('ERROR: $returnCode}');
        // ERROR
      }
    });
    return;
  }

  static String? _localDirPath;

  Future<String?> _findLocalPath() async {
    final Directory directory = Platform.isAndroid
        ? Directory(await ExternalPath.getExternalStoragePublicDirectory(
            ExternalPath.DIRECTORY_DOWNLOADS))
        : await getApplicationDocumentsDirectory();

    return directory.path;
  }

  Future<void> prepareJobsDir() async {
    final String? path = await _findLocalPath();
    _localDirPath = '$path/jobs';

    final Directory savedDir = Directory(_localDirPath!);
    if (!savedDir.existsSync()) savedDir.create();
  }

  Future<void> _createFolder(String path) async {
    Directory dir = Directory(path);
    if (!dir.existsSync()) await dir.create();
  }

  Future<void> _createMasterFile(String master, String path) async {
    File file = File('$path/master.m3u8');
    if (!file.existsSync()) await file.create();
    await file.writeAsString(master);
  }

  Future<void> _createEncryptionKey(String path) async {
    Map<String, String> base64Keys = EncryptionTool.generateKeys();
    File file = File('$path/keys.m3u8');
    if (!file.existsSync()) await file.create();
    await file.writeAsString(jsonEncode(base64Keys));
  }

  Future<dynamic> _readEncryptionKey(String path) async {
    File file = File('$path/keys.m3u8');
    if (!file.existsSync()) return null;
    String a = await file.readAsString();
    return jsonDecode(a);
  }

  Future<void> _deleteChunkAfterUploading(String path) async {
    File file = File(path);
    if (file.existsSync()) await file.delete();
  }

  Future<void> _completeJobAfter(String path) async {
    Directory dir = Directory(path);
    if (dir.existsSync()) {
      // delete all files linearly
      for (var f in dir.listSync()) {
        await f.delete();
      }
      await dir.delete();
    }
  }

  _uploadManifests(String input, String sessionId, String dirId) async {
    String name = input.split('/').last;
    String mime = input.split('.').last;
    String jobPath = '$_localDirPath/$sessionId';
    String masterManifestPath = '$jobPath/master.m3u8';
    File file = File(masterManifestPath);
    dynamic keys = await _readEncryptionKey(jobPath);
    if (keys == null) return;
    FormData forms = FormData();
    forms.fields.add(MapEntry('directoryId', dirId));
    forms.fields.add(MapEntry('decryptionKey', keys['decryptionKey']));
    forms.fields.add(MapEntry('mimeType', mime));
    forms.fields.add(MapEntry('fileName', name));

    if (file.existsSync()) {
      forms.files.add(
        MapEntry(
          'master',
          await MultipartFile.fromFile(masterManifestPath,
              filename: 'master.m3u8'),
        ),
      );
    }

    for (int res in resolutions) {
      String resolution = '${res}p';
      String resManifestPath = '$jobPath/$resolution.m3u8';
      File file = File(resManifestPath);
      if (!file.existsSync()) continue;
      forms.files.add(
        MapEntry(
          resolution,
          await MultipartFile.fromFile(resManifestPath,
              filename: '$resolution.m3u8'),
        ),
      );
    }

    timer = Timer.periodic(Duration(seconds: 1), (a) async {
      Directory dir = Directory(jobPath);
      List<FileSystemEntity> files = dir.listSync();
      if (files.any((element) => element.path.split('.').last == 'ts')) {
        // meaning we still have .ts files still uploading/waiting to be
        // uploaded, hence run again until there's no .ts file
        // if not, then complete session
        return;
      }
      timer?.cancel();
      eventWatcher?.cancel();
      try {
        DirectoryModel created =
            await _api.completeUploadSession(forms, sessionId);
        _completeJobAfter(jobPath);
        context.read<DirectoryViewModel>().setParentFiles([created]);
        context.read<DirectoryViewModel>().updateHomeDir(doc: created);

        setBusy(false);
      } on CustomException catch (e) {
        error = e.message;
        setBusy(false);
      }
    });
  }

  Timer? timer;

  int chunkCounter = 0;
  _uploadChunk(WatchEvent a, String sessionId) async {
    String path = a.path;
    String mime = path.split('.').last;
    // ignore manifests files
    if (mime == 'm3u8' || mime == 'mp4') return;

    File file = File(path);
    if (!file.existsSync()) return;

    // encrypt before uploading
    dynamic keys = await _readEncryptionKey('$_localDirPath/$sessionId');
    Uint8List? bytes = await EncryptionTool.encryptDataWithKeys(file, keys);
    if (bytes == null) return;

    print(a.toString());
    if (a.type.toString() == 'add') {
      try {
        await _api.uploadChunk(sessionId, path, bytes);
        chunkCounter++;
        directoryBloc.tasksToCheck[sessionId]?.progress = chunkCounter;
        directoryBloc.setAllTasks(directoryBloc.tasksToCheck);
        _deleteChunkAfterUploading(path);
        setBusy(false);
      } on CustomException catch (e) {
        error = e.message;
        setBusy(false);
      }
    }
  }

  BuildContext get context => AppNavigator.navKey.currentContext!;

  void showDialog(String e, [String? title]) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      showSnackBar(
        context,
        title ?? 'Error',
        e.toTitleCase(),
        duration: 2,
        color: title == null ? AppColors.red : AppColors.primaryColor,
      );
    });
  }
}
