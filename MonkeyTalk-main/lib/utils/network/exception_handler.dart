import 'dart:developer';
import 'dart:io';
import 'package:dio/dio.dart';

class APIException implements Exception {
  final String? message;
  final int? statusCode;

  APIException({required this.message, this.statusCode});

  @override
  String toString() => "APIException($message, $statusCode)";
}

class ExceptionHandler {
  ExceptionHandler._privateConstructor();

  static String _checkOtherErrors(DioException error) {
    if (error.error is SocketException) {
      return ErrorMessages.noInternet;
    } else {
      return ErrorMessages.networkGeneral;
    }
  }

  static APIException handleError(Exception error) {
    if (error is DioException) {
      switch (error.type) {
        case DioExceptionType.sendTimeout:
          return APIException(
              message: ErrorMessages.noInternet,
              statusCode: error.response?.statusCode);
        case DioExceptionType.connectionTimeout:
          return APIException(
              message: ErrorMessages.connectionTimeout,
              statusCode: error.response?.statusCode);
        case DioExceptionType.badResponse:
          return APIException(
              message: error.response!.data is Map
                  ? ErrorResponse.fromJson(error.response?.data).message
                  : 'Some error occurred',
              statusCode: error.response?.statusCode);
        case DioExceptionType.unknown:
          log(_checkOtherErrors(error));
          return APIException(
              message: _checkOtherErrors(error),
              statusCode: error.response?.statusCode);
        default:
          return APIException(
              message: ErrorMessages.connectionTimeout,
              statusCode: error.response?.statusCode);
      }
    } else {
      return APIException(
          message: ErrorMessages.connectionTimeout, statusCode: 500);
    }
  }
}

class ErrorMessages {
  ErrorMessages._privateConstructor();

  static const unauthorized = 'You are not authorized';
  static const noInternet =
      'Oh no! You aren\'t connected to internet. Connect to proceed.';
  static const serverError = 'Server Error';
  static const connectionTimeout = 'Something went wrong. Please try again.';
  static const networkGeneral = 'Something went wrong. Please try again later.';
  static const invalidPhone = 'Invalid Mobile number';
  static const invalidOTP = 'Invalid OTP';
  static const invalidName = 'Invalid Name';
  static const invalidEmail = 'Invalid Email';
  static const noSubscription = 'No Active subscription';
}

class ErrorResponse {
  late String message;
  String? description;

  ErrorResponse({required this.message});

  ErrorResponse.fromJson(Map<String, dynamic>? json) {
    if (json != null) {
      if (json.containsKey('message')) {
        message = json['message'];
      } else if (json.containsKey('detail')) {
        message = json['detail'];
      } else {
        message = "some error occurred";
      }
      description = json['description'];
    } else {
      message = "some error occurred";
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['message'] = message;
    if (description != null) data['description'] = description;
    return data;
  }
}
