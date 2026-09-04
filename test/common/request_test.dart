import 'dart:convert';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flclashx/common/request.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  late HttpServer server;
  late Uri baseUri;

  setUp(() async {
    server = await HttpServer.bind(InternetAddress.loopbackIPv4, 0);
    baseUri = Uri.parse('http://${server.address.host}:${server.port}');
  });

  tearDown(() => server.close(force: true));

  test('loads subscription through a relative redirect and preserves headers',
      () async {
    const body = 'proxies:\n  - name: test\n    type: direct\n';
    final receivedHeaders = <String, List<String>>{};
    server.listen((request) async {
      receivedHeaders.putIfAbsent(
        request.uri.path,
        () => [
          request.headers.value(HttpHeaders.userAgentHeader) ?? '',
          request.headers.value('x-hwid') ?? '',
        ],
      );
      if (request.uri.path == '/start') {
        request.response
          ..statusCode = HttpStatus.found
          ..headers.set(HttpHeaders.locationHeader, '/profile');
      } else {
        request.response
          ..statusCode = HttpStatus.ok
          ..add(utf8.encode(body));
      }
      await request.response.close();
    });

    final originalHeaders = <String, dynamic>{'x-hwid': 'device-id'};
    final response = await Request(
      userAgentProvider: () => 'FlClashY/test',
    ).getFileResponseForUrl(
      baseUri.resolve('/start').toString(),
      headers: originalHeaders,
    );

    expect(utf8.decode(response.data!), body);
    expect(receivedHeaders['/start'], ['FlClashY/test', 'device-id']);
    expect(receivedHeaders['/profile'], ['FlClashY/test', 'device-id']);
    expect(originalHeaders, {'x-hwid': 'device-id'});
  });

  test('rejects an HTTP error instead of treating it as profile content',
      () async {
    server.listen((request) async {
      request.response
        ..statusCode = HttpStatus.notFound
        ..write('not a subscription');
      await request.response.close();
    });

    final future = Request(
      userAgentProvider: () => 'FlClashY/test',
    ).getFileResponseForUrl(baseUri.resolve('/missing').toString());

    await expectLater(future, throwsA(isA<DioException>()));
  });

  test('stops redirect loops', () async {
    server.listen((request) async {
      request.response
        ..statusCode = HttpStatus.found
        ..headers.set(HttpHeaders.locationHeader, '/loop');
      await request.response.close();
    });

    final future = Request(
      userAgentProvider: () => 'FlClashY/test',
    ).getFileResponseForUrl(baseUri.resolve('/loop').toString());

    await expectLater(future, throwsA(isA<Exception>()));
  });
}
