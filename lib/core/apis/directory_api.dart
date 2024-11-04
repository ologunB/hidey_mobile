import 'dart:io';
import 'dart:typed_data';

import 'package:dio/dio.dart';
import 'package:flutter_downloader/flutter_downloader.dart';
import 'package:mms_app/core/apis/encryption_tool.dart';
import 'package:mms_app/core/blocs/directory_bloc.dart';
import 'package:mms_app/core/models/task_model.dart';
import 'package:mms_app/core/utils/custom_exception.dart';
import 'package:mms_app/core/utils/error_util.dart';
import 'package:path_provider/path_provider.dart';
import 'package:uuid/uuid.dart';

import '../models/directory_model.dart';
import '../models/user_model.dart';
import 'base_api.dart';

class DirectoryApi extends BaseAPI {
  Future<DirectoryModel> createDir(Map<String, dynamic> data) async {
    String url = 'directory';
    log(data);
    try {
      final Response<dynamic> res = await dio().post<dynamic>(
        url,
        data: data,
        onSendProgress: (a, b) {
          print({a, b});
        },
      );
      log(res.data);
      switch (res.statusCode) {
        case 200:
          return DirectoryModel.fromJson(res.data['data']);
        case 400:
          throw (res.data['data'] as Map).values.join('\n');
        default:
          throw res.data['message'];
      }
    } catch (e) {
      print(e);
      log(e);
      throw CustomException(DioErrorUtil.handleError(e));
    }
  }

  Future<DirectoryModel> renameDir(Map<String, dynamic> data) async {
    String url = 'directory/${data['ParentID']}/rename';
    log(data);
    try {
      final Response<dynamic> res = await dio().put<dynamic>(url, data: data);
      log(res.data);
      switch (res.statusCode) {
        case 200:
          return DirectoryModel.fromJson(res.data['data']);
        case 400:
          throw (res.data['data'] as Map).values.join('\n');
        default:
          throw res.data['message'];
      }
    } catch (e) {
      log(e);
      throw CustomException(DioErrorUtil.handleError(e));
    }
  }

  Future<DirectoryModel> fetchRootDirs() async {
    String url = 'directory';
    try {
      final Response<dynamic> res = await dio().get<dynamic>(url);
      log(res.data);
      switch (res.statusCode) {
        case 200:
          try {
            return DirectoryModel.fromJson(res.data['data']);
          } catch (e) {
            throw PARSING_ERROR;
          }
        default:
          throw res.data['message'];
      }
    } catch (e) {
      log(e);
      throw CustomException(DioErrorUtil.handleError(e));
    }
  }

  // recent, starred, archived, thrashed, shared, locked
  Future<DirectoryModel> getDirsBasedOnFlag({
    bool recent = false,
    bool favorite = false,
    bool directory = false,
    bool file = false,
    int page = 1,
  }) async {
    String prefix = recent
        ? 'recent'
        : favorite
            ? 'starred'
            : directory
                ? 'directory'
                : 'file';
    String url = 'directory/all?filter=$prefix';
    print(url);
    try {
      final Response<dynamic> res = await dio().get<dynamic>(url);
      log(res.data);
      switch (res.statusCode) {
        case 200:
          List<DirectoryModel> dirs = [];
          res.data['data'].forEach((a) {
            dirs.add(DirectoryModel.fromJson(a));
          });
          try {
            return DirectoryModel(subDirectories: dirs);
          } catch (e) {
            throw PARSING_ERROR;
          }
        default:
          throw res.data['message'];
      }
    } catch (e) {
      log(e);
      throw CustomException(DioErrorUtil.handleError(e));
    }
  }

  // Folders Files
  Future<DirectoryModel> getDirsFiltered({
    bool directory = false,
    bool file = false,
    int page = 1,
  }) async {
    String url = 'directory?directory=$directory&file=$file';

    print(url);
    try {
      final Response<dynamic> res = await dio().get<dynamic>(url);
      log(res.data);

      switch (res.statusCode) {
        case 200:
          try {
            return DirectoryModel.fromJson(res.data['data']);
          } catch (e) {
            throw PARSING_ERROR;
          }
        default:
          throw res.data['message'];
      }
    } catch (e) {
      log(e);
      throw CustomException(DioErrorUtil.handleError(e));
    }
  }

