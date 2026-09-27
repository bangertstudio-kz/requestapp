// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Russian (`ru`).
class AppLocalizationsRu extends AppLocalizations {
  AppLocalizationsRu([String locale = 'ru']) : super(locale);

  @override
  String get appTitle => 'Заявки на материалы';

  @override
  String get actionBack => 'Назад';

  @override
  String get actionClose => 'Закрыть';

  @override
  String get actionClearSearch => 'Очистить поиск';

  @override
  String get actionSave => 'Сохранить';

  @override
  String get actionCancel => 'Отмена';

  @override
  String get actionDelete => 'Удалить';

  @override
  String get actionSend => 'Отправить';

  @override
  String get actionEditShort => 'Изм.';

  @override
  String get actionRemove => 'Удалить запись';

  @override
  String get actionReorder => 'Перетащить, чтобы изменить порядок';

  @override
  String get actionRetry => 'Повторить';

  @override
  String get actionBackspace => 'Стереть';

  @override
  String get navRequests => 'Заявки';

  @override
  String get navCatalog => 'Справочник';

  @override
  String get navSettings => 'Настройки';

  @override
  String get statusDraft => 'Черновик';

  @override
  String get statusSaved => 'Сохранена';

  @override
  String get statusSent => 'Отправлена';

  @override
  String get unitPiece => 'шт.';

  @override
  String get unitMeter => 'м.п.';

  @override
  String get unitSet => 'комплект';

  @override
  String get requestsTitle => 'Заявки';

