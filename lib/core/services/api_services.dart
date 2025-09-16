import 'package:dio/dio.dart';
import 'package:provider_test/core/utils/api_response.dart';
import 'package:provider_test/core/utils/view_state.dart';

class ApiService {
  final Dio _dio = Dio();

  // Generic GET request
  Future<ApiResponse> get({String? endpoint, String? token}) async {
    try {
      if (token != null && token.isNotEmpty) {
        _dio.options.headers['Authorization'] = 'Bearer $token';
      }

      final response = await _dio.get(endpoint!);

      if (response.statusCode == 200) {
        return ApiResponse(state: ViewState.success, data: response.data);
      } else {
        return ApiResponse(
          state: ViewState.error,
          errorMessage: response.statusMessage,
        );
      }
    } catch (e) {
      return ApiResponse(state: ViewState.error, errorMessage: e.toString());
    }
  }

  // Generic POST request
  Future<ApiResponse> post(
    String endpoint, {
    dynamic data,
    String? token,
  }) async {
    try {
      if (token != null && token.isNotEmpty) {
        _dio.options.headers['Authorization'] = 'Bearer $token';
      }

      final response = await _dio.post(endpoint, data: data);

      if (response.statusCode == 200 || response.statusCode == 201) {
        // Ensure response.data is always a Map
        final resData = response.data;
        if (resData is Map<String, dynamic>) {
          return ApiResponse(state: ViewState.success, data: resData);
        } else {
          return ApiResponse(
            state: ViewState.error,
            errorMessage: "Unexpected response format: not a JSON object",
          );
        }
      } else {
        return ApiResponse(
          state: ViewState.error,
          errorMessage: response.statusMessage,
        );
      }
    } catch (e) {
      return ApiResponse(state: ViewState.error, errorMessage: e.toString());
    }
  }

  //delete
  Future<ApiResponse> delete(String url, {required String token}) async {
    try {
      if (token.isNotEmpty) {
        _dio.options.headers['Authorization'] = 'Bearer $token';
      }

      final response = await _dio.delete(url);

      if (response.statusCode == 200 || response.statusCode == 204) {
        return ApiResponse(
          state: ViewState.success,
          data: response.data.isNotEmpty ? response.data : null,
        );
      } else {
        return ApiResponse(
          state: ViewState.error,
          errorMessage:
              'Failed to delete. Status code: ${response.statusCode}, Message: ${response.statusMessage}',
        );
      }
    } catch (e) {
      return ApiResponse(state: ViewState.error, errorMessage: e.toString());
    }
  }

  Future<ApiResponse> patch(
    String url, {
    required String token,
    Map<String, dynamic>? data,
  }) async {
    try {
      if (token.isNotEmpty) {
        _dio.options.headers['Authorization'] = 'Bearer $token';
      }

      final response = await _dio.patch(url, data: data);

      if (response.statusCode == 200 || response.statusCode == 204) {
        return ApiResponse(
          state: ViewState.success,
          data: response.data.toString().isNotEmpty ? response.data : null,
        );
      } else {
        return ApiResponse(
          state: ViewState.error,
          errorMessage:
              'Failed to patch. Status code: ${response.statusCode}, Message: ${response.statusMessage}',
        );
      }
    } catch (e) {
      return ApiResponse(state: ViewState.error, errorMessage: e.toString());
    }
  }
}
