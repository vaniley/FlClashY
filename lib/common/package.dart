import 'dart:io';

import 'package:package_info_plus/package_info_plus.dart';

extension PackageInfoExtension on PackageInfo {
  String ua({required String appVersion, String? coreVersion}) => [
        "FlClashY/v$appVersion",
        if (coreVersion != null && coreVersion.isNotEmpty) "core/$coreVersion",
        "Platform/${Platform.operatingSystem}",
      ].join(" ");
}
