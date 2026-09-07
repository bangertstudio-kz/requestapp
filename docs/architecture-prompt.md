# Промпт: развернуть архитектуру Flutter-приложения

> Скопировать целиком в новую сессию Claude Code в пустом (или почти пустом) Flutter-проекте.
> Перед запуском заменить плейсхолдеры: `<APP>` — имя пакета (`pubspec.yaml: name`),
> `<UI>` — имя пакета дизайн-системы (обычно `<APP>_ui`), `<API_URL>` — базовый URL шлюза,
> `<LOCALES>` — список локалей (например `ru, en`), `<FEATURES>` — список фич первой итерации.

---

## Задача

Разверни в этом проекте архитектурный каркас: слои, core-примитивы, DI, навигацию,
локализацию, дизайн-систему и один сквозной вертикальный срез фичи, который служит
образцом для всех остальных. Ничего лишнего сверх описанного не добавляй: ни state-management
библиотек, ни code-generation для моделей, ни абстрактных use-case классов.

Работай по этапам из раздела «Порядок работ». После каждого этапа — `flutter analyze` из
корня проекта (не из `lib`: анализаторные плагины подхватываются только из корня) и
`flutter test`. Не переходи к следующему этапу, пока текущий не собирается.

---

## 1. Принципы

1. **Три слоя на фичу**: `domain` (сущности и параметры, чистый Dart), `data` (репозитории,
   модели, сериализация), `presentation` (нотифаеры и экраны).
2. **Направление зависимостей**: `presentation → data → domain`. `domain` не знает ни про
   dio, ни про Flutter. `data` не импортирует `presentation`. `presentation` не знает, что
   транспорт — HTTP: она видит только интерфейс репозитория.
3. **Никаких use-case/interactor классов.** Нотифаер вызывает метод репозитория напрямую.
   Прослойка, которая только пробрасывает вызов, — это файл, который надо читать, и ничего больше.
4. **Один нотифаер — один файл.** Имя файла = snake_case имени класса.
5. **Комментарии объясняют «почему», а не «что».** Doc-комментарий на каждом публичном классе
   и на каждом неочевидном решении: почему nullable, почему именно здесь, что сломается иначе.
   Комментарий, пересказывающий имя метода, не пиши.
6. **Каждая строка, которую видит пользователь, приходит из ARB.** Включая непереводимое:
   бренд, «©», числа с единицами. Никаких `// ignore` и никаких строковых литералов в
   конструкторах виджетов.

---

## 2. Структура каталогов

```
lib/
  core/
    data/models/          list_data_model.dart
    dependencies/
      container/          dependency_container.dart, dependency_factory.dart,
                          mock_dependency_factory.dart
      http/               httpclient.dart, <перехватчики>
      locale_storage/     locale_storage.dart, secure_locale_storage.dart,
                          shared_locale_storage.dart
    domain/
      described_exception.dart
      entities/           params.dart, list_params.dart, list_data.dart, <общие enum'ы>
    env/                  env.dart
    navigation/           app_router.dart, app_routes.dart, app_routes.g.dart,
                          navigator_keys.dart
    presentation/         request_notifier.dart, paginated_list_notifier.dart,
                          notifier_scope.dart, multi_scope.dart, app_text.dart,
                          failure_message.dart, app_breakpoints.dart, content_column.dart
    utils/                debouncer.dart
    widgets/              <общие виджеты, которых нет в дизайн-системе>
  feature/
    <feature>/
      domain/entities/    <entity>.dart, <entity>_params.dart
      data/               <entity>_repository.dart      (abstract interface class)
                          network_<entity>_repository.dart
                          mock_<entity>_repository.dart
                          <entity>_model.dart           (fromJson)
                          <entity>_request.dart         (toJson, extension)
      presentation/       <entity>_notifier.dart, <entity>_screen.dart, <entity>_card.dart
  generated/              app_localizations.dart (l10n gen)
  main.dart
packages/
  <UI>/                   дизайн-система отдельным пакетом
assets/translations/      ru.arb, en.arb, ...
test/
docs/
```

