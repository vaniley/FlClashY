🇷🇺 | [🇺🇸](./README_EN.md)

<div align="center">

# FlClashY

**Кроссплатформенный клиент на базе Flutter и Mihomo с переносимым отпечатком устройства**

[![Latest release](https://img.shields.io/github/v/release/vaniley/FlClashY?style=flat-square&logo=github)](https://github.com/vaniley/FlClashY/releases/latest)
[![Downloads](https://img.shields.io/github/downloads/vaniley/FlClashY/total?style=flat-square&logo=github)](https://github.com/vaniley/FlClashY/releases)
[![License: GPL-3.0](https://img.shields.io/github/license/vaniley/FlClashY?style=flat-square)](./LICENSE)

[Скачать последнюю версию](https://github.com/vaniley/FlClashY/releases/latest) · [История изменений](./CHANGELOG.md) · [Сообщить об ошибке](https://github.com/vaniley/FlClashY/issues)

</div>

## О проекте

FlClashY — форк [FlClashX](https://github.com/pluralplay/FlClashX), созданный на Flutter и использующий [Mihomo](https://github.com/MetaCubeX/mihomo) в качестве ядра.

Главное отличие FlClashY — возможность вручную настроить **HWID, модель устройства, версию операционной системы и User-Agent**, а затем использовать одинаковый отпечаток на Android и настольных устройствах. Это может быть полезно для подписок на базе Remnawave и других панелей, которые учитывают данные устройства.

## Возможности

- работа на Android, Windows, macOS и Linux;
- подключение через ядро Mihomo;
- импорт подписок по URL, QR-коду или из файла;
- VPN- и TUN-режимы;
- выбор и поиск прокси;
- правила, переопределения и скрипты;
- системный трей и автозапуск на Desktop;
- контроль доступа приложений и обход VPN для выбранных приложений;
- уведомления об окончании срока действия подписки;
- виджет и плитка быстрых настроек на Android;
- общий отпечаток устройства для Android и Desktop.

## Скачать

Готовые сборки находятся на странице [GitHub Releases](https://github.com/vaniley/FlClashY/releases/latest).

| Платформа | Архитектура | Доступные форматы |
|---|---|---|
| Android | ARM64, ARMv7, x86_64 | Universal APK, Split APK |
| Windows | x64, ARM64 | Установщик, Portable ZIP |
| macOS | Apple Silicon, Intel | DMG |
| Linux | x64, ARM64 | AppImage; DEB и RPM для x64 |

## Быстрый старт

1. Скачайте подходящую сборку со страницы [Releases](https://github.com/vaniley/FlClashY/releases/latest) и установите приложение.
2. Получите URL, QR-код или файл конфигурации у своего VPN-провайдера.
3. Импортируйте подписку или конфигурацию во FlClashY.
4. Разрешите приложению создать системное VPN-подключение.
5. Выберите режим работы, нужную прокси-группу и сервер.
6. Запустите подключение.

## Переносимый отпечаток устройства

FlClashY позволяет задать следующие значения:

- HWID;
- модель устройства;
- название и версию операционной системы;
- User-Agent.

Чтобы использовать один отпечаток на нескольких устройствах:

1. Откройте настройки данных устройства.
2. Укажите одинаковые значения на Android и Desktop.
3. Сохраните изменения.
4. Переподключите VPN, чтобы новые параметры начали использоваться.

![Редактирование HWID](./snapshots/hwid.png)


## Благодарности

- [FlClashX](https://github.com/pluralplay/FlClashX) — исходный проект;
- [Mihomo](https://github.com/MetaCubeX/mihomo) — сетевое ядро;
- разработчикам и участникам open-source проектов, на которых основан FlClashY.

## Лицензия

Проект распространяется на условиях [GNU General Public License v3.0](./LICENSE).
