import 'dart:convert';

class DeviceFingerprint {
  const DeviceFingerprint({
    this.hwid,
    this.os,
    this.osVersion,
    this.model,
    this.appVersion,
    this.platform,
    this.userAgent,
  });

  static const transferFormat = 'flclashx-device-fingerprint';
  static const transferVersion = 1;

  final String? hwid;
  final String? os;
  final String? osVersion;
  final String? model;
  final String? appVersion;
  final String? platform;
  final String? userAgent;

  DeviceFingerprint copyWith({String? hwid}) => DeviceFingerprint(
    hwid: hwid ?? this.hwid,
    os: os,
    osVersion: osVersion,
    model: model,
    appVersion: appVersion,
    platform: platform,
    userAgent: userAgent,
  );

  Map<String, dynamic> toJson() => {
    'format': transferFormat,
    'version': transferVersion,
    'hwid': hwid,
    'os': os,
    'osVersion': osVersion,
    'model': model,
    'appVersion': appVersion,
    'platform': platform,
    'userAgent': userAgent,
  };

  String toTransferString({bool pretty = true}) =>
      (pretty ? const JsonEncoder.withIndent('  ') : const JsonEncoder())
          .convert(toJson());

  static DeviceFingerprint? tryParseTransferString(String value) {
    try {
      final decoded = jsonDecode(value);
      if (decoded is! Map<String, dynamic> ||
          decoded['format'] != transferFormat ||
          decoded['version'] != transferVersion) {
        return null;
      }

      String? field(String name) {
        final value = decoded[name];
        return value is String && value.isNotEmpty ? value : null;
      }

      final fingerprint = DeviceFingerprint(
        hwid: field('hwid'),
        os: field('os'),
        osVersion: field('osVersion'),
        model: field('model'),
        appVersion: field('appVersion'),
        platform: field('platform'),
        userAgent: field('userAgent'),
      );
      return fingerprint.isValid ? fingerprint : null;
    } catch (_) {
      return null;
    }
  }

  static bool isValidHwid(String value) {
    if (value.isEmpty || value.length > 128) return false;
    return value.codeUnits.every((unit) => unit >= 0x21 && unit <= 0x7e);
  }

  static bool isValidHeaderValue(String? value) {
    if (value == null || value.isEmpty || value.length > 256) return false;
    return !value.contains('\r') && !value.contains('\n');
  }

  bool get isValid =>
      isValidHwid(hwid ?? '') &&
      isValidHeaderValue(os) &&
      isValidHeaderValue(osVersion) &&
      isValidHeaderValue(model) &&
      isValidHeaderValue(appVersion) &&
      isValidHeaderValue(platform) &&
      isValidHeaderValue(userAgent);
}