`core/` — то, чем пользуются минимум две фичи, либо то, что описывает механизм, а не предмет.
Если что-то нужно одной фиче — оно живёт в фиче, даже если выглядит «общим».

---

## 3. Зависимости (`pubspec.yaml`)

```yaml
dependencies:
  flutter: {sdk: flutter}
  flutter_localizations: {sdk: flutter}
  <UI>: {path: packages/<UI>}
  dio: ^5.10.0
  depend: ^5.1.4              # DI-контейнер
  talker: ^5.1.17             # лог
  talker_dio_logger_plus: ^1.0.5
  talker_flutter: ^5.0.0      # экран лога
  go_router: ^18.0.1
  flutter_secure_storage: ^10.3.1
  shared_preferences: ^2.5.5
  intl: any

dev_dependencies:
  flutter_test: {sdk: flutter}
  flutter_lints: ^6.0.0
  go_router_builder: ^4.5.0
  build_runner: ^2.15.1

flutter:
  uses-material-design: true
  generate: true
```

`analysis_options.yaml` — `include: package:flutter_lints/flutter.yaml` плюс плагин,
который ловит сырые строки в виджетах:

```yaml
plugins:
  markup_analyzer:
    version: ^4.1.0
    diagnostics:
      simple_string: error
      string_interpolation: error
      adjacent_strings: error
      binary_string_literal: error
      binary_expression: info
```

`l10n.yaml`:

```yaml
arb-dir: assets/translations
output-dir: lib/generated
template-arb-file: ru.arb
output-localization-file: app_localizations.dart
untranslated-messages-file: lib/generated/untranslated-messages.txt
```

---

## 4. Core-примитивы

Это фундамент. Реализуй их первыми и ровно с этими контрактами.

### 4.1 `core/domain/entities/params.dart`

```dart
/// Маркер аргументов запроса — фильтры, поисковая строка, сортировка.
/// Поля пагинации живут в [ListParams], не здесь.
abstract class Params { const Params(); }

mixin JsonBody { Map<String, dynamic> toJson(); }
mixin MultipartBody { FormData toFormData(); }
mixin QueryString { Map<String, dynamic> toQuery(); }
```

Каждый запрос получает свой класс параметров, даже пустой (`class VacanciesParams extends
Params { const VacanciesParams(); }`) — он же место, куда потом лягут фильтры.
Запрос без аргументов у `RequestNotifier` параметризуется `Null` и вызывается `request(null)`.

**Сериализация параметров — не в `domain`.** `Params` остаётся чистым; `toJson`/`toQuery`
живут в `data` (в модели запроса или в `extension` рядом с сетевым репозиторием), потому что
domain не обязан знать, что сервер называет `full_time`.

### 4.2 `list_params.dart` / `list_data.dart` / `list_data_model.dart`

```dart
class ListParams<T extends Params> {
  const ListParams({required this.offset, required this.params, this.limit = 20});
  final int offset;   // сколько уже загружено
  final int limit;
  final T params;
}

class ListData<T> {
  const ListData({required this.items, required this.hasNextPage, required this.maxCount});
  final List<T> items;
  final bool hasNextPage;
  final int maxCount;  // всего по запросу, для заголовка «найдено N»
}
```

`ListDataModel<T> extends ListData<T>` в `core/data/models/` — с `fromJson(json, itemFromJson)`,
разбирающим конверт `{items, hasNextPage, maxCount}`. Курсор не носим: следующий offset — это
количество уже загруженных элементов.

### 4.3 `core/domain/described_exception.dart`

```dart
/// Исключение, которое уже знает, что сказать читателю.
abstract interface class DescribedException implements Exception {
  /// Готовая фраза на языке читателя, или null — тогда работает общая классификация.
  String? get message;
}
```

Репозиторий бросает такое, когда у его домена есть слово для отказа (истёкший код, троттлинг)
и бэкенд прислал фразу. Лежит в `core/domain`, чтобы `data` могла его реализовать, не импортируя
`presentation`.

### 4.4 `core/presentation/failure_message.dart`

Одна функция `String failureMessage(AppLocalizations l10n, Object? error)`. Порядок разбора:

