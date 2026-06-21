import 'dart:async';
import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:http/testing.dart';
import 'package:resto/core/network/api_client.dart';
import 'package:resto/core/network/failure.dart';

ApiClient _clientReturning(
  FutureOr<http.Response> Function(http.Request request) handler,
) {
  return ApiClient(
    baseUrl: 'http://api.test',
    client: MockClient((request) async => handler(request)),
  );
}

void main() {
  group('ApiClient', () {
    test('GET decodes a JSON body (UTF-8)', () async {
      final api = _clientReturning(
        (_) => http.Response(
          jsonEncode([
            {'id': 'pizza', 'name': 'پیتزا'}
          ]),
          200,
          headers: {'content-type': 'application/json; charset=utf-8'},
        ),
      );

      final result = await api.get('/categories') as List<dynamic>;
      expect(result.first['name'], 'پیتزا');
    });

    test('GET appends query parameters', () async {
      late Uri captured;
      final api = _clientReturning((request) {
        captured = request.url;
        return http.Response('[]', 200);
      });

      await api.get('/foods', query: {'category_id': 'pizza'});
      expect(captured.queryParameters['category_id'], 'pizza');
    });

    test('POST sends the encoded body and method', () async {
      late http.Request captured;
      final api = _clientReturning((request) {
        captured = request;
        return http.Response(jsonEncode({'id': 'x'}), 201);
      });

      await api.post('/foods', body: {'name': 'x'});
      expect(captured.method, 'POST');
      expect(jsonDecode(captured.body), {'name': 'x'});
    });

    test('204 with empty body resolves to null', () async {
      final api = _clientReturning((_) => http.Response('', 204));
      expect(await api.delete('/foods/1'), isNull);
    });

    test('4xx maps to ServerFailure with the server message', () async {
      final api = _clientReturning(
        (_) => http.Response(jsonEncode({'error': 'food not found'}), 404),
      );

      expect(
        () => api.get('/foods/999'),
        throwsA(
          isA<ServerFailure>()
              .having((f) => f.statusCode, 'statusCode', 404)
              .having((f) => f.message, 'message', 'food not found'),
        ),
      );
    });

    test('5xx maps to ServerFailure', () async {
      final api = _clientReturning((_) => http.Response('boom', 500));
      expect(() => api.get('/foods'), throwsA(isA<ServerFailure>()));
    });

    test('connection errors map to NetworkFailure', () async {
      final api = _clientReturning(
        (_) => throw http.ClientException('connection refused'),
      );
      expect(() => api.get('/foods'), throwsA(isA<NetworkFailure>()));
    });
  });
}
