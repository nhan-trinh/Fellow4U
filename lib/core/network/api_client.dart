import 'dart:convert';

import 'package:Fellow4U/core/config/app_config.dart';
import 'package:http/http.dart' as http;

class ApiException implements Exception {
  final String message;
  final int? statusCode;

  ApiException(this.message, {this.statusCode});
}

class ApiClient {
  Future<Map<String, dynamic>> get(
    String path, {
    Map<String, String>? headers,
    Map<String, String>? queryParams,
  }) async {
    final uri = Uri.parse("${AppConfig.baseUrl}$path").replace(
      queryParameters: queryParams?.isEmpty ?? true ? null : queryParams,
    );
    final response = await http.get(uri, headers: headers);
    return _decodeResponse(response);
  }

  Future<Map<String, dynamic>> post(
    String path, {
    Map<String, String>? headers,
    Map<String, dynamic>? body,
  }) async {
    final uri = Uri.parse("${AppConfig.baseUrl}$path");
    final response = await http.post(
      uri,
      headers: {
        "Content-Type": "application/json",
        ...?headers,
      },
      body: jsonEncode(body ?? {}),
    );
    return _decodeResponse(response);
  }

  Future<Map<String, dynamic>> patch(
    String path, {
    Map<String, String>? headers,
    Map<String, dynamic>? body,
  }) async {
    final uri = Uri.parse("${AppConfig.baseUrl}$path");
    final response = await http.patch(
      uri,
      headers: {
        "Content-Type": "application/json",
        ...?headers,
      },
      body: jsonEncode(body ?? {}),
    );
    return _decodeResponse(response);
  }

  Map<String, dynamic> _decodeResponse(http.Response response) {
    Map<String, dynamic> payload = {};
    if (response.body.isNotEmpty) {
      payload = jsonDecode(response.body) as Map<String, dynamic>;
    }

    if (response.statusCode >= 200 && response.statusCode < 300) {
      return payload;
    }

    throw ApiException(
      payload["message"]?.toString() ?? "Request failed",
      statusCode: response.statusCode,
    );
  }
}