1. `DescribedException` с непустым `message` — вернуть его.
2. `DioException`: сначала фраза из конверта ошибки бэкенда
   (`{"error": {"code": ..., "message": ...}}`), затем `switch` по `DioExceptionType`:
   таймауты → `errorTimeout`, `connectionError` → `errorConnection`,
   `badCertificate` → `errorCertificate`, `badResponse` → `errorFormat`,
   `cancel` → `errorUnknown`, `unknown` → развернуть `error.error` рекурсивно
   (с проверкой `identical`, иначе зациклится).
3. `TimeoutException` → `errorTimeout`.
4. `SocketException` → connection; `TlsException` → certificate; `HttpException`,
   `WebSocketException` → connection; `FileSystemException`, `IOException` → storage.
   Порядок важен: все они `IOException`, общий кейс съест частные.
5. `FormatException` → format; `PlatformException` → platform.
6. Всё остальное → `errorUnknown`.

Вызывается **только из нотифаеров**, никогда из экрана — поэтому принимает `l10n`, а не
`BuildContext`. Никаких «фолбэков на вызывающего»: фраза, угадывающая, что делал экран, —
это догадка, выданная за объяснение.

### 4.5 `core/presentation/app_text.dart`

```dart
/// Активные локализации для слоя без BuildContext.
abstract final class AppText {
  static Locale _locale = const Locale('ru');
  static set locale(Locale value) => _locale = value;
  static AppLocalizations get current => lookupAppLocalizations(_locale);
}
```

Нотифаеры живут дольше экранов и `AppLocalizations.of` им недоступен, а превращать ошибку в
фразу — их работа. `main` выставляет `AppText.locale` до первого кадра и подписывается на смену
языка. Намеренно один изменяемый холдер, а не аргумент конструктора: протаскивать локаль через
сорок нотифаеров ради тех нескольких, что падают, — правка всех ради немногих.

### 4.6 `core/presentation/request_notifier.dart`

```dart
sealed class RequestState<T> { const RequestState(); }
class RequestInitial<T> extends RequestState<T> { const RequestInitial(); }
class RequestLoading<T> extends RequestState<T> { const RequestLoading(this.data); final T? data; }
class RequestSuccess<T> extends RequestState<T> { const RequestSuccess(this.data); final T data; }
class RequestError<T>   extends RequestState<T> {
  const RequestError(this.message, [this.exception]);
  final String message; final Object? exception;
}

abstract class RequestNotifier<T, P extends Params?> extends ValueNotifier<RequestState<T>> {
  RequestNotifier() : super(RequestInitial<T>());

  @protected
  Future<T> fetch(P params);

  Future<void> request(P params) async {
    final current = value;
    if (current is RequestLoading) return;             // повторный запуск на лету — no-op
    value = RequestLoading<T>(current is RequestSuccess<T> ? current.data : null);
    try {
      value = RequestSuccess<T>(await fetch(params));
    } catch (error) {
      value = RequestError<T>(failureMessage(AppText.current, error), error);
    }
  }
}
```

Ключевое: **`RequestLoading` несёт предыдущие данные**, и экран обязан их рисовать:

```dart
RequestSuccess<Profile>(:final data) ||
RequestLoading<Profile>(data: final data?) => _Header(data),
```

Спиннер — только когда нести нечего. Обновление, подменяющее нарисованный ответ спиннером,
это мигание, которое не сообщает читателю ничего нового.

Нотифаер не хранит своих аргументов: каждый запуск получает, что тянуть.

### 4.7 `core/presentation/paginated_list_notifier.dart`

```dart
sealed class ListState<T> { }
class ListInitial<T> extends ListState<T> { }
class ListLoading<T> extends ListState<T> { final ListData<T>? data; }
class ListSuccess<T> extends ListState<T> {
  final ListData<T> data; final bool loadingMore;
  ListSuccess<T> copyWith({ListData<T>? data, bool? loadingMore});
}
class ListError<T> extends ListState<T> { final String message; final Object? exception; }

abstract class PaginatedListNotifier<T, P extends Params> extends ValueNotifier<ListState<T>> {
  PaginatedListNotifier({this.limit = 20});
  final int limit;

  @protected
  Future<ListData<T>> fetchPage(ListParams<P> params);

  Future<void> request(P params);  // новый запрос, с первой страницы; запоминает params для reset
  Future<void> refresh();          // перезагрузить текущий запрос с первой страницы
  Future<void> reset();            // вернуться к запросу последнего request()
  Future<void> loadMore();         // дописать следующую страницу; окно двигает сам нотифаер
}
```

