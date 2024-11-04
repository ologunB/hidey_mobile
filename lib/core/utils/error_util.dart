// ignore_for_file: deprecated_member_use

import 'dart:io';

import 'package:dio/dio.dart';

import '../navigation/navigator.dart';

class DioErrorUtil {
  static String handleError(dynamic error) {
    String errorDescription = '';
    if (error is SocketException) {
      errorDescription = 'No internet connection';
    } else if (error is DioError) {
      switch (error.type) {
        case DioErrorType.cancel:
          errorDescription = 'Request to API server was cancelled';
          break;
        case DioErrorType.connectionTimeout:
          errorDescription = 'Slow Connection';
          break;
        case DioErrorType.unknown:
          errorDescription = 'No internet connection';
          break;
        case DioErrorType.receiveTimeout:
          errorDescription = 'Receive timeout in connection with API server';
          break;
        case DioErrorType.badResponse:
          if (error.response!.statusCode == 404)
            errorDescription =
                error.response!.statusMessage ?? 'Unexpected error occurred';
          else if (error.response!.statusCode == 400) {
            errorDescription = error.response!.statusMessage ?? 'Bad request';
          } else if (error.response!.statusCode == 401) {
            errorDescription = error.response!.statusMessage ??
                'These credentials are wrong \nCheck and try again';
          } else if (error.response!.statusCode == 500) {
            errorDescription = error.response!.statusMessage ??
                'Server is currently under maintenance, Try again later';
          } else {
            errorDescription =
                'Received invalid status code: ${error.response!.statusCode}';
          }
          break;
        case DioErrorType.sendTimeout:
          errorDescription = 'Send timeout in connection with API server';
          break;
        case DioErrorType.badCertificate:
          errorDescription = 'Bad Certificate';
          break;
        case DioErrorType.badResponse:
          errorDescription = 'Bad Response';
          break;
        case DioErrorType.connectionError:
          errorDescription = 'Connection Error';
          break;
      }
    } else if (error is TypeError) {
      errorDescription = error.stackTrace.toString();
    } else {
      errorDescription = error.toString();
    }

    if (errorDescription == 'unauthorized user') {
      AppNavigator.navigateToAndClear(LoginRoute);
    }

    return errorDescription;
  }
}

const String PARSING_ERROR =
    'Parsing Error, Backend has changed this model again 🤦🏾';
