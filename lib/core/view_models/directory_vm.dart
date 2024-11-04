import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/cupertino.dart';
import 'package:mms_app/core/apis/directory_api.dart';
import 'package:mms_app/core/models/directory_model.dart';
import 'package:mms_app/core/storage/local_storage.dart';
import 'package:provider/provider.dart';

import '../../locator.dart';
import '../../views/widgets/colors.dart';
import '../../views/widgets/snackbar.dart';
import '../blocs/directory_bloc.dart';
import '../models/user_model.dart';
import '../navigation/navigator.dart';
import '../utils/custom_exception.dart';
import 'base_vm.dart';

class DirectoryViewModel extends BaseModel {
  final DirectoryApi _authApi = locator<DirectoryApi>();

  Map<String, Map<String, List<DirectoryModel>>> parentDirectories = {};
  Map<String, Map<String, List<DirectoryModel>>>? homeDirectories;

  // helper methods to save the dirs/files in memory(context) before syncing online
  void setParentDirectories(
    List<DirectoryModel>? dirs, {
    List<DirectoryModel>? files,
  }) {
    if (dirs == null) return;

    dirs.forEach((DirectoryModel element) {
      String? parentID = element.parentID;
      String? iD = element.id;
      if (parentID == null || iD == null) return;

      if (parentDirectories[parentID] == null) parentDirectories[parentID] = {};
      Map<String, List<DirectoryModel>> parentDir =
          parentDirectories[parentID]!;
      parentDir[iD] = [element];

      parentDirectories[parentID] = parentDir;
    });

    // add files to dir
    if (files?.isNotEmpty ?? false) {
      String parentID = files!.first.directoryID!;
      if (files.first.directoryID ==
          parentID) if (parentDirectories[parentID] == null)
        parentDirectories[parentID] = {};
      parentDirectories[parentID]?['files'] = files;
    }

    directoryBloc.setParentDirectories(parentDirectories);
    notifyListeners();
  }

  void setParentFiles(List<DirectoryModel>? files, {bool delete = false}) {
    if (files == null) return;

    files.forEach((element) {
      String? parentID = element.directoryID;
      if (parentDirectories[parentID] == null)
        parentDirectories[parentID!] = {};
      if (parentDirectories[parentID]?['files'] == null)
        parentDirectories[parentID!]?['files'] = [];
      parentDirectories[parentID!]?['files']
          ?.removeWhere((e) => e.id == element.id);
      if (!delete) parentDirectories[parentID]?['files']?.addAll(files);
    });
    directoryBloc.setParentDirectories(parentDirectories);
  }

  void setHomeFiles(
      List<DirectoryModel>? dirs, List<DirectoryModel>? files, bool recent) {
    if (homeDirectories == null) homeDirectories = {};

    String type = recent ? 'recent' : 'favorite';
    if (homeDirectories?[type] == null) homeDirectories?[type] = {};
    if (files != null) homeDirectories?[type]?['files'] = files;
    if (dirs != null) homeDirectories?[type]?['dirs'] = dirs;

    directoryBloc.setHomeDirectories(homeDirectories!);
  }

  void setHomeFiltered(
      List<DirectoryModel>? dirs, List<DirectoryModel>? files) {
    if (homeDirectories == null) homeDirectories = {};

    String type = dirs == null ? 'files' : 'folders';
    if (homeDirectories?[type] == null) homeDirectories?[type] = {};
    if (files != null) homeDirectories?['files']?['files'] = files;
    if (dirs != null) homeDirectories?['folders']?['folders'] = dirs;

    directoryBloc.setHomeDirectories(homeDirectories!);
  }