Контракт:

- До первого `request` валиден только он; остальные бросают `StateError`.
- `_load()` публикует `ListLoading(<предыдущая страница>)` **до** любого `await` — значит,
  уведомляет синхронно. Поэтому вызов из `initState` требует `addPostFrameCallback`:
  `InheritedNotifier` помечает себя грязным на каждое уведомление, а build не может испачкать
  уже построенного предка.
- `loadMore` — no-op, если список не загружен, `hasNextPage == false` или уже идёт догрузка.
  Следующий `offset` = `items.length`. Провал догрузки тихо снимает `loadingMore`, оставляя
  загруженное на месте.
- Ошибка первой загрузки → `ListError` с фразой из `failureMessage`.

### 4.8 `core/presentation/notifier_scope.dart`

```dart
/// Один провайдер на любой Listenable. Вместо своего InheritedNotifier под каждый нотифаер.
class NotifierScope<N extends Listenable> extends InheritedNotifier<N> {
  const NotifierScope({super.key, required N controller, required super.child})
      : super(notifier: controller);

  /// Подписывается — вызывающий перестраивается. Для build.
  static N of<N extends Listenable>(BuildContext context);

  /// Не подписывается. Для колбэков и initState.
  static N read<N extends Listenable>(BuildContext context);
}
```

Каждый тип-аргумент — отдельный inherited-тип в рантайме, скоупы разных нотифаеров не сталкиваются.
`of` — `dependOnInheritedWidgetOfExactType`, `read` — `getInheritedWidgetOfExactType`.
Оба с `assert`, называющим отсутствующий тип.

### 4.9 `core/presentation/multi_scope.dart`

```dart
typedef ScopeWrapper = Widget Function(Widget child);

/// Оборачивает child в каждый wrapper — первый в списке снаружи.
class MultiScope extends StatelessWidget {
  const MultiScope({super.key, required this.wrappers, required this.child});
  final List<ScopeWrapper> wrappers;
  final Widget child;

  @override
  Widget build(BuildContext context) =>
      wrappers.reversed.fold(child, (acc, wrap) => wrap(acc));
}
```

Разворачивает пирамиду скоупов в корне приложения в плоский список.

### 4.10 `core/dependencies/http/httpclient.dart`

Обёртка над `Dio`, а не голый `Dio`:

- Конструктор `AppHttpClient({required String baseUrl, Talker? talker})`.
- `BaseOptions` с JSON content-type/accept и таймаутами 20 c.
- Интерцептор логирования, пишущий в **тот же** `Talker`, который держит контейнер, — иначе
  экран лога откроется на пустой истории и будет выглядеть как кнопка, которая ничего не пишет.
- `Dio get instance`, `String get baseUrl`.
- `addInterceptor` / `removeInterceptor<I>()` / `changeInterceptor<I>()` — сессия добавляет
  `AuthInterceptor` после логина и снимает после выхода.
- `changeApiUrl(String)` — для переключения окружения на лету.
- Фильтры логирования по списку шумных путей.

### 4.11 `core/dependencies/locale_storage/`

Интерфейс `LocaleStorage` (`read`/`write`/`delete` по ключу) и две реализации:
`SecureLocaleStorageImpl` (flutter_secure_storage — токены и секреты) и
`LocaleStorageImpl` (SharedPreferences — настройки, кэши, непубличные-но-несекретные id).
Правило выбора пишем комментарием на месте использования: секреты — в secure, предпочтения —
в public, потому что secure медленнее.

### 4.12 `core/dependencies/container/`

`depend`-контейнер: **плоский список финальных полей**, никаких сервис-локаторов и никакого
`get_it`.

