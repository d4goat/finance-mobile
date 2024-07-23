import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:frontend/utils/config.dart';

class DioProvider {
  static BaseOptions options = new BaseOptions(
    baseUrl: Config.api + 'api',
    connectTimeout: const Duration(milliseconds: 10000),
    receiveTimeout: const Duration(milliseconds: 10000),
  );

  Dio dio = new Dio(options);
}
