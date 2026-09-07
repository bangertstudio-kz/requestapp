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
  String get actionRetry => 'Повторить';

  @override
  String get actionBackspace => 'Стереть';

  @override
  String get navRequests => 'Заявки';

  @override
  String get navCatalog => 'Справочник';

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
  String catalogSubcategoriesLabel(int count) {
    return 'Подкатегории · $count';
  }

  @override
  String catalogCategoryMeta(int count, String names) {
    return '$count подкат. · $names';
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
  String get catalogSubcategoriesEmpty =>
      'В категории нет подкатегорий.\nНажмите «+ Подкатегория».';

  @override
  String get catalogMaterialsEmpty =>
      'В подкатегории нет материалов.\nНажмите «+ Материал».';

  @override
  String get catalogImportTitle => 'Обновить справочник';

  @override
  String get catalogImportSubtitle => 'Импорт из файла прайса';

  @override
  String get catalogImportOpen => 'Загрузить прайс';

  @override
  String get catalogImportIntro =>
      'Справочник целиком берётся из файла прайса заказчика. Выберите файл — приложение разберёт его и покажет, что именно загрузится.';

  @override
  String get catalogImportFormats =>
      'Excel (.xlsx), лист «Материал». Колонки: категория, подкатегория, материал, единица измерения.';

  @override
  String get catalogImportPickFile => 'Выбрать файл';

  @override
  String get catalogImportPickAnother => 'Выбрать другой файл';

  @override
  String get catalogImportParsing => 'Разбираем файл…';

  @override
  String get catalogImportFileLabel => 'Файл';

  @override
  String get catalogImportStatsLabel => 'Будет загружено';

  @override
  String get catalogImportCategories => 'Категории';

  @override
  String get catalogImportSubcategories => 'Подкатегории';

  @override
  String get catalogImportMaterials => 'Материалы';

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
      other: 'Пропущено $count строки без названия или категории',
      many: 'Пропущено $count строк без названия или категории',
      few: 'Пропущено $count строки без названия или категории',
      one: 'Пропущена $count строка без названия или категории',
    );
    return '$_temp0';
  }

  @override
  String catalogImportUnknownUnits(String units) {
    return 'Неизвестные единицы измерения: $units. Допустимы только шт., м.п. и комплект — такие строки не загрузятся.';
  }

  @override
  String get catalogImportReplaceNote =>
      'Импорт заменяет справочник целиком. Заявки не изменятся: в них лежат копии материалов на момент добавления.';

  @override
  String get catalogImportApply => 'Заменить справочник';

  @override
  String get catalogImportRetry => 'Повторить';

  @override
  String get confirmImportTitle => 'Заменить справочник?';

  @override
  String confirmImportText(int count) {
    return 'Текущие $count материалов будут удалены и заменены содержимым файла.';
  }

  @override
  String get confirmImportAction => 'Заменить';

  @override
  String snackCatalogImported(int count) {
    return 'Справочник обновлён: $count материалов';
  }

  @override
  String get catalogNewCategory => 'Категория';

  @override
  String get catalogNewSubcategory => 'Подкатегория';

  @override
  String get catalogNewMaterial => 'Материал';

  @override
  String catalogMaterialMeta(String path, String unit) {
    return '$path · $unit';
  }

  @override
  String materialPath(String category, String subcategory) {
    return '$category → $subcategory';
  }

  @override
  String materialQuantity(int value) {
    return '$value';
  }

  @override
  String get formTitleCategory => 'Категория';

  @override
  String get formTitleSubcategory => 'Подкатегория';

  @override
  String get formTitleMaterial => 'Материал';

  @override
  String get formTitleFolder => 'Папка';

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
  String get formSubcategoryLabel => 'Подкатегория';

  @override
  String get formUnitLabel => 'Единица измерения';

  @override
  String get formNameRequired => 'Введите название';

  @override
  String get formSubcategoryRequired => 'Выберите подкатегорию';

  @override
  String get sendSheetTitle => 'Отправить заявку';

  @override
  String get sendSheetSubtitle => 'Выберите формат вложения';

  @override
  String get sendFormatXml => 'XML';

  @override
  String get sendFormatPdf => 'PDF';

  @override
  String get sendFormatBoth => 'XML и PDF';

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
  String get confirmDeleteSubcategoryTitle => 'Удалить подкатегорию?';

  @override
  String confirmDeleteSubcategoryText(String name) {
    return 'Подкатегория «$name» удалится вместе с материалами внутри. Заявки не изменятся.';
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
  String get snackFolderCreated => 'Папка создана';

  @override
  String get snackCategorySaved => 'Категория сохранена';

  @override
  String get snackSubcategorySaved => 'Подкатегория сохранена';

  @override
  String get snackMaterialSaved => 'Материал сохранён';

  @override
  String get snackCategoryRemoved => 'Категория удалена';

  @override
  String get snackSubcategoryRemoved => 'Подкатегория удалена';

  @override
  String get snackMaterialRemovedFromCatalog =>
      'Материал удалён из справочника';

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