```dart
class RootContainer extends DependencyContainer {
  RootContainer({required this.talker, required this.httpClient, /* ... */});
  final Talker talker;
  final AppHttpClient httpClient;
  final LocaleStorage secureStorage;
  final LocaleStorage publicStorage;
  final <X>Repository <x>Repository;   // по одному полю на репозиторий
}

class RootFactory extends DependencyFactory<RootContainer> {
  @override
  Future<RootContainer> create() async { /* собрать всё и вернуть */ }
}
```

- Фабрика — единственное место, где сетевые реализации встречаются со своими интерфейсами.
- Асинхронная подготовка (открыть SharedPreferences, восстановить кэш, инициализировать SDK)
  живёт здесь, до первого кадра.
- Рядом — `MockRootFactory`, собирающая тот же контейнер из моков. Включается
  `--dart-define=MOCKS=true`; поскольку флаг `const`, компилятор выкидывает неиспользованную ветку.
- Если у капабилити несколько ролей (чтение, запись, диагностика) — держим их **плоско,
  отдельными полями**, а не одним «god-объектом»: потребитель, дотягивающийся до `reset()`,
  когда ему нужен только лог, — ровно то, что этот раскол предотвращает.

### 4.13 `core/env/env.dart`

```dart
abstract final class Env {
  static const bool useMocks = bool.fromEnvironment('MOCKS');
  static const String apiBaseUrl =
      String.fromEnvironment('API_BASE_URL', defaultValue: '<API_URL>');
}
```

Всё `const` и с рабочим дефолтом, чтобы обычный `flutter run` работал. Ответ на вопрос
«куда смотрит эта сборка» — чтение одного файла, а не grep по литералам.
Каждая константа с doc-комментарием: что означает, чем грозит другое значение.

**URL передаём целиком.** Если что-то принимает адрес — оно принимает готовый `url`,
а не `baseUrl` + `path`, которые вызываемый склеит сам.

### 4.14 Навигация

`go_router` + `go_router_builder` (typed routes).

- `core/navigation/navigator_keys.dart` — `rootNavigatorKey`, `shellNavigatorKey`(s).
- `core/navigation/app_routes.dart` — все маршруты как `GoRouteData`-классы с
  `@TypedGoRoute<...>`; `part 'app_routes.g.dart'`.
- `core/navigation/app_router.dart` — `AppRouter.create({required bool authorized})`,
  `initialLocation` по сессии, `routes: $appRoutes`, `errorBuilder`.

Правила:

- **Экран детали принимает модель nullable + обязательный id.** Пришли из списка — модель
  уже есть, рисуем сразу; пришли по ссылке — модель `null`, экран сам грузит по id и
  показывает загрузку/ошибку. Это то, что делает deep link работающим без редиректов.
- Модель едет в `$extra`, id — в пути. Форма редактирования, которой модель нужна обязательно,
  оборачивается в `<X>Loader`-виджет, который дожидается загрузки и только потом строит форму.
- Пикеры (выбрать город, навыки, дату) — `TypedRelativeGoRoute`, объявленные один раз и
  перечисленные под каждым родителем, который их открывает. Тогда `pop` возвращает в ту форму,
  что спросила, а не в фиксированную.
- Экран возвращает результат типизированно: `await const NewXRoute().push<XOutcome>(context)`.

Регенерация: `dart run build_runner build --delete-conflicting-outputs`.

### 4.15 Адаптив

- `core/presentation/app_breakpoints.dart` — **две** ширины, не четыре:
  `enum AppWidth { phone, desktop }` с оператором сравнения и `AppWidth.of(context)`.
  Планшет ведёт себя как десктоп; промежуточные варианты добавляют кода больше, чем смысла.
- `core/presentation/content_column.dart` — ограничивает контент по максимальной ширине и
  центрирует, чтобы на широком окне текст не растягивался через весь экран.
- Оболочка окна (`WindowShell`) решает: телефон — нижняя панель, десктоп — боковой rail.
  Список вкладок и построение пункта навигации — общий код, разделяемый панелью и rail'ом.

---

## 5. Слой data: как пишется репозиторий

Четыре файла на сущность:

1. **`<x>_repository.dart`** — `abstract interface class XRepository` с doc-комментарием на
   каждом методе: что возвращает, кто имеет право звать, что гарантирует сервер.
