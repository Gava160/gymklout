import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ApiService {
  static String get baseUrl =>
      dotenv.env['API_BASE_URL'] ?? 'http://localhost:3000/api/v1';

  static const Duration _timeout = Duration(seconds: 15);

  Future<Map<String, dynamic>> request({
    required String method,
    required String path,
    Map<String, dynamic>? body,
    bool requiresAuth = false,
  }) async {
    final uri = Uri.parse('$baseUrl$path');

    final headers = <String, String>{
      'Content-Type': 'application/json',
      'Accept': 'application/json',
    };

    if (requiresAuth) {
      final token = await _getAccessToken();
      if (token != null) {
        headers['Authorization'] = 'Bearer $token';
      }
    }

    final client = HttpClient();
    HttpClientRequest request;

    try {
      switch (method.toUpperCase()) {
        case 'GET':
          request = await client.getUrl(uri).timeout(_timeout);
          break;
        case 'POST':
          request = await client.postUrl(uri).timeout(_timeout);
          break;
        case 'PUT':
          request = await client.putUrl(uri).timeout(_timeout);
          break;
        case 'PATCH':
          request = await client.patchUrl(uri).timeout(_timeout);
          break;
        case 'DELETE':
          request = await client.deleteUrl(uri).timeout(_timeout);
          break;
        default:
          throw Exception('Unsupported HTTP method: $method');
      }

      headers.forEach((key, value) => request.headers.set(key, value));

      if (body != null) {
        final encoded = jsonEncode(body);
        request.contentLength = encoded.length;
        request.write(encoded);
      }

      final response = await request.close().timeout(_timeout);
      final responseBody = await response.transform(utf8.decoder).join();
      debugPrint(responseBody);
      final decoded = jsonDecode(responseBody) as Map<String, dynamic>;

      if (response.statusCode >= 200 && response.statusCode < 300) {
        if (decoded.containsKey('data') &&
            decoded['data'] is Map<String, dynamic>) {
          return decoded['data'] as Map<String, dynamic>;
        }
        return decoded;
      }

      final message =
          decoded['message'] ?? decoded['error'] ?? 'Something went wrong';

      final details = decoded['details'];
      if (details is Map<String, dynamic>) {
        final firstField = details.values.firstOrNull;
        if (firstField is List && firstField.isNotEmpty) {
          throw ApiException(
            message: firstField.first.toString(),
            statusCode: response.statusCode,
          );
        }
      }

      throw ApiException(message: message, statusCode: response.statusCode);
    } on SocketException {
      throw ApiException(
        message: 'No internet connection. Please check your network.',
        statusCode: 0,
      );
    } on HttpException {
      throw ApiException(
        message: 'Could not reach the server. Please try again.',
        statusCode: 0,
      );
    } finally {
      client.close();
    }
  }

  // ─── Convenience methods ────────────────────────────────────────────────────
  Future<Map<String, dynamic>> get(String path, {bool requiresAuth = false}) =>
      request(method: 'GET', path: path, requiresAuth: requiresAuth);

  Future<Map<String, dynamic>> post(
    String path,
    Map<String, dynamic> body, {
    bool requiresAuth = false,
  }) => request(method: 'POST', path: path, body: body, requiresAuth: requiresAuth);

  Future<Map<String, dynamic>> patch(
    String path,
    Map<String, dynamic> body, {
    bool requiresAuth = false,
  }) => request(method: 'PATCH', path: path, body: body, requiresAuth: requiresAuth);

  // ─── Token helpers ──────────────────────────────────────────────────────────
  static Future<void> saveTokens({
    required String accessToken,
    required String refreshToken,
  }) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('access_token', accessToken);
    await prefs.setString('refresh_token', refreshToken);
  }

  static Future<void> clearTokens() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('access_token');
    await prefs.remove('refresh_token');
  }

  static Future<String?> _getAccessToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('access_token');
  }

  static Future<String?> getRefreshToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('refresh_token');
  }
}

// ─── ApiException ────────────────────────────────────────────────────────────
class ApiException implements Exception {
  final String message;
  final int statusCode;

  const ApiException({required this.message, required this.statusCode});

  @override
  String toString() => message;
}

// ─── Provider ────────────────────────────────────────────────────────────────
final apiServiceProvider = Provider<ApiService>((ref) => ApiService());