  void updateHomeDir({DirectoryModel? doc, bool delete = false}) {
    if (homeDirectories == null) homeDirectories = {};

    if (homeDirectories?['file'] == null) homeDirectories?['file'] = {};
    if (homeDirectories?['folders'] == null) homeDirectories?['folders'] = {};
    // if (homeDirectories?['recent']?['dirs'] == null)
    //   homeDirectories?['recent']?['dirs'] = [];
    // if (homeDirectories?['recent']?['files'] == null)
    //   homeDirectories?['recent']?['files'] = [];
    // if (homeDirectories?['favorite']?['dirs'] == null)
    //   homeDirectories?['favorite']?['dirs'] = [];
    // if (homeDirectories?['favorite']?['files'] == null)
    //   homeDirectories?['favorite']?['files'] = [];
    bool isFile = doc?.parentID == null;

    if (isFile) {
      homeDirectories?['files']?['files']?.removeWhere((e) => e.id == doc?.id);
      if (!delete) homeDirectories?['files']?['files']?.add(doc!);
      homeDirectories?['files']?['files']?.removeWhere((e) => e.id == doc?.id);
      if (!delete) homeDirectories?['files']?['files']?.add(doc!);
    } else {
      homeDirectories?['folders']?['folders']
          ?.removeWhere((e) => e.id == doc?.id);
      if (!delete) homeDirectories?['folders']?['folders']?.add(doc!);
      homeDirectories?['folders']?['folders']
          ?.removeWhere((e) => e.id == doc?.id);
      if (!delete) homeDirectories?['folders']?['folders']?.add(doc!);
    }

    directoryBloc.setHomeDirectories(homeDirectories!);
  }

  String? callError;
  Future<bool> createDir(Map<String, dynamic> a) async {
    callError = null;
    setBusy(true);
    try {
      DirectoryModel created = await _authApi.createDir(a);
      setBusy(false);
      context.read<DirectoryViewModel>().setParentDirectories([created]);
      context.read<DirectoryViewModel>().updateHomeDir(doc: created);
      showDialog('Directory has been created', 'Success');
      notifyListeners();
      return true;
    } on CustomException catch (e) {
      callError = e.message;
      setBusy(false);
      return false;
    }
  }

  Future<bool> renameDir(Map<String, dynamic> a) async {
    callError = null;
    setBusy(true);
    try {
      DirectoryModel edited = await _authApi.renameDir(a);
      setBusy(false);
      context.read<DirectoryViewModel>().setParentDirectories([edited]);
      context.read<DirectoryViewModel>().updateHomeDir(doc: edited);
      showDialog('Directory has been renamed', 'Success');
      return true;
    } on CustomException catch (e) {
      callError = e.message;
      setBusy(false);
      return false;
    }
  }

  Future<bool> deleteOneDir(DirectoryModel data) async {
    callError = null;
    setBusy(true);
    try {
      String deleted = await _authApi.deleteOneDir(data.id!);
      setBusy(false);
      DirectoryViewModel vm = context.read<DirectoryViewModel>();
      // remove the folder and directories from the list
      vm.parentDirectories.removeWhere((key, value) => key == data.id);
      // remove the folder and directories from the parent list
      vm.parentDirectories[data.directoryID ?? data.parentID]!
          .removeWhere((key, value) => key == data.id);
      context.read<DirectoryViewModel>().setParentDirectories([]);
      showDialog(deleted, 'Success');
      context.read<DirectoryViewModel>().updateHomeDir(doc: data, delete: true);
      notifyListeners();
      return true;
    } on CustomException catch (e) {
      callError = e.message;
      setBusy(false);
      showDialog(e.message);
      return false;
    }
  }

  Future<bool> deleteManyDir(
      List<String> dirIds, List<String> fileIds, String parentId) async {
    callError = null;
    setBusy(true);
    print(dirIds);
    print(fileIds);
    try {
      await _authApi.deleteManyDir(dirIds);
      await _authApi.deleteManyFiles(fileIds);
      setBusy(false);
      DirectoryViewModel vm = context.read<DirectoryViewModel>();

      for (String id in dirIds) {
        DirectoryModel data = vm.parentDirectories[parentId]![id]!.first;
        // remove the folder and directories from the list
        vm.parentDirectories.removeWhere((key, value) => key == data.id);
        // remove the folder and directories from the parent list
        vm.parentDirectories[data.directoryID ?? data.parentID]!
            .removeWhere((key, value) => key == data.id);
        context.read<DirectoryViewModel>().setParentDirectories([]);
        context
            .read<DirectoryViewModel>()
            .updateHomeDir(doc: data, delete: true);
      }

      for (String id in fileIds) {
        List<DirectoryModel> files = vm.parentDirectories[parentId]!['files']!;
        DirectoryModel data = files.firstWhere((e) => e.id == id);
        context.read<DirectoryViewModel>().setParentFiles([data], delete: true);
        context
            .read<DirectoryViewModel>()
            .updateHomeDir(doc: data, delete: true);
      }
      showDialog('Files/Directories Deleted', 'Success');
      return true;
    } on CustomException catch (e) {
      callError = e.message;
      setBusy(false);
      showDialog(e.message);
      return false;
    }
  }