2. **`<x>_model.dart`** — `class XModel extends X` с `factory XModel.fromJson`.
   Модель наследует сущность, а не дублирует её.
   - Неизвестное значение enum → `null`, а не исключение и не дефолт: запись с типом,
     добавленным после этого релиза, всё равно должна отобразиться, просто без одной подписи.
   - Непарсящаяся дата → эпоха: видимо неверная дата заметнее молча потерянной.
   - `json['x'] as String? ?? ''` — сервер, забывший поле, не должен ронять страницу.
3. **`<x>_request.dart`** — `extension XRequest on XDraft { Map<String, dynamic> toJson() }`
   и приватные функции `enum → wire string`. Сериализация здесь, а не в domain.
4. **`network_<x>_repository.dart`** — реализация поверх `AppHttpClient`.
   Пути — `static const _path`; для guarded-роутов отдельная константа `_adminPath`.
   `Uri.encodeComponent` на подставляемые id.

Плюс **`mock_<x>_repository.dart`** — та же поверхность на фиктивных данных с задержкой.
Мок — не тестовая заглушка, а второй полноправный вход в приложение: он должен позволять
пройти сценарий целиком.

Кэширующий репозиторий, если нужен, — **декоратор**: `CachedXRepository` принимает сетевой
и хранилище, реализует тот же интерфейс, добавляет `restore()`, который фабрика зовёт до
первого кадра.

---

## 6. Слой presentation: правила

- **Нотифаер на операцию**, не на экран: `XListNotifier`, `XNotifier`, `CreateXNotifier`,
  `UpdateXNotifier`, `DeleteXNotifier`. Мутации — обычный `RequestNotifier`; отдельной
  базы «как RequestNotifier, только с методами» не заводим.
- Нотифаеры **app-scoped**: создаются в `main`, раздаются через `MultiScope` + `NotifierScope`.
  Экран их не создаёт и не диспозит.
- В `build` — `NotifierScope.of<N>(context)`; в `initState` и колбэках —
  `NotifierScope.read<N>(context)`.
- Первую загрузку из `initState` запускать через `WidgetsBinding.instance.addPostFrameCallback`.
- Пагинация: `ScrollController` + порог (~320 px до конца) → `loadMore()`;
  pull-to-refresh → `refresh()`.
- Один `final l10n = AppLocalizations.of(context)!` на `build`, один `final t = context.attractor`.
  Не повторять поиск в местах использования.
- Состояния рисуем `switch`-выражением по sealed-состоянию, с обязательной веткой
  «загрузка со старыми данными».
- Приватные подвиджеты (`_Header`, `_XList`) — в том же файле, если они не переиспользуются.

### Формы

- **Каждое поле формы — свой `Controller`** (`TextEditingController` или свой
  `ValueNotifier`-контроллер). Никаких `setState` по `onChanged` и никаких `initialValue`.
- **Валидация — через `Form`/`FormField`.** Ошибка на конкретном поле — это его собственный
  `FormField`, а не флаг «показать ошибку» в стейте.
- Маска ввода — своя на каждый вариант поля (`mask_text_input_formatter`), а не одна маска с
  `null` для «остальных».
- Переключатель, дёргающий разрешение или бэкенд, двигается оптимистично, а сам вызов
  дебаунсится (`core/utils/debouncer.dart`).

### Домейн-энумы

Голые: без полей, без конструкторов, без `extension`-ов с подписями. Подпись выбирается
`switch`-ем там, где рисуется, — потому что подпись зависит от локали и от места.

### Даты

Только `intl` `DateFormat` с локалью. Никаких рукописных таблиц месяцев и своих `MonthYear`.

---

## 7. Дизайн-система — отдельный пакет

`packages/<UI>/` со своим `pubspec.yaml` и `example/`-галереей.

```
lib/
  <UI>.dart          # единственный публичный вход: только export'ы
  src/
    tokens/          colors.dart, dimens.dart, typography.dart
    theme/           <app>_theme.dart (ThemeData light/dark), <app>_tokens.dart
    widgets/         button.dart, field.dart, card.dart, chip.dart, avatar.dart, ...
```

