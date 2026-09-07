# Заявки на материалы

Android-приложение для монтажника на объекте: собрать заявку на материалы
из справочника, сохранить файлами на устройство и отправить.

Реализовано по макетам `Заявки на материалы.dc.html` / `Флоу экранов.dc.html`
(Claude Design) и архитектурному промпту `docs/architecture-prompt.md`.

## Состояние

Приложение запускается и проходится целиком на моках. Справочник — настоящий:
разобран из `price.xlsx`, **6 категорий, 51 подкатегория, 326 материалов**,
единицы `шт.` / `м.п.` / `комплект`.

Работают: список заявок с папками, фильтрами и поиском (в том числе по
материалам внутри); заявка с правкой названия, количества и состава; экран
позиции; подбор материала деревом и поиском с количеством в шторке;
справочник на трёх уровнях с созданием, правкой и удалением; импорт прайса
с отчётом до подтверждения; отправка с выбором формата; deep link на любой
экран.

Бэкенда нет намеренно: не решено, куда отправляется заявка (`docs/architecture-prompt.md`).
Поэтому `MockRootFactory` — единственная фабрика, а сети в проекте нет.

```
lib/
  core/
    dependencies/container/  RootContainer, MockRootFactory
    domain/                  Params, DescribedException
    navigation/              app_routes (+ .g.dart), app_router
    presentation/            RequestNotifier, NotifierScope, MultiScope,
                             AppText, failureMessage, AppWidth, ContentColumn
    utils/                   Debouncer
    widgets/                 WindowShell, TabShell, SnackOverlay, RequestView,
                             ConfirmSheet, NameFormScreen, FormActionBar
  feature/requests/  domain · data (репозиторий + мок) · presentation
                     (9 нотифаеров, 4 страницы, экраны и карточки)
  feature/catalog/   domain · data (репозиторий, мок, прайс) · presentation
                     (10 нотифаеров, 8 страниц, экраны)
  generated/         app_localizations.dart
packages/request_ui/ дизайн-система: токены, тема, 20 виджетов, шрифты
  example/           галерея компонентов
assets/translations/ ru.arb — все строки приложения
docs/design/         рендеры экранов
```

## Запуск

```sh
flutter run                                   # приложение на моках
cd packages/request_ui/example && flutter run  # галерея дизайн-системы
```

## Проверки

```sh
dart analyze          # из корня: иначе плагин markup_analyzer не поднимется
flutter test
dart run build_runner build     # после правки app_routes.dart
cd packages/request_ui && flutter analyze
```

`flutter analyze` плагины анализатора не загружает — сырые строки в виджетах
ловит именно `dart analyze` из корня проекта.