  Future<DirectoryModel> getSharedDir() async {
    String url = 'directory/all?filter=shared';
    print(url);
    try {
      final Response<dynamic> res = await dio().get<dynamic>(url);
      log(res.data);
      switch (res.statusCode) {
        case 200:
          List<DirectoryModel> dirs = [];
          res.data['data'].forEach((a) {
            dirs.add(DirectoryModel.fromJson(a));
          });
          try {
            return DirectoryModel(subDirectories: dirs);
          } catch (e) {
            throw PARSING_ERROR;
          }
        default:
          throw res.data['message'];
      }
    } catch (e) {
      log(e);
      throw CustomException(DioErrorUtil.handleError(e));
    }
  }

  Future<DirectoryModel> getSharedFiles() async {
    String url = 'file/all?filter=shared';
    print(url);
    try {
      final Response<dynamic> res = await dio().get<dynamic>(url);
      log(res.data);
      switch (res.statusCode) {
        case 200:
          List<DirectoryModel> dirs = [];
          res.data['data'].forEach((a) {
            dirs.add(DirectoryModel.fromJson(a));
          });
          try {
            return DirectoryModel(subDirectories: dirs);
          } catch (e) {
            throw PARSING_ERROR;
          }
        default:
          throw res.data['message'];
      }
    } catch (e) {
      log(e);
      throw CustomException(DioErrorUtil.handleError(e));
    }
  }

  Future<DirectoryModel> getOneDir(String id) async {
    String url = 'directory/$id';
    print(id);
    try {
      final Response<dynamic> res = await dio().get<dynamic>(url);
      log(res.data);
      switch (res.statusCode) {
        case 200:
          return DirectoryModel.fromJson(res.data['data']);
        default:
          throw res.data['message'];
      }
    } catch (e) {
      log(e);
      throw CustomException(DioErrorUtil.handleError(e));
    }
  }

  Future<DirectoryModel> getOneFile(String id) async {
    String url = 'file/$id';
    print(id);
    try {
      final Response<dynamic> res = await dio().get<dynamic>(url);
      log(res.data);
      switch (res.statusCode) {
        case 200:
          return DirectoryModel.fromJson(res.data['data']);
        default:
          throw res.data['message'];
      }
    } catch (e) {
      log(e);
      throw CustomException(DioErrorUtil.handleError(e));
    }
  }

  Future<String> deleteOneDir(String id) async {
    String url = 'directory/$id';
    try {
      final Response<dynamic> res = await dio().delete<dynamic>(url);
      log(res.statusCode);
      switch (res.statusCode) {
        case 200:
          return res.data['message'];
        default:
          throw res.data['message'];
      }
    } catch (e) {
      log(e);
      throw CustomException(DioErrorUtil.handleError(e));
    }
  }

  Future<String> deleteManyDir(List<String> ids) async {
    String url = 'directory';
    try {
      final Response<dynamic> res = await dio().delete<dynamic>(
        url,
        data: {'directoryIds': ids},
      );
      log(res.data);
      switch (res.statusCode) {
        case 200:
          return res.data['message'];
        default:
          throw res.data['message'];
      }
    } catch (e) {
      log(e);
      throw CustomException(DioErrorUtil.handleError(e));
    }
  }

  Future<String> deleteManyFiles(List<String> ids) async {
    String url = 'file';
    try {
      final Response<dynamic> res = await dio().delete<dynamic>(
        url,
        data: {'fileIds': ids},
      );
      log(res.data);
      switch (res.statusCode) {
        case 200:
          return res.data['message'];
        default:
          throw res.data['message'];
      }
    } catch (e) {
      log(e);
      throw CustomException(DioErrorUtil.handleError(e));
    }
  }