- Приложение подключает темы: `MaterialApp(theme: XTheme.light, darkTheme: XTheme.dark)`.
- Внутри виджета семантические токены берутся с контекста: `final t = context.<app>;`
  → `t.surface`, `t.text.title`. Сырые цвета из `colors.dart` в приложении не используются.
- Пакет **не импортирует** приложение и ничего не знает про фичи.
- Виджеты, принимающие иконку, принимают `IconData` — иконки не рисуем руками.
- Аватар — только виджет из пакета. Никаких `ClipOval`/`CircleAvatar` в приложении.
- Пакет несёт свои локализации (`UiKitLocalizations`) для строк, которые принадлежат виджету.
- Прежде чем писать свой форматтер/хелпер — проверь список параметров виджета: скорее всего,
  он уже это умеет.

---

## 8. `main.dart` — единственное место сборки

Порядок:

```dart
Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  final container = await (Env.useMocks ? MockRootFactory() : RootFactory()).create();

  // Настройки читаем до первого кадра — приложение не должно нарисовать одну тему и сменить её.
  final themeController = await ThemeController.load(container.themeRepository);
  final languageController = await LanguageController.load(container.languageRepository);

  // Единственная строка, сообщающая нотифаерам язык, и она до того, как хоть один упадёт.
  AppText.locale = languageController.value.locale;
  languageController.addListener(() => AppText.locale = languageController.value.locale);

  // Все нотифаеры — по одному на строку, с репозиториями из контейнера.
  final xListNotifier = XListNotifier(container.xRepository);
  // ...

  // Сессию восстанавливаем до первого кадра, чтобы не мигнуть экраном входа.
  await authSessionNotifier.fetch();
  if (authSessionNotifier.value) {
    // Засеять то, что должно быть верным на первом кадре: профиль, бейджи, счётчики.
    profileNotifier.request(null);
  }

  runApp(
    DependencyProvider(
      dependency: container,
      child: MultiScope(
        wrappers: [  // первый в списке — самый внешний
          (child) => NotifierScope<ThemeController>(controller: themeController, child: child),
          (child) => NotifierScope<LanguageController>(controller: languageController, child: child),
          // ... по одной строке на нотифаер
        ],
        child: const App(),
      ),
    ),
  );
}
```

Виджет `App` читает тему и язык из скоупов, строит `MaterialApp.router` с
`AppRouter.create(authorized: ...)`, `localizationsDelegates` (свои + `UiKit` + `Global*`),
`supportedLocales`, и `builder`, который навешивает адаптивную оболочку и (в debug) кнопку лога.

Комментируй **каждый** «засев до первого кадра»: почему именно здесь, что увидит пользователь,
если этого не сделать.

---

## 9. Локализация

- ARB-файлы в `assets/translations/`, шаблон — `<основная локаль>.arb`.
- В ARB попадает **всё**, что рендерится: заголовки, ошибки, названия вкладок, бренд, «©».
- Ключи — по смыслу и месту: `vacancyListTitle`, `errorTimeout`, `themeModeDark`.
- Строки ошибок (`errorTimeout`, `errorConnection`, `errorCertificate`, `errorFormat`,
  `errorStorage`, `errorPlatform`, `errorUnknown`) заводятся сразу — их требует `failureMessage`.
- `flutter gen-l10n` (или `flutter run`) генерит `lib/generated/app_localizations.dart`.
- `flutter analyze` **из корня** — иначе плагин, ловящий сырые строки, молча не запустится.

---

## 10. Тесты

Пиши тесты только там, где просят, либо где механизм иначе не проверить. Обязательный минимум
для каркаса:

- `test/navigation/routes_test.dart` — разбор адресов в маршруты, включая deep link на
  экран детали без предзагруженной модели.
- Тест на пагинирующий нотифаер: первая страница, `loadMore`, ошибка догрузки не стирает
  загруженное.
- Тест на `<X>Loader`: загрузка, мгновенный показ при переданной модели, ошибка.

