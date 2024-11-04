import 'dart:typed_data';

import 'package:dio/dio.dart';
import 'package:mms_app/core/utils/custom_exception.dart';
import 'package:mms_app/core/utils/error_util.dart';
import 'package:uuid/uuid.dart';

import '../blocs/directory_bloc.dart';
import '../models/directory_model.dart';
import '../models/task_model.dart';
import 'base_api.dart';

class VideoApi extends BaseAPI {
  Future<String> createUploadSession() async {
    String url = 'file/video/upload/start';
    try {
      String id = Uuid().v4();
      ZTask zTask = ZTask(
        message: 'Creating Upload Session',
        id: id,
        type: ZTaskType.CREATE_FILE,
        total: 1000,
        progress: 10,
      );
      directoryBloc.tasksToCheck[id] = zTask;
      directoryBloc.setAllTasks(directoryBloc.tasksToCheck);
      directoryBloc.tasksToCheck[id]?.progress = 2;
      directoryBloc.tasksToCheck[id]?.total = 10;
      directoryBloc.setAllTasks(directoryBloc.tasksToCheck);
      final Response<dynamic> res = await dio().get<dynamic>(
        url,
        onReceiveProgress: (a, b) {
          if (a == b) directoryBloc.tasksToCheck.remove(id);
          directoryBloc.setAllTasks(directoryBloc.tasksToCheck);
        },
      );
      log(res.data);
      switch (res.statusCode) {
        case 200:
          return res.data['data']['identifier'];
        default:
          throw res.data['message'];
      }
    } catch (e) {
      log(e);
      throw CustomException(DioErrorUtil.handleError(e));
    }
  }

  Future<DirectoryModel> completeUploadSession(
      FormData data, String sessionId) async {
    String id = Uuid().v4();
    ZTask zTask = ZTask(
      message: 'Finishing Upload Session',
      id: id,
      type: ZTaskType.CREATE_FILE,
      total: 1000,
      progress: 10,
    );
    directoryBloc.tasksToCheck[id] = zTask;
    directoryBloc.setAllTasks(directoryBloc.tasksToCheck);
    String url = 'file/video/upload/$sessionId/complete';
    try {
      final Response<dynamic> res = await dio().post<dynamic>(
        url,
        data: data,
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
        default:
          throw res.data['message'];
      }
    } catch (e) {
      log(e);
      throw CustomException(DioErrorUtil.handleError(e));
    }
  }

  Future<String> uploadChunk(String sessionId, String path, Uint8List f) async {
    String name = path.split('/').last;

    String res = '${name.split('p').first}p';
    String url = 'file/video/upload/chunk/$sessionId/$res';

    FormData forms = FormData();

    forms.files.add(
      MapEntry('chunk', MultipartFile.fromBytes(f, filename: name)),
    );

    String id = Uuid().v4();
    ZTask zTask = ZTask(
      message: name,
      id: id,
      type: ZTaskType.UPLOAD_CHUNK,
      total: 1000,
      progress: 10,
    );
    directoryBloc.tasksToCheck[id] = zTask;
    directoryBloc.setAllTasks(directoryBloc.tasksToCheck);

    print('url: $url');
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
          return res.data['message'];
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
}
