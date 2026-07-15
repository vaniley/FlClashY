# FlClashY

FlClashY — форк [FlClash](https://github.com/chen08209/FlClash) и [FlClashX](https://github.com/pluralplay/FlClashX) на Flutter и Mihomo. Мы сохраняем совместимость с форматами и заголовками FlClashX, но приложение имеет своё имя, иконку и Android package ID `com.follow.flclashy`, поэтому может быть установлено рядом с другими форками.

Основной разработчик — [lazarrew](https://github.com/vaniley). Актуальный репозиторий проекта: [vaniley/FlClashY](https://github.com/vaniley/FlClashY).

## Что добавлено в этом форке

- Переносимый отпечаток устройства между Android и Desktop с HWID, моделью, версией ОС и User-Agent для Remnawave.
- Управляемый провайдером Dashboard: анонсы, трафик, срок подписки, информация о сервисе, текущий сервер и быстрый переход к его смене.
- Подмена внешнего вида и поведения из подписки: набор и порядок виджетов, фон, цветовая тема, логотип, название сервиса, вид списка прокси и настройки автозапуска.
- Карточки профилей с остатком трафика, сроком действия, кнопкой поддержки и интервалом автообновления из панели.
- Отдельные Android-виджеты, Quick Settings tile, поддержка 120 Гц и управление с Android TV.
- Очистка данных и профилей из интерфейса, русская локализация и безопасные настройки по умолчанию.

## Подмена оформления и настроек

Провайдер может передавать заголовки в ответе подписки. Клиент применяет их при добавлении или обновлении профиля.

| Заголовок | Что подменяет |
| --- | --- |
| `flclashx-widgets` | Состав и порядок виджетов Dashboard |
| `flclashx-view` | Сортировку, плотность, иконки и карточки списка прокси |
| `flclashx-background` | Фоновое изображение |
| `flclashx-hex` | Основной цвет, variant и pure-black режим |
| `flclashx-servicename`, `flclashx-servicelogo` | Название и логотип сервиса |
| `flclashx-settings` | Автозапуск, сворачивание, автостарт и автообновление |
| `flclashx-denywidgets`, `flclashx-globalmode`, `flclashx-androidsecure` | Ограничения и политики клиента |

Пример:

```text
flclashx-widgets: announce,metainfo,outboundModeV2,networkDetection,changeServerButton
flclashx-view: type:list; sort:delay; layout:tight; icon:icon; card:shrink
flclashx-servicename: My VPN
flclashx-servicelogo: https://example.com/logo.svg
flclashx-hex: 6750A4:vibrant:pureblack
```

## Сборка

Нужны Flutter 3.41.6+, Go 1.26, Android SDK 36 и NDK 28.0.13004108.

```bash
flutter pub get
ANDROID_NDK=/path/to/android-sdk/ndk/28.0.13004108 dart setup.dart android --out core
flutter build apk --release --target-platform android-arm,android-arm64,android-x64
```

Для Linux:

```bash
dart setup.dart linux --arch amd64 --out core
flutter build linux --release
```

Проект распространяется под лицензией GPL-3.0. Исходные проекты и их авторы указаны выше; изменения FlClashY ведутся в этом репозитории.
