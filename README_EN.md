[🇷🇺](./README.md) | 🇺🇸

<div align="center">

# FlClashY

**A cross-platform Flutter and Mihomo client with a portable device fingerprint**

[![Latest release](https://img.shields.io/github/v/release/vaniley/FlClashY?style=flat-square&logo=github)](https://github.com/vaniley/FlClashY/releases/latest)
[![Downloads](https://img.shields.io/github/downloads/vaniley/FlClashY/total?style=flat-square&logo=github)](https://github.com/vaniley/FlClashY/releases)
[![License: GPL-3.0](https://img.shields.io/github/license/vaniley/FlClashY?style=flat-square)](./LICENSE)

[Download the latest version](https://github.com/vaniley/FlClashY/releases/latest) · [Changelog](./CHANGELOG.md) · [Report an issue](https://github.com/vaniley/FlClashY/issues)

</div>

## About the project

FlClashY is a fork of [FlClashX](https://github.com/pluralplay/FlClashX), built with Flutter and using [Mihomo](https://github.com/MetaCubeX/mihomo) as its core.

The main difference in FlClashY is the ability to manually configure the **HWID, device model, operating system name and version, and User-Agent**, then use the same fingerprint on Android and desktop devices. This can be useful for Remnawave-based subscriptions and other panels that take device information into account.

## Features

- runs on Android, Windows, macOS, and Linux;
- connects through the Mihomo core;
- imports subscriptions via URL, QR code, or file;
- VPN and TUN modes;
- proxy selection and search;
- rules, overrides, and scripts;
- system tray and autostart on Desktop;
- application access control and VPN bypass for selected apps;
- subscription expiration notifications;
- Android widget and quick settings tile;
- shared device fingerprint for Android and Desktop.

## Download

Prebuilt packages are available on the [GitHub Releases](https://github.com/vaniley/FlClashY/releases/latest) page.

| Platform | Architecture | Available formats |
|---|---|---|
| Android | ARM64, ARMv7, x86_64 | Universal APK, Split APK |
| Windows | x64, ARM64 | Installer, Portable ZIP |
| macOS | Apple Silicon, Intel | DMG |
| Linux | x64, ARM64 | AppImage; DEB and RPM for x64 |

## Quick start

1. Download the appropriate build from the [Releases](https://github.com/vaniley/FlClashY/releases/latest) page and install the application.
2. Get a URL, QR code, or configuration file from your VPN provider.
3. Import the subscription or configuration into FlClashY.
4. Allow the application to create a system VPN connection.
5. Select an operating mode, proxy group, and server.
6. Start the connection.

## Portable device fingerprint

FlClashY allows you to set the following values:

- HWID;
- device model;
- operating system name and version;
- User-Agent.

To use the same fingerprint on multiple devices:

1. Open the device information settings.
2. Set the same values on Android and Desktop.
3. Save the changes.
4. Reconnect the VPN for the new parameters to take effect.

![HWID editing](./snapshots/hwid.png)

## Acknowledgements

- [FlClashX](https://github.com/pluralplay/FlClashX) — the original project;
- [Mihomo](https://github.com/MetaCubeX/mihomo) — the network core;
- the developers and contributors of the open-source projects on which FlClashY is based.

## License

This project is distributed under the terms of the [GNU General Public License v3.0](./LICENSE).