В виджет-тестах, где нотифаер ждёт сеть, не используй `pumpAndSettle` — она зависает на
бесконечных анимациях и на висящих футурах; делай серию `pump(Duration(...))`.
Флаг `flutter test --timeout` не перебивает таймаут Dart VM — если тест висит, чинится тест,
а не флаг.

Не создавай тестовые файлы, которых не просили.

---

## 11. Порядок работ

1. **Каркас проекта**: `pubspec.yaml`, `analysis_options.yaml`, `l10n.yaml`, дерево каталогов,
   пустой ARB с ошибочными ключами. → `flutter analyze` зелёный.
2. **Core-домейн**: `Params`, `ListParams`, `ListData`, `ListDataModel`, `DescribedException`.
3. **Core-инфраструктура**: `Env`, `AppHttpClient`, `LocaleStorage` (обе реализации),
   `RootContainer` + `RootFactory` + `MockRootFactory` (пока пустые).
4. **Core-презентация**: `AppText`, `failureMessage`, `RequestNotifier`,
   `PaginatedListNotifier`, `NotifierScope`, `MultiScope`, `AppWidth`, `ContentColumn`.
5. **Дизайн-система**: пакет `<UI>` с токенами, темой и минимальным набором виджетов
   (кнопка, поле, карточка, аватар, чип, навбар).
6. **Навигация**: `navigator_keys`, `app_routes` с двумя-тремя маршрутами, `app_router`,
   генерация `app_routes.g.dart`, оболочка окна с вкладками/rail'ом.
7. **`main.dart`**: сборка контейнера, контроллеры темы и языка, `MultiScope`, `MaterialApp.router`.
8. **Вертикальный срез `<FEATURES>[0]`** целиком: domain → data (интерфейс, модель, request,
   сетевой репозиторий, мок) → presentation (список-нотифаер, деталь-нотифаер, мутации, экраны),
   регистрация в контейнере, в `main`, в маршрутах. Deep link на деталь работает.
9. **Тесты** из раздела 10.
10. **Остальные фичи** — по образцу среза из п. 8, без отступлений.

После каждого этапа: `flutter analyze` из корня + `flutter test`. Сообщай, что именно
прошло и что нет — не заявляй о готовности без вывода команд.

---

## 12. Чек-лист «добавить фичу»

- [ ] `feature/<x>/domain/entities/` — сущность + `<X>Params extends Params` (+ `<X>Draft`, если есть форма)
- [ ] `feature/<x>/data/<x>_repository.dart` — `abstract interface class` с doc на каждом методе
- [ ] `<x>_model.dart` — `extends` сущности, `fromJson`, неизвестные enum → `null`
- [ ] `<x>_request.dart` — `extension` с `toJson`, маппинг enum → строка
- [ ] `network_<x>_repository.dart` и `mock_<x>_repository.dart`
- [ ] поле в `RootContainer`, сборка в `RootFactory` и в `MockRootFactory`
- [ ] по нотифаеру на операцию, каждый в своём файле
- [ ] создание нотифаеров в `main`, обёртки в `MultiScope`
- [ ] экраны: `switch` по состоянию, `RequestLoading` со старыми данными рисуется
- [ ] маршруты в `app_routes.dart`, деталь принимает nullable-модель + обязательный id
- [ ] все строки — в ARB, ни одной в коде
- [ ] `flutter analyze` из корня, `flutter test`

---

## 13. Чего не делать

- Не заводить `get_it`, `provider`, `riverpod`, `bloc` — состояние держат `ValueNotifier` +
  `InheritedNotifier`.
- Не генерить модели (`freezed`, `json_serializable`) — `fromJson` пишется руками, потому что
  все решения о «неизвестном значении» и «битой дате» принимаются вручную.
  Кодогенерация — только `go_router_builder`.
- Не класть сериализацию в `domain`.
- Не создавать use-case/interactor-прослойки.
- Не заводить второй `Talker`, второй `Dio`, второй контейнер.
- Не писать `try/catch` в экране: ошибку в фразу превращает нотифаер.
- Не подменять загруженные данные спиннером при обновлении.
- Не хардкодить строки и не глушить анализатор `// ignore`.
- Не добавлять брейкпойнты сверх `phone`/`desktop` без реальной причины.
- Не писать тесты, о которых не просили.
