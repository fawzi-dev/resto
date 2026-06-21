import 'dart:convert';
import 'dart:io';

import 'package:resto_mock_api/menu_store.dart';
import 'package:shelf/shelf.dart';
import 'package:shelf/shelf_io.dart' as io;
import 'package:shelf_router/shelf_router.dart';

final _store = MenuStore();

void main(List<String> args) async {
  final port = int.parse(
    Platform.environment['PORT'] ?? (args.isNotEmpty ? args.first : '8080'),
  );

  final router = Router()
    ..get('/health', (Request r) => _json({'status': 'ok'}))
    ..get('/categories', (Request r) => _json(_store.categories()))
    ..post('/categories', _createCategory)
    ..get('/foods', _getFoods)
    ..post('/foods', _createFood)
    ..put('/foods/<id>', _updateFood)
    ..delete('/foods/<id>', _deleteFood);

  final handler = const Pipeline()
      .addMiddleware(logRequests())
      .addMiddleware(_cors())
      .addMiddleware(_latency())
      .addHandler(router.call);

  final server = await io.serve(handler, InternetAddress.anyIPv4, port);
  stdout.writeln('Mock menu API running on http://localhost:${server.port}');
}

Response _getFoods(Request request) {
  final categoryId = request.url.queryParameters['category_id'];
  return _json(_store.foods(categoryId: categoryId));
}

Future<Response> _createCategory(Request request) async {
  final body = await _decodeBody(request);
  if (body == null || body['name'] == null) {
    return _error(400, 'name is required');
  }
  return _json(_store.addCategory(body), status: 201);
}

Future<Response> _createFood(Request request) async {
  final body = await _decodeBody(request);
  if (body == null || body['name'] == null || body['category_id'] == null) {
    return _error(400, 'name and category_id are required');
  }
  return _json(_store.addFood(body), status: 201);
}

Future<Response> _updateFood(Request request, String id) async {
  final body = await _decodeBody(request);
  if (body == null) return _error(400, 'invalid body');
  final updated = _store.updateFood(id, body);
  if (updated == null) return _error(404, 'food not found');
  return _json(updated);
}

Response _deleteFood(Request request, String id) {
  if (!_store.deleteFood(id)) return _error(404, 'food not found');
  return Response(204);
}

Future<Map<String, dynamic>?> _decodeBody(Request request) async {
  try {
    final raw = await request.readAsString();
    if (raw.isEmpty) return null;
    return jsonDecode(raw) as Map<String, dynamic>;
  } catch (_) {
    return null;
  }
}

Response _json(Object? data, {int status = 200}) {
  return Response(
    status,
    body: jsonEncode(data),
    headers: {'content-type': 'application/json; charset=utf-8'},
  );
}

Response _error(int status, String message) =>
    _json({'error': message}, status: status);

// Allow the Flutter web build (and any browser) to call the API.
Middleware _cors() {
  const headers = {
    'Access-Control-Allow-Origin': '*',
    'Access-Control-Allow-Methods': 'GET, POST, PUT, DELETE, OPTIONS',
    'Access-Control-Allow-Headers': 'Origin, Content-Type, Accept',
  };
  return (Handler handler) {
    return (Request request) async {
      if (request.method == 'OPTIONS') {
        return Response.ok(null, headers: headers);
      }
      final response = await handler(request);
      return response.change(headers: headers);
    };
  };
}

// A touch of latency so the app's loading/skeleton states are exercised.
Middleware _latency() {
  return (Handler handler) {
    return (Request request) async {
      await Future<void>.delayed(const Duration(milliseconds: 350));
      return handler(request);
    };
  };
}
