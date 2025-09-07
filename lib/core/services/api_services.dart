import 'package:dio/dio.dart';
import 'package:provider_test/core/utils/api_response.dart';
import 'package:provider_test/core/utils/view_state.dart';

class ApiService {
  final Dio _dio = Dio();

  //get
  Future<ApiResponse> get({String? endpoint, String? token}) async {
    try {
      if (token != null && token.isNotEmpty) {
        _dio.options.headers['Authorization'] = 'Bearer $token';
      }
      final response = await _dio.get(endpoint!);

      if (response.statusCode == 200) {
        return ApiResponse(state: ViewState.success, data: response.data);
      } else {
        return ApiResponse(state: ViewState.error);
      }
    } on DioException catch (e) {
      return ApiResponse(
        state: ViewState.error,
        errorMessage: e.response?.data['error'] ?? e.message,
      );
    }
  }

  /// POST request
  Future<ApiResponse> post(
    String endpoint, {
    dynamic data,
    String? token,
  }) async {
    try {
      if (token != null && token.isNotEmpty) {
        _dio.options.headers['Authorization'] = 'Bearer $token';
      }

      final response = await _dio.post(
        endpoint,
        data: data,
        options: Options(headers: {'Content-Type': 'application/json'}),
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        return ApiResponse(state: ViewState.success, data: response.data);
      } else {
        return ApiResponse(state: ViewState.error);
      }
    } on DioException catch (e) {
      return ApiResponse(
        state: ViewState.error,
        errorMessage: e.response?.data['error'] ?? e.message,
      );
    }
  }
}
