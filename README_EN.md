# FLClashY

FLClashY is a Flutter and Mihomo fork of [FlClash](https://github.com/chen08209/FlClash) and [FlClashX](https://github.com/pluralplay/FlClashX). It keeps compatibility with FlClashX subscription formats and headers while using its own name, icon, and Android package ID `com.follow.flclashy`, so it can be installed alongside other forks.

## Changes in this fork

- Transferable device fingerprints between Android and Desktop, including HWID, model, OS version, and User-Agent for Remnawave.
- A provider-controlled dashboard with announcements, traffic and expiration data, service identity, current server details, and quick server switching.
- Subscription-driven replacement of dashboard widgets, backgrounds, themes, service branding, proxy list layout, and startup settings through compatible `flclashx-*` headers.
- Rich profile cards with traffic, expiration, support links, and provider-defined update intervals.
- Android widgets, a Quick Settings tile, 120 Hz support, and Android TV controls.
- In-app data cleanup, Russian localization, and safer defaults.

## Provider customization

Providers can customize the client through response headers such as `flclashx-widgets`, `flclashx-view`, `flclashx-background`, `flclashx-hex`, `flclashx-servicename`, `flclashx-servicelogo`, and `flclashx-settings`. Compatibility header names are intentionally unchanged.

```text
flclashx-widgets: announce,metainfo,outboundModeV2,networkDetection,changeServerButton
flclashx-view: type:list; sort:delay; layout:tight; icon:icon; card:shrink
flclashx-servicename: My VPN
flclashx-servicelogo: https://example.com/logo.svg
flclashx-hex: 6750A4:vibrant:pureblack
```

## Build

Flutter 3.41.6+, Go 1.26, Android SDK 36, and NDK 28.0.13004108 are required.

```bash
flutter pub get
ANDROID_NDK=/path/to/android-sdk/ndk/28.0.13004108 dart setup.dart android --out core
flutter build apk --release --target-platform android-arm,android-arm64,android-x64
```

Linux:

```bash
dart setup.dart linux --arch amd64 --out core
flutter build linux --release
```

This project is distributed under GPL-3.0. The upstream projects and authors are credited above; FLClashY changes are maintained in this repository.
