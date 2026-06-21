import 'dart:async';
import 'dart:convert';

import 'package:http/http.dart' as http;

import 'failure.dart';

// Thin wrapper over http.Client: builds the request, decodes JSON (UTF-8 so
// Kurdish comes back intact), enforces a timeout and turns transport/status
// errors into our typed Failure. The client is injectable so tests can pass a
// MockClient.
class ApiClient {
  ApiClient({
    required this.baseUrl,
    http.Client? client,
    this.timeout = const Duration(seconds: 10),
  }) : _client = client ?? http.Client();

  final String baseUrl;
  final Duration timeout;
  final http.Client _client;

  Future<dynamic> get(String path, {Map<String, String>? query}) =>
      _send('GET', path, query: query);

  Future<dynamic> post(String path, {Object? body}) =>
      _send('POST', path, body: body);

  Future<dynamic> put(String path, {Object? body}) =>
      _send('PUT', path, body: body);

  Future<dynamic> delete(String path) => _send('DELETE', path);

  void close() => _client.close();

  Future<dynamic> _send(
    String method,
    String path, {
    Map<String, String>? query,
    Object? body,
  }) async {
    final uri = Uri.parse('$baseUrl$path').replace(
      queryParameters: query?.isEmpty ?? true ? null : query,
    );
    final request = http.Request(method, uri)
      ..headers['accept'] = 'application/json';
    if (body != null) {
      request.headers['content-type'] = 'application/json; charset=utf-8';
      request.body = jsonEncode(body);
    }

    try {
      final streamed = await _client.send(request).timeout(timeout);
      final response = await http.Response.fromStream(streamed);
      return _decode(response);
    } on Failure {
      rethrow;
    } on TimeoutException {
      throw const NetworkFailure('Request timed out');
    } on http.ClientException {
      throw const NetworkFailure();
    } catch (error) {
      throw UnknownFailure(error.toString());
    }
  }

  dynamic _decode(http.Response response) {
    final status = response.statusCode;
    if (status >= 200 && status < 300) {
      if (response.bodyBytes.isEmpty) return null;
      return jsonDecode(utf8.decode(response.bodyBytes));
    }
    if (status >= 500) {
      throw ServerFailure('Server error ($status)', status);
    }
    throw ServerFailure(_errorMessage(response) ?? 'Request failed', status);
  }

  String? _errorMessage(http.Response response) {
    try {
      final decoded = jsonDecode(utf8.decode(response.bodyBytes));
      if (decoded is Map && decoded['error'] is String) {
        return decoded['error'] as String;
      }
    } catch (_) {}
    return null;
  }
}
