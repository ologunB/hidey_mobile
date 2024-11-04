import 'dart:async';

import '../../views/widgets/bloc_provider.dart';
import '../models/directory_model.dart';
import '../models/task_model.dart';

class DirectoryBloc implements BlocBase {
  Map<String, ZTask> tasksToCheck = {};

  // Streams to update parent dirs
  final StreamController<Map<String, Map<String, List<DirectoryModel>>>>
      _parentDirsController = StreamController<
          Map<String, Map<String, List<DirectoryModel>>>>.broadcast();
  Sink<Map<String, Map<String, List<DirectoryModel>>>> get _inParentDirs =>
      _parentDirsController.sink;
  Stream<Map<String, Map<String, List<DirectoryModel>>>> get outParentDirs =>
      _parentDirsController.stream;

  // Streams to update parent dirs
  final StreamController<Map<String, Map<String, List<DirectoryModel>>>>
      _homeDirsController = StreamController<
          Map<String, Map<String, List<DirectoryModel>>>>.broadcast();
  Sink<Map<String, Map<String, List<DirectoryModel>>>> get _inHomeDirs =>
      _homeDirsController.sink;
  Stream<Map<String, Map<String, List<DirectoryModel>>>> get outHomeDirs =>
      _homeDirsController.stream;

  // Streams to show download progress
  final StreamController<Map<String, ZTask>> _downloadProgressController =
      StreamController<Map<String, ZTask>>.broadcast();
  Sink<Map<String, ZTask>> get _inDownloadProgress =>
      _downloadProgressController.sink;
  Stream<Map<String, ZTask>> get outDownloadProgress =>
      _downloadProgressController.stream;

  String? rootId;
  // Streams to update root id
  final StreamController<String> _rootIdController =
      StreamController<String>.broadcast();
  Sink<String> get _inRootId => _rootIdController.sink;
  Stream<String> get outRootId => _rootIdController.stream;

  @override
  void dispose() {
    _parentDirsController.close();
    _downloadProgressController.close();
    _homeDirsController.close();
    _rootIdController.close();
  }

  void setParentDirectories(
      Map<String, Map<String, List<DirectoryModel>>> data) {
    _inParentDirs.add(data);
  }

  void setHomeDirectories(Map<String, Map<String, List<DirectoryModel>>> data) {
    _inHomeDirs.add(data);
  }

  void setAllTasks(Map<String, ZTask> data) {
    _inDownloadProgress.add(data);
  }

  void setRootId(String data) {
    rootId = data;
    _inRootId.add(data);
  }
}

DirectoryBloc directoryBloc = DirectoryBloc();