  @override
  String requestsSubtitle(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count заявки',
      many: '$count заявок',
      few: '$count заявки',
      one: '$count заявка',
    );
    return '$_temp0';
  }

  @override
  String get requestsSearchHint => 'Поиск по заявкам';

  @override
  String get requestsFilterAll => 'Все';

  @override
  String get requestsFilterDrafts => 'Черновики';

  @override
  String get requestsFilterSaved => 'Сохранённые';

  @override
  String get requestsFilterSent => 'Отправленные';

  @override
  String get requestsFoldersLabel => 'Папки';

  @override
  String get requestsFolderNew => 'Папка';

  @override
  String requestsListAll(int count) {
    return 'Все заявки · $count';
  }

  @override
  String requestsListInFolder(int count) {
    return 'Заявки в папке · $count';
  }

  @override
  String get requestsEmpty => 'Ничего не найдено.\nИзмените запрос или фильтр.';

  @override
  String get requestsCreate => 'Создать заявку';

  @override
  String requestPositions(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count позиции',
      many: '$count позиций',
      few: '$count позиции',
      one: '$count позиция',
    );
    return '$_temp0';
  }

  @override
  String requestPositionsWord(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'позиции',
      many: 'позиций',
      few: 'позиции',
      one: 'позиция',
    );
    return '$_temp0';
  }

  @override
  String get dateFormatShort => 'dd.MM.yyyy';

  @override
  String requestFolderCount(int count) {
    return '$count';
  }

  @override
  String get requestDetailTitle => 'Заявка';

  @override
  String get requestNameLabel => 'Название заявки';

  @override
  String requestMaterialsLabel(int count) {
    return 'Материалы · $count';
  }

  @override
  String get requestItemsEmpty =>
      'В заявке пока нет материалов.\nНажмите «Добавить материал».';

  @override
  String get requestAddMaterial => 'Добавить материал';

  @override
  String get requestIncreaseQuantity => 'Увеличить количество';

  @override
  String get requestDecreaseQuantity => 'Уменьшить количество';

  @override
  String get requestItemTitle => 'Позиция заявки';

  @override
  String get requestItemReplaceMaterial => 'Заменить материал';

  @override
  String get pickTitle => 'Добавить материал';

  @override
  String get pickSubtitle => 'Категория, материал и количество';

  @override
  String get pickSearchHint => 'Поиск по материалам';

  @override
  String get pickHintTree => 'Категория → подкатегория → материал';

  @override
  String pickHintFound(int count) {
    return 'Найдено · $count';
  }

  @override
  String get pickAddToRequest => 'Добавить в заявку';

  @override
  String get pickCollapseMark => '−';

  @override
  String get pickSearching => 'Ищем…';

  @override
  String get pickNothingFound =>
      'Ничего не найдено.\nПроверьте запрос или откройте дерево.';

  @override
  String get pickScrollTop => 'Наверх';

  @override
  String pickCategoryMeta(int subcategories, int materials) {
    return '$subcategories подкат. · $materials мат.';
  }

  @override
  String pickSubcategoriesShort(int count) {
    return '$count подкат.';
  }

  @override
  String pickMaterialsShort(int count) {
    return '$count мат.';
  }

  @override
  String get quantityLabel => 'Количество';

  @override
  String get quantityHint => 'Единица из справочника';

  @override
  String get quantityEmpty => '0';

  @override
  String get catalogTitle => 'Справочник';

  @override
  String get catalogSubtitle => 'Категории, подкатегории и материалы';

  @override
  String get catalogTabCategories => 'Категории';

  @override
  String get catalogTabMaterials => 'Материалы';

  @override
  String catalogCategoriesLabel(int count) {
    return 'Категории · $count';
  }

  @override
  String catalogMaterialsLabel(int count) {
    return 'Материалы · $count';
  }

  @override
  String catalogInsideLabel(int count) {
    return 'Внутри · $count';
  }

  @override
  String catalogCategoryMeta(int count, String names) {
    return '$count внутри · $names';
  }

  @override
  String catalogMaterialsInCategory(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count материала в категории',
      many: '$count материалов в категории',
      few: '$count материала в категории',
      one: '$count материал в категории',
    );
    return '$_temp0';
  }

  @override
  String catalogMaterialsCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count материала',
      many: '$count материалов',
      few: '$count материала',
      one: '$count материал',
    );
    return '$_temp0';
  }

  @override
  String get catalogCategoriesEmpty =>
      'В справочнике нет категорий.\nЗагрузите прайс или добавьте категорию.';

  @override
  String get catalogInsideEmpty =>
      'Здесь пока пусто.\nДобавьте категорию или материал.';

  @override
  String get catalogMaterialsEmpty =>
      'В категории нет материалов.\nНажмите «+ Материал».';

  @override
  String get catalogImportTitle => 'Обновить справочник';

  @override
  String get catalogImportSubtitle => 'Импорт материалов из Excel';

  @override
  String get catalogImportOpen => 'Загрузить материалы';

  @override
  String get catalogExportOpen => 'Выгрузить в Excel';

  @override
  String get catalogExportSubject => 'Справочник материалов';

  @override
  String get catalogImportHowTitle => 'Как подготовить файл';

  @override
  String get catalogImportHowStep1 =>
      'Попросите чат — ChatGPT, Claude и подобные — собрать ваш прайс в файл Excel. Промт ниже.';

  @override
  String get catalogImportHowStep2 =>
      'Скачайте готовый .xlsx из чата. Если чат не умеет файлы — он выведет таблицу: скопируйте её в пустой лист Excel и сохраните как .xlsx.';

  @override
  String get catalogImportHowStep3 =>
      'Вернитесь сюда, выберите категорию и файл.';

  @override
  String get catalogImportPromptShow => 'Показать промт';

  @override
  String get catalogImportPromptHide => 'Скрыть промт';

  @override
  String get catalogImportPromptCopy => 'Скопировать промт';

  @override
  String get catalogImportPromptCopied => 'Промт скопирован';

  @override
  String get catalogImportPrompt =>
      'Собери мой список материалов в файл Excel (.xlsx) и дай его скачать.\n\nВ файле один лист с названием «Материалы» и три колонки; первая строка — заголовок:\n1) Путь   2) Материал   3) Единица\n\nПравила:\n- «Путь» — вложенные категории через « / », например: Труба / Чугунная. Если материал кладётся прямо в выбранную категорию — оставь пусто.\n- «Материал» — название целиком, как в прайсе, вместе с типоразмером.\n- «Единица» — строго одно из: шт., м.п., комплект. Если в исходнике другая единица — выбери ближайшую из этих трёх.\n- Одна строка — один материал. Ничего не придумывай: чего нет в исходнике, оставь пусто.\n- Никаких лишних листов, колонок, итогов и пояснений внутри файла.\n\nЕсли сделать файл не можешь — выведи ту же таблицу текстом, колонки раздели табуляцией: её можно вставить в пустой лист Excel и сохранить как .xlsx.\n\nВот список:\n';

  @override
  String get catalogImportTargetLabel => 'Куда загрузить';

  @override
  String get catalogImportTargetRoot => 'В корень справочника';

  @override
  String get catalogImportTargetHint =>
      'Пути из файла считаются от выбранной категории';

  @override
  String get catalogImportRootNote =>
      'В корне справочника материал лежать не может: строки с пустым путём будут пропущены.';

  @override
  String get catalogImportPickFile => 'Выбрать файл';

  @override
  String get catalogImportPickAnother => 'Выбрать другой файл';

  @override
  String get catalogImportParsing => 'Разбираем файл…';

  @override
  String get catalogImportFileLabel => 'Файл';

  @override
  String get catalogImportStatsLabel => 'Что изменится';

  @override
  String get catalogImportAdded => 'Новых материалов';

  @override
  String get catalogImportUpdated => 'Обновится';

  @override
  String get catalogImportCategoriesCreated => 'Новых категорий';

  @override
  String get catalogImportWarningsLabel => 'Предупреждения';

  @override
  String catalogImportDuplicates(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Удалено $count полных дубля строк',
      many: 'Удалено $count полных дублей строк',
      few: 'Удалено $count полных дубля строк',
      one: 'Удалён $count полный дубль строки',
    );
    return '$_temp0';
  }

  @override
  String catalogImportTrimmed(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'В $count строках убраны лишние пробелы',
      many: 'В $count строках убраны лишние пробелы',
      few: 'В $count строках убраны лишние пробелы',
      one: 'В $count строке убраны лишние пробелы',
    );
    return '$_temp0';
  }

  @override
  String catalogImportSkipped(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other:
          'Пропущено $count строки: нет названия, неизвестна единица или некуда положить',
      many:
          'Пропущено $count строк: нет названия, неизвестна единица или некуда положить',
      few:
          'Пропущено $count строки: нет названия, неизвестна единица или некуда положить',
      one:
          'Пропущена $count строка: нет названия, неизвестна единица или некуда положить',
    );
    return '$_temp0';
  }

  @override
  String catalogImportUnknownUnits(String units) {
    return 'Неизвестные единицы измерения: $units. Допустимы только шт., м.п. и комплект — такие строки не загрузятся.';
  }

  @override
  String get catalogImportReplaceNote =>
      'Импорт дополняет справочник: материал с таким же названием в той же ветке обновится, остальные добавятся. Заявки не изменятся — в них лежат копии материалов на момент добавления.';

  @override
  String get catalogImportApply => 'Добавить в справочник';

  @override
  String get catalogImportRetry => 'Повторить';

  @override
  String get confirmImportTitle => 'Добавить в справочник?';

  @override
  String confirmImportText(int count) {
    return 'В справочник будет записано $count материалов из файла.';
  }

  @override
  String get confirmImportAction => 'Добавить';

  @override
  String snackCatalogImported(int count) {
    return 'Загружено материалов: $count';
  }

  @override
  String get catalogNewCategory => 'Категория';

  @override
  String get catalogAdd => 'Добавить';

  @override
  String get catalogAddTitle => 'Что добавить';

  @override
  String get catalogAddCategory => 'Категорию';

  @override
  String get catalogAddItem => 'Материал';

  @override
  String get catalogNewMaterial => 'Материал';

  @override
  String catalogMaterialMeta(String path, String unit) {
    return '$path · $unit';
  }

  @override
  String get pathSeparator => ' → ';

  @override
  String materialQuantity(int value) {
    return '$value';
  }

  @override
  String get formTitleCategory => 'Категория';

  @override
  String get formTitleMaterial => 'Материал';

  @override
  String get formTitleFolder => 'Папка';

  @override
  String get formPlacementLabel => 'Где разместить';

  @override
  String get formPlacementRoot => 'На верхнем уровне';

  @override
  String get formPlacementInside => 'Внутри другой категории';

  @override
  String get formParentLabel => 'Внутри';

  @override
  String get formParentEmpty => 'Выберите категорию';

  @override
  String get formSubtitleNew => 'Новая запись';

  @override
  String get formSubtitleEdit => 'Редактирование';

  @override
  String get formNameLabel => 'Название';

  @override
  String get formNameHint => 'Например, Труба ⌀100/2000';

  @override
  String get formCategoryLabel => 'Категория';

  @override
  String get formUnitLabel => 'Единица измерения';

  @override
  String get formNameRequired => 'Введите название';

  @override
  String get formCategoryRequired => 'Выберите категорию';

  @override
  String get folderSheetTitle => 'Перенести заявку';

  @override
  String folderSheetCurrent(String name) {
    return 'Сейчас: $name';
  }

  @override
  String get folderSheetHere => 'здесь';

  @override
  String get folderOutside => 'Вне папок';

  @override
  String get folderNew => 'Новая папка…';

  @override
  String get requestFolderLabel => 'Папка';

  @override
  String get previewTitle => 'Проверьте файлы';

  @override
  String previewFileSize(String size) {
    return '$size КБ';
  }

  @override
  String get previewPdfFailed => 'Не удалось показать страницы PDF';

  @override
  String get previewSheetFailed => 'Не удалось прочитать таблицу';

  @override
  String get itemDeletedFromCatalog => 'Материал удалён';

  @override
  String get sendSheetTitle => 'Отправить заявку';

  @override
  String get sendSheetSubtitle => 'Выберите формат вложения';

  @override
  String get sendFormatExcel => 'Excel';

  @override
  String get sendFormatPdf => 'PDF';

  @override
  String get sendFormatBoth => 'Excel и PDF';

  @override
  String get confirmDeleteRequestTitle => 'Удалить заявку?';

  @override
  String confirmDeleteRequestText(String name, int count) {
    return 'Заявка «$name» и все её $count позиций будут удалены с устройства.';
  }

  @override
  String get confirmDeleteCategoryTitle => 'Удалить категорию?';

  @override
  String confirmDeleteCategoryText(String name) {
    return 'Категория «$name» удалится вместе со всеми подкатегориями и материалами внутри. Заявки не изменятся.';
  }

  @override
  String get confirmDeleteMaterialTitle => 'Удалить материал?';

  @override
  String confirmDeleteMaterialText(String name) {
    return 'Материал «$name» удалится из справочника. В заявках он останется: там хранятся копии.';
  }

  @override
  String get catalogMaterialsEmptyAll =>
      'В справочнике нет материалов.\nЗагрузите прайс или добавьте материал.';

  @override
  String get confirmDeleteItemTitle => 'Удалить материал?';

  @override
  String get confirmDeleteItemText => 'Позиция будет удалена из заявки.';

  @override
  String get snackQuantityRequired => 'Укажите количество';

  @override
  String get snackQuantityUpdated => 'Количество обновлено';

  @override
  String snackMaterialAdded(String name, int quantity, String unit) {
    return '$name · $quantity $unit — добавлено';
  }

  @override
  String snackMaterialReplaced(String name) {
    return 'Материал заменён на $name';
  }

  @override
  String snackMaterialQuantityUpdated(String name, int quantity, String unit) {
    return '$name · теперь $quantity $unit';
  }

  @override
  String get duplicateTitle => 'Материал уже в заявке';

  @override
  String duplicateText(String name, int current, String unit) {
    return '$name — сейчас $current $unit.';
  }

  @override
  String duplicateAdd(int total, String unit) {
    return 'Прибавить · будет $total $unit';
  }

  @override
  String duplicateReplace(int quantity, String unit) {
    return 'Заменить на $quantity $unit';
  }

  @override
  String get snackMaterialRemovedFromRequest => 'Материал удалён из заявки';

  @override
  String get snackSavedToDevice => 'Сохранено на устройство: XML и PDF';

  @override
  String snackSent(String format) {
    return 'Отправлено · $format';
  }

  @override
  String get snackRequestDeleted => 'Заявка удалена';

  @override
  String get snackNothingToSend => 'В заявке нет позиций — отправлять нечего';

  @override
  String snackMovedToFolder(String name) {
    return 'Заявка перенесена в «$name»';
  }

  @override
  String get snackMovedOutOfFolders => 'Заявка вынесена из папок';

  @override
  String get snackFolderCreated => 'Папка создана';

  @override
  String get snackCategorySaved => 'Категория сохранена';

  @override
  String get snackMaterialSaved => 'Материал сохранён';

  @override
  String get snackCategoryRemoved => 'Категория удалена';

  @override
  String get snackMaterialRemovedFromCatalog =>
      'Материал удалён из справочника';

  @override
  String get settingsTitle => 'Настройки';

  @override
  String get settingsSubtitle => 'Параметры приложения';

  @override
  String get settingsLanguageLabel => 'Язык';

  @override
  String get languageRussian => 'Русский';

  @override
  String get languageEnglish => 'English';

  @override
  String get languageKazakh => 'Қазақша';

  @override
  String get languageCat => 'Кошачий 🐱';

  @override
  String get settingsThemeLabel => 'Тема';

  @override
  String get themeSystem => 'Как в системе';

  @override
  String get themeLight => 'Светлая';

  @override
  String get themeDark => 'Тёмная';

  @override
  String get routeNotFound => 'Такого экрана нет.\nВозможно, ссылка устарела.';

  @override
  String get routeNotFoundAction => 'К заявкам';

  @override
  String get errorTimeout => 'Сервер не ответил вовремя. Попробуйте ещё раз.';

  @override
  String get errorConnection => 'Нет связи с сервером. Проверьте подключение.';

  @override
  String get errorCertificate => 'Не удалось проверить сертификат сервера.';

  @override
  String get errorFormat => 'Сервер ответил в неожиданном формате.';

  @override
  String get errorStorage => 'Не удалось прочитать данные на устройстве.';

  @override
  String get errorPlatform => 'Устройство отклонило операцию.';

  @override
  String get errorUnknown => 'Что-то пошло не так. Попробуйте ещё раз.';
}