  Future<DirectoryModel> createFile(String dirId, List<File> data) async {
    String url = 'file/upload?directoryId=$dirId';
    String id = Uuid().v4();
    FormData forms = FormData();
    for (File f in data) {
      EncryptedFile encryptedFile = await EncryptionTool.encryptData(f);
      String name = f.path.split('/').last;
      String mime = f.path.split('.').last;
      forms.files.add(
        MapEntry(
          'file',
          MultipartFile.fromBytes(encryptedFile.file, filename: name),
        ),
      );
      forms.fields.add(MapEntry('mimeType', mime));
      forms.fields.add(MapEntry('decryptionKey', encryptedFile.key));
      ZTask zTask = ZTask(
        message: name,
        id: id,
        type: ZTaskType.CREATE_FILE,
        total: 1000,
        progress: 10,
      );
      directoryBloc.tasksToCheck[id] = zTask;
      directoryBloc.setAllTasks(directoryBloc.tasksToCheck);
    }

    try {
      final Response<dynamic> res = await dio().post<dynamic>(
        url,
        data: forms,
        onSendProgress: (a, b) {
          directoryBloc.tasksToCheck[id]?.progress = a;
          directoryBloc.tasksToCheck[id]?.total = b;
          directoryBloc.setAllTasks(directoryBloc.tasksToCheck);
        },
        onReceiveProgress: (a, b) {
          if (a == b) directoryBloc.tasksToCheck.remove(id);
          directoryBloc.setAllTasks(directoryBloc.tasksToCheck);
        },
      );
      log(res.data);
      switch (res.statusCode) {
        case 200:
          DirectoryModel dir = DirectoryModel.fromJson(res.data['data']);
          return dir;
        case 400:
          throw (res.data['data'] as Map).values.join('\n');
        default:
          throw res.data['message'];
      }
    } catch (e) {
      directoryBloc.tasksToCheck.remove(id);
      directoryBloc.setAllTasks(directoryBloc.tasksToCheck);
      log(e);
      throw CustomException(DioErrorUtil.handleError(e));
    }
  }

  Future<DirectoryModel> renameFile(String id, String name) async {
    String url = 'file/$id/rename';
    try {
      final Response<dynamic> res = await dio().put<dynamic>(
        url,
        data: {"Name": name},
      );

      log(res.data);
      switch (res.statusCode) {
        case 200:
          return DirectoryModel.fromJson(res.data['data']);
        case 400:
          throw (res.data['data'] as Map).values.join('\n');
        default:
          throw res.data['message'];
      }
    } catch (e) {
      log(e);
      throw CustomException(DioErrorUtil.handleError(e));
    }
  }

  Future<String> deleteFile(String id) async {
    String url = 'file/$id';
    try {
      final Response<dynamic> res = await dio().delete<dynamic>(url);
      log(res.data);
      switch (res.statusCode) {
        case 200:
          return res.data['message'];
        default:
          throw res.data['message'];
      }
    } catch (e) {
      log(e);
      throw CustomException(DioErrorUtil.handleError(e));
    }
  }

  Future<String> favorite(DirectoryModel data, {bool like = true}) async {
    String url =
        '${data.parentID == null ? 'file' : 'directory'}/${data.id}/favorite';
    try {
      final Response<dynamic> res;
      if (like) {
        res = await dio().post<dynamic>(url);
      } else {
        res = await dio().delete<dynamic>(url);
      }

      log(res.data);
      switch (res.statusCode) {
        case 200:
          return res.data['message'];
        default:
          throw res.data['message'];
      }
    } catch (e) {
      log(e);
      throw CustomException(DioErrorUtil.handleError(e));
    }
  }

  String? _tempPath;

  Future<void> _prepareSaveDir() async {
    final String path = (await getTemporaryDirectory()).path;
    _tempPath = path + Platform.pathSeparator + 'TempsFiles';

    final Directory savedDir = Directory(_tempPath!);
    final bool hasExisted = await savedDir.exists();
    if (!hasExisted) {
      savedDir.create();
    }
  }

