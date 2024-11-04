import 'package:dio/dio.dart';
import 'package:global_configuration/global_configuration.dart';
import 'package:logger/logger.dart';
import 'package:mms_app/core/storage/local_storage.dart';

class BaseAPI {
  Dio dio() {
    Dio dio = Dio(
      BaseOptions(
        baseUrl: GlobalConfiguration().get('base_url'),
        connectTimeout: Duration(seconds: 50),
        receiveTimeout: Duration(seconds: 50),
        contentType: 'application/json',
        validateStatus: (int? s) => s! < 500,
        headers: {
          'Authorization': 'Bearer ${AppCache.getToken()}',
        },
      ),
    );

    dio.interceptors.add(
      InterceptorsWrapper(
        onRequest: (
          RequestOptions requestOptions,
          RequestInterceptorHandler handler,
        ) {
          handler.next(requestOptions);
        },
      ),
    );

    return dio;
  }

  log(dynamic data) {
    Logger l = Logger();
    l.d(data);
  }
}
