import 'dart:convert';
import 'dart:io';

import 'package:flclashx/clash/lib.dart';
import 'package:flclashx/common/file_logger.dart';
import 'package:flclashx/models/models.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:path_provider_platform_interface/path_provider_platform_interface.dart';

class _TestPaths extends PathProviderPlatform {
  _TestPaths(this.path);
  final String path;

  @override
  Future<String?> getApplicationSupportPath() async => path;
  @override
  Future<String?> getTemporaryPath() async => path;
  @override
  Future<String?> getDownloadsPath() async => path;
}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  const channel = MethodChannel('com.follow.clashx/service');
  final messenger =
      TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger;
  late ClashLib bridge;
  Object? response;
  var failInit = false;
  var actionCalls = 0;
  var initCalls = 0;

  late Directory directory;
  late PathProviderPlatform previousPaths;
  setUpAll(() async {
    directory = await Directory.systemTemp.createTemp('flclashy-bridge-test-');
    previousPaths = PathProviderPlatform.instance;
    PathProviderPlatform.instance = _TestPaths(directory.path);
    messenger.setMockMethodCallHandler(channel, (call) async {
      if (call.method == 'init') {
        initCalls++;
        if (failInit) throw PlatformException(code: 'bind_failed');
        return '';
      }
      if (call.method == 'invokeAction') {
        actionCalls++;
        if (response == null) return '';
        final action =
            jsonDecode(call.arguments as String) as Map<String, dynamic>;
        return jsonEncode({
          'id': action['id'],
          'method': action['method'],
          'data': response,
          'code': 0,
        });
      }
      return null;
    });
    bridge = ClashLib();
    await bridge.preload();
  });

  setUp(() => response = null);
  tearDownAll(() async {
    messenger.setMockMethodCallHandler(channel, null);
    await fileLogger.dispose();
    PathProviderPlatform.instance = previousPaths;
    await directory.delete(recursive: true);
  });

  test('lost native response does not accept an unvalidated subscription',
      () async {
    expect(await bridge.validateConfig('proxies: []'), isNotEmpty);
  });

  test('successful native validation still accepts a subscription', () async {
    response = '';
    expect(await bridge.validateConfig('proxies: []'), isEmpty);
  });

  test('wrong response type does not accept a subscription', () async {
    response = false;
    expect(await bridge.validateConfig('proxies: []'), isNotEmpty);
  });
  test('lost setup response is an error, not a successful apply', () async {
    expect(
      await bridge.setupConfig(const SetupParams(
        config: {},
        selectedMap: {},
        testUrl: 'https://example.com',
      )),
      isNotEmpty,
    );
  });

  test('failed binding rejects actions and can be retried', () async {
    failInit = true;
    bridge.reStart();
    expect(await bridge.preload(), isFalse);
    final previousCalls = actionCalls;
    expect(await bridge.validateConfig('proxies: []'), isNotEmpty);
    expect(actionCalls, previousCalls);

    failInit = false;
    bridge.reStart();
    expect(await bridge.preload(), isTrue);
    response = '';
    expect(await bridge.validateConfig('proxies: []'), isEmpty);
  });

  test('concurrent restarts share a single native binding', () async {
    final previousCalls = initCalls;
    bridge.reStart();
    bridge.reStart();
    bridge.reconnectIfNeeded();
    expect(await bridge.preload(), isTrue);
    expect(initCalls - previousCalls, 1);
  });
}