  DirectoryModel? sharedDir;
  Future<void> getSharedDir() async {
    callError = null;
    setBusy(true);
    try {
      sharedDir = await _authApi.getSharedDir();
      setBusy(false);
    } on CustomException catch (e) {
      callError = e.message;
      setBusy(false);
    }
  }

  DirectoryModel? sharedFiles;
  Future<void> getSharedFiles() async {
    callError = null;
    setBusy(true);
    try {
      sharedFiles = await _authApi.getSharedFiles();
      setBusy(false);
    } on CustomException catch (e) {
      callError = e.message;
      setBusy(false);
    }
  }

  DirectoryModel? oneDirectory;
  Future<void> getOneDir(String id) async {
    callError = null;
    setBusy(true);
    try {
      oneDirectory = await _authApi.getOneDir(id);
      context.read<DirectoryViewModel>().setParentDirectories(
            oneDirectory?.subDirectories!,
            files: oneDirectory?.files,
          );
      setBusy(false);
    } on CustomException catch (e) {
      callError = e.message;
      setBusy(false);
    }
  }

  DirectoryModel? oneFile;
  Future<void> getOneFile(String id) async {
    callError = null;
    setBusy(true);
    try {
      oneFile = await _authApi.getOneFile(id);
      /*   context.read<DirectoryViewModel>().setParentDirectories(
            oneDirectory?.subDirectories!,
            files: oneDirectory?.files,
          );
 */
      setBusy(false);
    } on CustomException catch (e) {
      callError = e.message;
      setBusy(false);
    }
  }

  List<User>? peopleAccess;
  Future<void> getUserDataList(DirectoryModel dir, BuildContext context) async {
    callError = null;
    setBusy(true);
    try {
      List<String>? sharedWith = dir.sharedWith;
      print('sharedWith: ${sharedWith?.length}');
      await allUsers(context);
      if (sharedWith == null) {
        setBusy(true);
        bool isFile = dir.parentID == null;
        DirectoryModel directoryModel = isFile
            ? await _authApi.getOneFile(dir.id!)
            : await _authApi.getOneDir(dir.id!);
        sharedWith = directoryModel.sharedWith;
      }

      List<User>? all = context.read<DirectoryViewModel>().allUsersList;

      peopleAccess = [];
      for (String id in sharedWith!) {
        User? u = all!.firstWhere((e) => id == e.id);
        peopleAccess!.add(u);
      }
      setBusy(false);
    } on CustomException catch (e) {
      callError = e.message;
      setBusy(false);
    }
  }

  String? rootId;
  Future<void> fetchRootDirs() async {
    callError = null;
    setBusy(true);
    try {
      DirectoryModel root = await _authApi.fetchRootDirs();
      rootId = root.id;
      directoryBloc.setRootId(rootId ?? directoryBloc.rootId ?? '');
      User user = AppCache.getUser()!;
      user.rootId = rootId;
      AppCache.setUser(user);
      context
          .read<DirectoryViewModel>()
          .setParentDirectories(root.subDirectories, files: root.files);
      setBusy(false);
    } on CustomException catch (e) {
      callError = e.message;
      setBusy(false);
    }
  }

  Future<void> getDirsBasedOnFlag({
    bool recent = false,
    bool favorite = false,
    bool directory = false,
    bool file = false,
    int page = 1,
  }) async {
    callError = null;
    setBusy(true);
    try {
      DirectoryModel root = await _authApi.getDirsBasedOnFlag(
          recent: recent,
          favorite: favorite,
          directory: directory,
          file: file,
          page: page);
      rootId = root.id;
      directoryBloc.setRootId(rootId ?? directoryBloc.rootId ?? '');
      context
          .read<DirectoryViewModel>()
          .setHomeFiles(root.subDirectories, root.files, recent);
      setBusy(false);
    } on CustomException catch (e) {
      callError = e.message;
      setBusy(false);
    }
  }

  Future<void> getDirsFiltered({
    bool recent = false,
    bool favorite = false,
    bool directory = false,
    bool file = false,
    int page = 1,
  }) async {
    callError = null;
    setBusy(true);
    try {
      DirectoryModel root = await _authApi.getDirsFiltered(
          directory: directory, file: file, page: page);
      rootId = root.id;
      directoryBloc.setRootId(rootId ?? directoryBloc.rootId ?? '');

      context
          .read<DirectoryViewModel>()
          .setHomeFiltered(root.subDirectories, root.files);
      setBusy(false);
    } on CustomException catch (e) {
      callError = e.message;
      setBusy(false);
    }
  }