/// The translations for Russian (`ru_CAT`).
class AppLocalizationsRuCat extends AppLocalizationsRu {
  AppLocalizationsRuCat() : super('ru_CAT');

  @override
  String get appTitle => 'Мррррр мя мяуууу';

  @override
  String get actionBack => 'Мяууу';

  @override
  String get actionClose => 'Муррмяу';

  @override
  String get actionClearSearch => 'Мррррр мяууу';

  @override
  String get actionSave => 'Мяуууу';

  @override
  String get actionCancel => 'Муррмяу';

  @override
  String get actionDelete => 'Муррмяу';

  @override
  String get actionSend => 'Муррмяу';

  @override
  String get actionEditShort => 'Мур.';

  @override
  String get actionRemove => 'Муррмяу муррмяу';

  @override
  String get actionReorder => 'Мррррр, муррр мррррр муррмяу';

  @override
  String get actionRetry => 'Мррррр';

  @override
  String get actionBackspace => 'Мяуууу';

  @override
  String get navRequests => 'Мррррр';

  @override
  String get navCatalog => 'Муррмяу';

  @override
  String get navSettings => 'Мяуууу';

  @override
  String get statusDraft => 'Мяуууу';

  @override
  String get statusSaved => 'Мяуууу';

  @override
  String get statusSent => 'Муррмяу';