  Future<Uint8List> getFile(String id) async {
    await _prepareSaveDir();
/*    try {
 */
    String url = 'file/$id/download';
    try {
/*      await FlutterDownloader.cancelAll();
      final taskId = await FlutterDownloader.enqueue(
        url:
            'https://cartographicperspectives.org/index.php/journal/article/download/cp50-issue/pdf/2147' ??
                '${dio().options.baseUrl}file/$id',
        //   headers: dio().options.headers.cast(),
        savedDir: _tempPath!,
        fileName: id,
        showNotification: true,
        openFileFromNotification: true,
        saveInPublicStorage: true,
      );
      print(taskId);*/
      final Response<dynamic> res = await dio().get<dynamic>(
        url,
        options: Options(
          responseType: ResponseType.bytes,
          followRedirects: false,
          validateStatus: (status) {
            return status! < 500;
          },
        ),
      );
      print(res.statusCode);
      switch (res.statusCode) {
        case 200:

          /*     File file = File('$_tempPath/$id');
          if (!file.existsSync()) file.createSync();
          IOSink sink = file.openWrite();
          sink.write(res.data);
          await sink.close();
ar raf = file.openSync(mode: FileMode.write);
      // response.data is List<int> type
      raf.writeFromSync(response.data);
          print('res length: ' + res.data.length.toString());
          print(res.data.runtimeType);*/
          print(1);

          String dKey = res.headers.map['decryption-key']!.first;
          print(res.headers);

          print('dKey: ' + dKey);
          Uint8List value = EncryptionTool.decryptData(res.data, dKey);
          return value;
        default:
          throw res.data['message'];
      }
    } on FlutterDownloaderException catch (e) {
      log(e.message);
      throw CustomException(DioErrorUtil.handleError(e.message));
    } catch (e) {
      log(e);
      throw CustomException(DioErrorUtil.handleError(e));
    }
  }

  Future<List<KeyAndId>?> getAllDirKeys(String id) async {
    String url = 'directory/$id/keys';
    try {
      final Response<dynamic> res = await dio().get<dynamic>(url);
      log(res.data);
      switch (res.statusCode) {
        case 200:
          List<KeyAndId> dirs = [];
          (res.data['data'] ?? []).forEach((a) {
            dirs.add(KeyAndId.fromJson(a));
          });
          return dirs;
        default:
          throw res.data['message'];
      }
    } catch (e) {
      log(e);
      throw CustomException(DioErrorUtil.handleError(e));
    }
  }

  Future<String> addFilePrivilege(List<Map<String, dynamic>> data) async {
    String url = 'file/privilege';
    try {
      final Response<dynamic> res =
          await dio().post<dynamic>(url, data: {'files': data});
      log(res.data);
      switch (res.statusCode) {
        case 200:
          return res.data['message'];
        default:
          throw res.data['message'];
      }
    } catch (e) {
      log(e);
      throw CustomException(DioErrorUtil.handleError(e));
    }
  }

  Future<String> addDirPrivilege(List<Map<String, dynamic>> data) async {
    String url = 'directory/privilege';
    log(data);

    try {
      final Response<dynamic> res =
          await dio().post<dynamic>(url, data: {'directories': data});
      log(res.data);
      switch (res.statusCode) {
        case 200:
          return res.data['message'];
        default:
          throw res.data['message'];
      }
    } catch (e) {
      log(e);
      throw CustomException(DioErrorUtil.handleError(e));
    }
  }

  Future<String> updatePrivilege(String id, Map<String, dynamic> data) async {
    String url = 'file/$id/privilege';
    try {
      final Response<dynamic> res = await dio().put<dynamic>(url, data: data);
      log(res.data);
      switch (res.statusCode) {
        case 200:
          return res.data['message'];
        default:
          throw res.data['message'];
      }
    } catch (e) {
      log(e);
      throw CustomException(DioErrorUtil.handleError(e));
    }
  }

  Future<List<User>> allUsers() async {
    String url = 'user/all';
    try {
      final Response<dynamic> res = await dio().get<dynamic>(url);
      // log(res.data);
      switch (res.statusCode) {
        case 200:
          List<User> dirs = [];
          res.data['data'].forEach((a) {
            dirs.add(User.fromJson(a));
          });
          return dirs;
        default:
          throw res.data['message'];
      }
    } catch (e) {
      log(e);
      throw CustomException(DioErrorUtil.handleError(e));
    }
  }

  Future<String> removePrivilege(String id) async {
    String url = 'file/$id/privilege';
    try {
      final Response<dynamic> res = await dio().delete<dynamic>(url);
      log(res.data);
      switch (res.statusCode) {
        case 200:
          return res.data['message'];
        default:
          throw res.data['message'];
      }
    } catch (e) {
      log(e);
      throw CustomException(DioErrorUtil.handleError(e));
    }
  }
}
