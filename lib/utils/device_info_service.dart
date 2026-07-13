import 'dart:convert';
import 'dart:io';

import 'package:crypto/crypto.dart';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:flclashx/common/common.dart';
import 'package:flclashx/models/device_fingerprint.dart';
import 'package:flutter/services.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:win32_registry/win32_registry.dart';

class DeviceInfoService {
  final DeviceInfoPlugin _deviceInfoPlugin = DeviceInfoPlugin();
  static const String _hwidStorageKey = 'app_persistent_hwid';
  static const String _customHwidStorageKey = 'app_custom_hwid';
  static const String _customFingerprintStorageKey =
      'app_custom_device_fingerprint';
  static const MethodChannel _channel = MethodChannel(
    'com.follow.clashx/device_id',
  );

  static bool isValidHwid(String value) {
    return DeviceFingerprint.isValidHwid(value);
  }

  String _generateCompact16CharId(String fullId) {
    final bytes = utf8.encode(fullId);
    final hash = sha256.convert(bytes);
    final hashHex = hash.toString();
    return hashHex.substring(0, 16).toUpperCase();
  }

  Future<String?> _getAndroidId() async {
    try {
      final String? androidId = await _channel.invokeMethod('getAndroidId');
      if (androidId != null && androidId.isNotEmpty) return androidId;
      return null;
    } catch (e) {
      commonPrint.log('Failed to get Android ID: $e');
      return null;
    }
  }

  Future<String?> _getWindowsMachineGuid() async {
    try {
      const keyPath = r'SOFTWARE\Microsoft\Cryptography';
      const valueName = 'MachineGuid';
      final key = Registry.openPath(RegistryHive.localMachine, path: keyPath);
      final data = key.getValue(valueName);
      key.close();
      return data?.toString();
    } catch (_) {
      return null;
    }
  }

  Future<String?> _getPlatformDeviceId() async {
    try {
      if (Platform.isWindows) {
        final machineGuid = await _getWindowsMachineGuid();
        if (machineGuid != null && machineGuid.isNotEmpty) return machineGuid;
        final info = await _deviceInfoPlugin.windowsInfo;
        return '${info.computerName}-${info.deviceId}-${info.productId}';
      } else if (Platform.isAndroid) {
        final androidId = await _getAndroidId();
        if (androidId != null && androidId.isNotEmpty) return androidId;
        final info = await _deviceInfoPlugin.androidInfo;
        return '${info.brand}-${info.device}-${info.hardware}-${info.id}';
      } else if (Platform.isLinux) {
        final info = await _deviceInfoPlugin.linuxInfo;
        return info.machineId ?? '${info.id}-${info.name}';
      } else if (Platform.isMacOS) {
        final info = await _deviceInfoPlugin.macOsInfo;
        return info.systemGUID ?? '${info.model}-${info.computerName}';
      }
      return null;
    } catch (e) {
      commonPrint.log('Failed to get platform device ID: $e');
      return null;
    }
  }

  Future<String?> getAutomaticHwid() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final storedHwid = prefs.getString(_hwidStorageKey);
      if (storedHwid != null && storedHwid.isNotEmpty) return storedHwid;

      final deviceId = await _getPlatformDeviceId();
      if (deviceId == null || deviceId.isEmpty) return null;
      final newHwid = Platform.isAndroid
          ? deviceId
          : _generateCompact16CharId(deviceId);
      await prefs.setString(_hwidStorageKey, newHwid);
      return newHwid;
    } catch (e) {
      commonPrint.log('ERROR getting HWID: $e');
      return null;
    }
  }

  Future<DeviceFingerprint> getAutomaticDeviceDetails() async {
    String? os, osVersion, model;
    final packageInfo = await PackageInfo.fromPlatform();

    try {
      if (Platform.isWindows) {
        final info = await _deviceInfoPlugin.windowsInfo;
        os = 'Windows';
        osVersion = info.displayVersion;
        model = info.productName;
      } else if (Platform.isAndroid) {
        final info = await _deviceInfoPlugin.androidInfo;
        os = 'Android';
        osVersion = info.version.release;
        model = '${info.manufacturer} ${info.model}';
      } else if (Platform.isLinux) {
        final info = await _deviceInfoPlugin.linuxInfo;
        os = 'Linux';
        osVersion = info.versionId;
        model = info.name;
      } else if (Platform.isMacOS) {
        final info = await _deviceInfoPlugin.macOsInfo;
        os = 'macOS';
        osVersion = info.osRelease;
        model = info.model;
      }
    } catch (e) {
      commonPrint.log('Failed to get device details: $e');
    }

    return DeviceFingerprint(
      hwid: await getAutomaticHwid(),
      os: os ?? Platform.operatingSystem,
      osVersion: osVersion ?? Platform.operatingSystemVersion,
      model: model ?? Platform.localHostname,
      appVersion: packageInfo.version,
      platform: Platform.operatingSystem,
      userAgent: packageInfo.ua,
    );
  }

  Future<DeviceFingerprint> getDeviceDetails() async {
    final prefs = await SharedPreferences.getInstance();
    final stored = prefs.getString(_customFingerprintStorageKey);
    if (stored != null) {
      final custom = DeviceFingerprint.tryParseTransferString(stored);
      if (custom != null) return custom;
      commonPrint.log('Ignoring invalid custom device fingerprint');
    }

    final automatic = await getAutomaticDeviceDetails();
    final legacyHwid = prefs.getString(_customHwidStorageKey);
    if (legacyHwid != null && isValidHwid(legacyHwid)) {
      return automatic.copyWith(hwid: legacyHwid);
    }
    return automatic;
  }

  Future<bool> hasCustomFingerprint() async {
    final prefs = await SharedPreferences.getInstance();
    final stored = prefs.getString(_customFingerprintStorageKey);
    return stored != null &&
        DeviceFingerprint.tryParseTransferString(stored) != null;
  }

  Future<void> setCustomFingerprint(String? value) async {
    final prefs = await SharedPreferences.getInstance();
    if (value == null) {
      await prefs.remove(_customFingerprintStorageKey);
      await prefs.remove(_customHwidStorageKey);
      return;
    }

    final details = DeviceFingerprint.tryParseTransferString(value.trim());
    if (details == null) {
      throw const FormatException('Invalid device fingerprint');
    }
    await prefs.setString(
      _customFingerprintStorageKey,
      details.toTransferString(pretty: false),
    );
    await prefs.remove(_customHwidStorageKey);
  }
}