  @override
  String get unitPiece => 'мр.';

  @override
  String get unitMeter => 'мр.мр.';

  @override
  String get unitSet => 'мяуууу';

  @override
  String get requestsTitle => 'Мррррр';

  @override
  String requestsSubtitle(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count мяуууу',
      many: '$count мяуууу',
      few: '$count мяуууу',
      one: '$count мррррр',
    );
    return '$_temp0';
  }

  @override
  String get requestsSearchHint => 'Муррр мя муррмяу';

  @override
  String get requestsFilterAll => 'Мур';

  @override
  String get requestsFilterDrafts => 'Мяуууу';

  @override
  String get requestsFilterSaved => 'Мяуууу';

  @override
  String get requestsFilterSent => 'Мррррр';

  @override
  String get requestsFoldersLabel => 'Мяууу';

  @override
  String get requestsFolderNew => 'Муррр';

  @override
  String requestsListAll(int count) {
    return 'Мур мяуууу · $count';
  }

  @override
  String requestsListInFolder(int count) {
    return 'Мррррр мр мяв-мяв · $count';
  }

  @override
  String get requestsEmpty => 'Мяуууу мр мррррр.\nМяуууу муррмяу мяу мррррр.';

  @override
  String get requestsCreate => 'Муррмяу муррмяу';

  @override
  String requestPositions(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count мррррр',
      many: '$count муррмяу',
      few: '$count мррррр',
      one: '$count мяуууу',
    );
    return '$_temp0';
  }

  @override
  String requestPositionsWord(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'мррррр',
      many: 'муррмяу',
      few: 'мррррр',
      one: 'мяуууу',
    );
    return '$_temp0';
  }

  @override
  String get requestDetailTitle => 'Муррмяу';

  @override
  String get requestNameLabel => 'Муррмяу мяуууу';

  @override
  String requestMaterialsLabel(int count) {
    return 'Мррррр · $count';
  }

  @override
  String get requestItemsEmpty =>
      'Мр мяуууу мурр мяу муррмяу.\nМяуууу «Муррмяу муррмяу».';

  @override
  String get requestAddMaterial => 'Муррмяу муррмяу';

  @override
  String get requestIncreaseQuantity => 'Муррмяу муррмяу';

  @override
  String get requestDecreaseQuantity => 'Муррмяу муррмяу';

  @override
  String get requestItemTitle => 'Мррррр мяуууу';

  @override
  String get requestItemReplaceMaterial => 'Мяуууу муррмяу';

  @override
  String get pickTitle => 'Муррмяу муррмяу';

  @override
  String get pickSubtitle => 'Мяуууу, муррмяу мр муррмяу';

  @override
  String get pickSearchHint => 'Муррр мя мррррр';

  @override
  String get pickHintTree => 'Мяуууу → муррмяу → муррмяу';

  @override
  String pickHintFound(int count) {
    return 'Муррмяу · $count';
  }

  @override
  String get pickAddToRequest => 'Муррмяу мр муррмяу';

  @override
  String get pickSearching => 'Мурр…';

  @override
  String get pickNothingFound =>
      'Мяуууу мр мррррр.\nМуррмяу муррмяу мяу мяуууу мяуууу.';

  @override
  String get pickScrollTop => 'Мяуууу';

  @override
  String pickCategoryMeta(int subcategories, int materials) {
    return '$subcategories мяуууу. · $materials мяу.';
  }

  @override
  String pickSubcategoriesShort(int count) {
    return '$count мяуууу.';
  }

  @override
  String pickMaterialsShort(int count) {
    return '$count мяу.';
  }

  @override
  String get quantityLabel => 'Мяуууу';

  @override
  String get quantityHint => 'Мррррр мя муррмяу';

  @override
  String get catalogTitle => 'Муррмяу';

  @override
  String get catalogSubtitle => 'Мррррр, мяуууу мр мяуууу';

  @override
  String get catalogTabCategories => 'Мррррр';

  @override
  String get catalogTabMaterials => 'Мррррр';

  @override
  String catalogCategoriesLabel(int count) {
    return 'Мррррр · $count';
  }

  @override
  String catalogMaterialsLabel(int count) {
    return 'Мррррр · $count';
  }

  @override
  String catalogInsideLabel(int count) {
    return 'Мррррр · $count';
  }

  @override
  String catalogCategoryMeta(int count, String names) {
    return '$count мяуууу · $names';
  }

  @override
  String catalogMaterialsInCategory(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count мяуууу мр мяуууу',
      many: '$count муррмяу мр мяуууу',
      few: '$count мяуууу мр мяуууу',
      one: '$count муррмяу мр мяуууу',
    );
    return '$_temp0';
  }

  @override
  String catalogMaterialsCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count мяуууу',
      many: '$count муррмяу',
      few: '$count мяуууу',
      one: '$count муррмяу',
    );
    return '$_temp0';
  }

  @override
  String get catalogCategoriesEmpty =>
      'Мр мррррр мяу мррррр.\nМуррмяу мяв-мяв мяу мррррр мррррр.';

  @override
  String get catalogInsideEmpty =>
      'Муррр мурр муррр.\nМуррмяу мррррр мяу муррмяу.';

  @override
  String get catalogMaterialsEmpty =>
      'Мр мяуууу мяу муррмяу.\nМяуууу «+ Мяуууу».';

  @override
  String get catalogImportTitle => 'Мррррр мррррр';

  @override
  String get catalogImportSubtitle => 'Муррмяу муррмяу мя Excel';

  @override
  String get catalogImportOpen => 'Мррррр мяуууу';

  @override
  String get catalogExportOpen => 'Муррмяу мр Excel';

  @override
  String get catalogExportSubject => 'Муррмяу муррмяу';

  @override
  String get catalogImportHowTitle => 'Мяу мррррр мррр';

  @override
  String get catalogImportHowStep1 =>
      'Муррмяу мрр — ChatGPT, Claude мр мррррр — мррррр мрр мяв-мяв мр мррр Excel. Мяууу мяуу.';

  @override
  String get catalogImportHowStep2 =>
      'Мяуууу мяуууу .xlsx мя мяуу. Мурр мрр мр муррр мяууу — мя мяуууу мррррр: муррмяу мр мр мррррр мурр Excel мр мяуууу мрр .xlsx.';

  @override
  String get catalogImportHowStep3 => 'Мррррр мурр, муррмяу мррррр мр мррр.';

  @override
  String get catalogImportPromptShow => 'Мррррр мяв-мяв';

  @override
  String get catalogImportPromptHide => 'Муррмяу мяв-мяв';

  @override
  String get catalogImportPromptCopy => 'Мяуууу мяв-мяв';

  @override
  String get catalogImportPromptCopied => 'Мяууу мррррр';

  @override
  String get catalogImportTargetLabel => 'Мррр мяуууу';

  @override
  String get catalogImportTargetRoot => 'Мр мррррр муррмяу';

  @override
  String get catalogImportTargetHint =>
      'Мррр мя мяууу муррмяу мр мррррр мяуууу';

  @override
  String get catalogImportRootNote =>
      'Мр мяууу муррмяу муррмяу мррррр мр мяууу: мррррр мр муррмяу мяууу мяууу мррррр.';

  @override
  String get catalogImportPickFile => 'Мяуууу мррр';

  @override
  String get catalogImportPickAnother => 'Мяуууу мррррр мррр';

  @override
  String get catalogImportParsing => 'Муррмяу мррр…';

  @override
  String get catalogImportFileLabel => 'Мяуу';

  @override
  String get catalogImportStatsLabel => 'Мрр мррррр';

  @override
  String get catalogImportAdded => 'Мяв-мяв муррмяу';

  @override
  String get catalogImportUpdated => 'Мррррр';

  @override
  String get catalogImportCategoriesCreated => 'Мяв-мяв мррррр';

  @override
  String get catalogImportWarningsLabel => 'Муррмяу';

  @override
  String catalogImportDuplicates(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Мррррр $count мррррр мяв-мяв мяв-мяв',
      many: 'Мррррр $count мррррр мяуууу мяв-мяв',
      few: 'Мррррр $count мррррр мяв-мяв мяв-мяв',
      one: 'Муррмяу $count мррррр мяв-мяв мррррр',
    );
    return '$_temp0';
  }

  @override
  String catalogImportTrimmed(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Мр $count мяуууу мяуууу муррмяу муррмяу',
      many: 'Мр $count мяуууу мяуууу муррмяу муррмяу',
      few: 'Мр $count мяуууу мяуууу муррмяу муррмяу',
      one: 'Мр $count мррррр мяуууу муррмяу муррмяу',
    );
    return '$_temp0';
  }

  @override
  String catalogImportSkipped(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other:
          'Мррррр $count мррррр: мяу мяуууу, мррррр мяуууу мяу муррмяу мррррр',
      many:
          'Мррррр $count мяв-мяв: мяу мяуууу, мррррр мяуууу мяу муррмяу мррррр',
      few: 'Мррррр $count мррррр: мяу мяуууу, мррррр мяуууу мяу муррмяу мррррр',
      one:
          'Муррмяу $count муррмяу: мяу мяуууу, мррррр мяуууу мяу муррмяу мррррр',
    );
    return '$_temp0';
  }

  @override
  String catalogImportUnknownUnits(String units) {
    return 'Муррмяу мяуууу муррмяу: $units. Муррмяу мррррр мр., мр.мр. мр мяуууу — муррр мррррр мр муррмяу.';
  }

  @override
  String get catalogImportReplaceNote =>
      'Муррмяу мррррр мррррр: муррмяу мр мяв-мяв мя муррмяу мр мрр мя мяууу мяуууу, мяуууу мяуууу. Мррррр мр мяуууу — мр мяу мяууу мяууу муррмяу мя мррррр муррмяу.';

  @override
  String get catalogImportApply => 'Муррмяу мр мррррр';

  @override
  String get catalogImportRetry => 'Мррррр';

  @override
  String get confirmImportTitle => 'Муррмяу мр мррррр?';

  @override
  String confirmImportText(int count) {
    return 'Мр мррррр муррр мяуууу $count муррмяу мя мяууу.';
  }

  @override
  String get confirmImportAction => 'Муррмяу';

  @override
  String snackCatalogImported(int count) {
    return 'Муррмяу муррмяу: $count';
  }

  @override
  String get catalogNewCategory => 'Мяуууу';

  @override
  String get catalogAdd => 'Муррмяу';

  @override
  String get catalogAddTitle => 'Мрр мррррр';

  @override
  String get catalogAddCategory => 'Муррмяу';

  @override
  String get catalogAddItem => 'Мяуууу';

  @override
  String get catalogNewMaterial => 'Мяуууу';

  @override
  String get formTitleCategory => 'Мяуууу';

  @override
  String get formTitleMaterial => 'Мяуууу';

  @override
  String get formTitleFolder => 'Муррр';

  @override
  String get formPlacementLabel => 'Мур мяуууу';

  @override
  String get formPlacementRoot => 'Мя муррмяу муррмяу';

  @override
  String get formPlacementInside => 'Мррррр мррррр мяуууу';

  @override
  String get formParentLabel => 'Мррррр';

  @override
  String get formParentEmpty => 'Мяуууу мррррр';

  @override
  String get formSubtitleNew => 'Мяууу муррмяу';

  @override
  String get formSubtitleEdit => 'Мррррр';

  @override
  String get formNameLabel => 'Муррмяу';

  @override
  String get formNameHint => 'Мяуууу, Мяууу ⌀100/2000';

  @override
  String get formCategoryLabel => 'Мяуууу';

  @override
  String get formUnitLabel => 'Мррррр муррмяу';

  @override
  String get formNameRequired => 'Мяуууу мррррр';

  @override
  String get formCategoryRequired => 'Мяуууу мррррр';

  @override
  String get folderSheetTitle => 'Мяуууу муррмяу';

  @override
  String folderSheetCurrent(String name) {
    return 'Муррмяу: $name';
  }

  @override
  String get folderSheetHere => 'мяууу';

  @override
  String get folderOutside => 'Мяу мяв-мяв';

  @override
  String get folderNew => 'Мяууу мяууу…';

  @override
  String get requestFolderLabel => 'Муррр';

  @override
  String get previewTitle => 'Муррмяу мяууу';

  @override
  String previewFileSize(String size) {
    return '$size МЯ';
  }

  @override
  String get previewPdfFailed => 'Мр мяуууу мяуууу муррмяу PDF';

  @override
  String get previewSheetFailed => 'Мр мяуууу мррррр мррррр';

  @override
  String get itemDeletedFromCatalog => 'Мяуууу мррррр';

  @override
  String get sendSheetTitle => 'Муррмяу муррмяу';

  @override
  String get sendSheetSubtitle => 'Мяуууу мррррр мррррр';

  @override
  String get sendFormatBoth => 'Excel мр PDF';

  @override
  String get confirmDeleteRequestTitle => 'Муррмяу муррмяу?';

  @override
  String confirmDeleteRequestText(String name, int count) {
    return 'Муррмяу «$name» мр мяу мр $count муррмяу мяууу мррррр мр мррррр.';
  }

  @override
  String get confirmDeleteCategoryTitle => 'Муррмяу мррррр?';

  @override
  String confirmDeleteCategoryText(String name) {
    return 'Мяуууу «$name» мррррр мррррр мя муррр мяуууу мр мррррр мяуууу. Мррррр мр мяуууу.';
  }

  @override
  String get confirmDeleteMaterialTitle => 'Муррмяу муррмяу?';

  @override
  String confirmDeleteMaterialText(String name) {
    return 'Мяуууу «$name» мррррр мя муррмяу. Мр муррмяу мя мяуууу: мяу мррррр мяууу.';
  }

  @override
  String get catalogMaterialsEmptyAll =>
      'Мр мррррр мяу муррмяу.\nМуррмяу мяв-мяв мяу мррррр муррмяу.';

  @override
  String get confirmDeleteItemTitle => 'Муррмяу муррмяу?';

  @override
  String get confirmDeleteItemText => 'Мррррр муррр мррррр мя мяуууу.';

  @override
  String get snackQuantityRequired => 'Мррррр муррмяу';

  @override
  String get snackQuantityUpdated => 'Мяуууу муррмяу';

  @override
  String snackMaterialAdded(String name, int quantity, String unit) {
    return '$name · $quantity $unit — мяуууу';
  }

  @override
  String snackMaterialReplaced(String name) {
    return 'Мяуууу муррмяу мя $name';
  }

  @override
  String snackMaterialQuantityUpdated(String name, int quantity, String unit) {
    return '$name · муррмяу $quantity $unit';
  }

  @override
  String get duplicateTitle => 'Мяуууу мяу мр мяуууу';

  @override
  String duplicateText(String name, int current, String unit) {
    return '$name — мррррр $current $unit.';
  }

  @override
  String duplicateAdd(int total, String unit) {
    return 'Мяуууу · муррр $total $unit';
  }

  @override
  String duplicateReplace(int quantity, String unit) {
    return 'Мяуууу мя $quantity $unit';
  }

  @override
  String get snackMaterialRemovedFromRequest => 'Мяуууу мррррр мя мяуууу';

  @override
  String get snackSavedToDevice => 'Муррмяу мя мяуууу: XML мр PDF';

  @override
  String snackSent(String format) {
    return 'Мррррр · $format';
  }

  @override
  String get snackRequestDeleted => 'Муррмяу мррррр';

  @override
  String get snackNothingToSend => 'Мр мяуууу мяу муррмяу — мяуууу муррмяу';

  @override
  String snackMovedToFolder(String name) {
    return 'Муррмяу мррррр мр «$name»';
  }

  @override
  String get snackMovedOutOfFolders => 'Муррмяу муррмяу мя мяв-мяв';

  @override
  String get snackFolderCreated => 'Муррр мррррр';

  @override
  String get snackCategorySaved => 'Мяуууу муррмяу';

  @override
  String get snackMaterialSaved => 'Мяуууу муррмяу';

  @override
  String get snackCategoryRemoved => 'Мяуууу мррррр';

  @override
  String get snackMaterialRemovedFromCatalog => 'Мяуууу мррррр мя муррмяу';

  @override
  String get settingsTitle => 'Мяуууу';

  @override
  String get settingsSubtitle => 'Мррррр мррррр';

  @override
  String get settingsLanguageLabel => 'Мррр';

  @override
  String get settingsThemeLabel => 'Мурр';

  @override
  String get themeSystem => 'Мяу мр мяуууу';

  @override
  String get themeLight => 'Муррмяу';

  @override
  String get themeDark => 'Мяуууу';

  @override
  String get routeNotFound => 'Муррмяу мррррр мяу.\nМяуууу, мяуууу мяуууу.';

  @override
  String get routeNotFoundAction => 'Мр муррмяу';

  @override
  String get errorTimeout => 'Мррррр мр мррррр мррррр. Мррррр мяу мрр.';

  @override
  String get errorConnection => 'Мур муррр мр мррррр. Муррмяу мррррр.';

  @override
  String get errorCertificate => 'Мр мяуууу мррррр мяуууу мррррр.';

  @override
  String get errorFormat => 'Мррррр мррррр мр мррррр мррррр.';

  @override
  String get errorStorage => 'Мр мяуууу мррррр мррррр мя мяуууу.';

  @override
  String get errorPlatform => 'Мррррр мррррр мяуууу.';

  @override
  String get errorUnknown => 'Мрр-мр мяв-мяв мр мур. Мррррр мяу мрр.';
}
