import 'dart:async';
import 'dart:developer';
import 'package:dio/dio.dart';
import 'package:kraken/env.dart';

import 'api_response.dart';
import 'exception_handler.dart';

String? tempBaseUrl;

String get baseUrl => tempBaseUrl ?? config['base_url']!;

class NetworkRequester {
  late Dio _dio;

  final Completer _dioInitCompleter = Completer();

  static NetworkRequester? _instance;

  static NetworkRequester get instance => _instance ??= NetworkRequester._();

  NetworkRequester._() {
    prepareRequest();
  }

  prepareRequest() async {
    BaseOptions dioOptions = BaseOptions(
      connectTimeout: const Duration(milliseconds: 90000),
      receiveTimeout: const Duration(milliseconds: 90000),
      sendTimeout: const Duration(milliseconds: 90000),
      baseUrl: baseUrl,
      responseType: ResponseType.json,
      headers: {
        'Accept': Headers.jsonContentType,
        'Content-Type': 'application/json'
      },
    );

    _dio = Dio(dioOptions);

    _dio.interceptors.clear();

    _dio.interceptors.addAll([
      LogInterceptor(
        error: true,
        request: true,
        requestBody: true,
        requestHeader: true,
        responseBody: true,
        responseHeader: true,
        logPrint: _printLog,
      ),
    ]);
    if (!_dioInitCompleter.isCompleted) _dioInitCompleter.complete();
  }

  _printLog(Object object) => log(object.toString());

  Future<dynamic> get({
    required String path,
    Map<String, dynamic>? query,
    Options? options,
  }) async {
    await _dioInitCompleter.future;
    try {
      final response = await _dio.get(
        path,
        queryParameters: query,
        options: options,
      );
      return APIResponse.fromJson(response.data, response.statusCode);
    } on Exception catch (error) {
      return ExceptionHandler.handleError(error);
    }
  }

  Future<dynamic> post({
    required String path,
    Map<String, dynamic>? data,
    Options? options,
  }) async {
    await _dioInitCompleter.future;
    try {
      final response = await _dio.post(
        path,
        data: data,
        options: options,
      );
      return APIResponse.fromJson(response.data, response.statusCode);
    } on Exception catch (error) {
      return ExceptionHandler.handleError(error);
    }
  }
}
