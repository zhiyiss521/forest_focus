import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:forest_focus/core/constants/app_constants.dart';
import 'package:forest_focus/core/util/forest_log.dart';
import 'package:forest_focus/router/ForestRouter.dart';
import 'package:forest_focus/ui/page/login/login_page.dart';
import 'package:forest_focus/ui/widget/hud.dart';
import 'package:shared_preferences/shared_preferences.dart';

class FFRequest {

  static final Dio _dio = Dio(
    BaseOptions(
      baseUrl: AppConstants.kBaseUrl,
      connectTimeout: const Duration(seconds: 5),
      receiveTimeout: const Duration(seconds: 5),
      sendTimeout: const Duration(seconds: 5),
      headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
      },
    ),
  );

  static Future<dynamic> get(
      String path, {
        Map<String, dynamic>? queryParameters,
        bool needLogin = true,
      }) async {
    return _request(
          () => _dio.get(
        path,
        queryParameters: queryParameters,
        options: _options(needLogin),
      ),
      'GET',
      path,
      null,
      queryParameters,
      needLogin,
    );
  }

  static Future<dynamic> post(
      String path, {
        dynamic data,
        Map<String, dynamic>? queryParameters,
        bool needLogin = true,
      }) async {
    return _request(
          () => _dio.post(
        path,
        data: data,
        queryParameters: queryParameters,
        options: _options(needLogin),
      ),
      'POST',
      path,
      data,
      queryParameters,
      needLogin,
    );
  }

  static Future<dynamic> put(
      String path, {
        dynamic data,
        Map<String, dynamic>? queryParameters,
        bool needLogin = true,
      }) async {
    return _request(
          () => _dio.put(
        path,
        data: data,
        queryParameters: queryParameters,
        options: _options(needLogin),
      ),
      'PUT',
      path,
      data,
      queryParameters,
      needLogin,
    );
  }

  static Options _options(bool needLogin) {
    return Options(
      headers: {
        if (needLogin) 'Authorization': 'Bearer ${_token ?? ''}',
      },
    );
  }

  static String? _token;

  static Future<void> init() async {
    final prefs = await SharedPreferences.getInstance();
    final json = prefs.getString('user');

    if (json == null) {
      _token = null;
      return;
    }

    try {
      final user = jsonDecode(json);
      _token = user['token']?.toString();
    } catch (_) {
      _token = null;
    }
  }

  static Future<dynamic> _request(
      Future<Response> Function() request,
      String method,
      String path,
      dynamic data,
      Map<String, dynamic>? queryParameters,
      bool needLogin,
      ) async {
    await init();

    final uri = Uri.parse(
      '${_dio.options.baseUrl}$path',
    ).replace(
      queryParameters: queryParameters?.map(
            (key, value) => MapEntry(
          key,
          value.toString(),
        ),
      ),
    );

    _logCurl(
      method,
      uri,
      data,
      needLogin,
    );

    try {
      final response = await request();

      _logResponse(response);
      final body = response.data;
      if (body is Map<String, dynamic>) {
        if (body['code'] == 0) {
          return body['data'];
        }
        FFHUD.showToast(
          body['message']?.toString() ?? '请求失败',
        );
        throw body;
      }
      throw body;
    } on DioException catch (e) {
      if (e.response != null) {
        _logResponse(e.response!);
      } else {
        _logError(e);
      }

      return _handleDioError(e);
    }
  }

  static Future<dynamic> _handleDioError(DioException e,) async {
    switch (e.type) {
      case DioExceptionType.badResponse:
        final statusCode = e.response?.statusCode;
        FFLog.d('HTTP status: $statusCode');
        if (statusCode == 401) {
          FFHUD.showToast('请重新登录');

          final prefs = await SharedPreferences.getInstance();
          await prefs.remove('user');

          _token = null;

          FFRouter.pushAndRemoveUntil(
            const LoginPage(),
          );
        }

        if (e.response?.data is Map<String, dynamic>) {
          FFHUD.showToast(
            e.response?.data['message']?.toString() ?? '请求失败',
          );
          return e.response!.data;
        }

        return {
          'code': statusCode ?? -1,
          'message': '请求失败',
          'data': null,
        };

      case DioExceptionType.connectionTimeout:
      case DioExceptionType.sendTimeout:
      case DioExceptionType.receiveTimeout:
      case DioExceptionType.connectionError:
        FFHUD.showToast('网络异常');

        return {
          'code': -1,
          'message': '网络连接失败',
          'data': null,
        };

      default:
        if (e.response?.data is Map<String, dynamic>) {
          return e.response!.data;
        }

        return {
          'code': -2,
          'message': e.message ?? '网络请求失败',
          'data': null,
        };
    }
  }

  static void _logCurl(
      String method,
      Uri uri,
      dynamic data,
      bool needLogin,
  ) {
    final buffer = StringBuffer(
      "curl -X $method '$uri'",
    );

    _dio.options.headers.forEach(
          (key, value) {
        buffer.write(
          " \\\n  -H '$key: $value'",
        );
      },
    );

    if (needLogin && _token != null) {
      buffer.write(
        " \\\n  -H 'Authorization: Bearer $_token'",
      );
    }

    if (data != null) {
      if (data is FormData) {
        buffer.write(
          " \\\n  -F 'file=@${data.files.first.value.filename}'",
        );
      } else {
        buffer.write(
          " \\\n  -d '${jsonEncode(data)}'",
        );
      }
    }

    FFLog.d(
      buffer.toString(),
    );
  }

  static void _logResponse(Response response) {
    FFLog.d(
      '${response.requestOptions.method} '
          '${response.requestOptions.uri}\n'
          '[status]: ${response.statusCode}\n'
          '[body]: ${_formatData(response.data)}',
    );
  }

  static void _logError(DioException error) {
    FFLog.d(
      'Network Error: '
          '${error.type} '
          '${error.message}',
    );
  }

  static String _formatData(dynamic data) {
    if (data == null) {
      return 'null';
    }

    if (data is String) {
      return data;
    }

    try {
      return const JsonEncoder.withIndent('  ').convert(data);
    } catch (_) {
      return data.toString();
    }
  }

}