  ///=====================================================================///
  ///===============================FILES=================================///
  ///=====================================================================///

  Future<bool> createFile(String dirId, List<File> data) async {
    callError = null;
    setBusy(true);
    try {
      DirectoryModel created = await _authApi.createFile(dirId, data);
      context.read<DirectoryViewModel>().setParentFiles([created]);
      context.read<DirectoryViewModel>().updateHomeDir(doc: created);
      setBusy(false);
      showDialog('File has been created', 'Success');
      return true;
    } on CustomException catch (e) {
      callError = e.message;
      setBusy(false);
      return false;
    }
  }

  Future<bool> renameFile(String id, String name) async {
    callError = null;
    setBusy(true);
    try {
      DirectoryModel edited = await _authApi.renameFile(id, name);
      context.read<DirectoryViewModel>().setParentFiles([edited]);
      context.read<DirectoryViewModel>().updateHomeDir(doc: edited);
      setBusy(false);
      showDialog('File has been renamed', 'Success');
      return true;
    } on CustomException catch (e) {
      callError = e.message;
      setBusy(false);
      return false;
    }
  }

  Future<bool> deleteFile(DirectoryModel data) async {
    callError = null;
    setBusy(true);
    try {
      await _authApi.deleteFile(data.id!);
      setBusy(false);
      context.read<DirectoryViewModel>().setParentFiles([data], delete: true);
      context.read<DirectoryViewModel>().updateHomeDir(doc: data, delete: true);
      showDialog('File has been deleted', 'Success');
      return true;
    } on CustomException catch (e) {
      callError = e.message;
      setBusy(false);
      showDialog(e.message);
      return false;
    }
  }

  Future<bool> favorite(DirectoryModel data, bool like) async {
    callError = null;
    setBusy(true);
    bool isFile = data.parentID == null;
    try {
      await _authApi.favorite(data, like: like);
      setBusy(false);
      showDialog(
        '${isFile ? 'File' : 'Directory'} has been ${like ? 'added' : 'removed'} to favorites',
        'Success',
      );
      return true;
    } on CustomException catch (e) {
      callError = e.message;
      setBusy(false);
      return false;
    }
  }

  Uint8List? presentFile;
  Future<bool> getFile(String id) async {
    callError = null;
    setBusy(true);
    try {
      presentFile = await _authApi.getFile(id);
      setBusy(false);
      return true;
    } on CustomException catch (e) {
      callError = e.message;
      setBusy(false);
      return false;
    }
  }

  Future<List<KeyAndId>?> getAllDirKeys(String id) async {
    callError = null;
    setBusy(true);
    try {
      List<KeyAndId>? list = await _authApi.getAllDirKeys(id);
      setBusy(false);
      return list;
    } on CustomException catch (e) {
      callError = e.message;
      setBusy(false);
      showDialog('Error getting file keys', 'Error');
      return null;
    }
  }

  Future<bool> addPrivilege(List<Map<String, dynamic>> all, bool isFile) async {
    callError = null;
    setBusy(true);
    try {
      isFile
          ? await _authApi.addFilePrivilege(all)
          : await _authApi.addDirPrivilege(all);
      setBusy(false);
      showDialog(
          'Permission has been granted to the ${isFile ? 'File' : 'Directory'}',
          'Success');
      AppNavigator.doPop();
      return true;
    } on CustomException catch (e) {
      callError = e.message;
      setBusy(false);
      showDialog(
          'Permission has already been granted to the ${isFile ? 'File' : 'Directory'}',
          'Failed');
      return false;
    }
  }

  List<User>? allUsersList;

  Future<List<User>?> allUsers(BuildContext context) async {
    callError = null;
    if (context.read<DirectoryViewModel>().allUsersList != null) {
      return allUsersList;
    }
    setBusy(true);
    try {
      List<User> all = await _authApi.allUsers();
      setBusy(false);
      context.read<DirectoryViewModel>().allUsersList = all;
      return all;
    } on CustomException catch (e) {
      callError = e.message;
      setBusy(false);
      return [];
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
