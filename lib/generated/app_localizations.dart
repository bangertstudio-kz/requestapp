import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_ru.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'generated/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppLocalizations.localizationsDelegates,
///   supportedLocales: AppLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the AppLocalizations.supportedLocales
/// property.
abstract class AppLocalizations {
  AppLocalizations(String locale)
    : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations? of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations);
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates =
      <LocalizationsDelegate<dynamic>>[
        delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[Locale('ru')];

  /// Название приложения в списке задач системы
  ///
  /// In ru, this message translates to:
  /// **'Заявки на материалы'**
  String get appTitle;

  /// Подпись кнопки «назад» для скринридера
  ///
  /// In ru, this message translates to:
  /// **'Назад'**
  String get actionBack;

  /// No description provided for @actionClose.
  ///
  /// In ru, this message translates to:
  /// **'Закрыть'**
  String get actionClose;

  /// No description provided for @actionClearSearch.
  ///
  /// In ru, this message translates to:
  /// **'Очистить поиск'**
  String get actionClearSearch;

  /// No description provided for @actionSave.
  ///
  /// In ru, this message translates to:
  /// **'Сохранить'**
  String get actionSave;

  /// No description provided for @actionCancel.
  ///
  /// In ru, this message translates to:
  /// **'Отмена'**
  String get actionCancel;

  /// No description provided for @actionDelete.
  ///
  /// In ru, this message translates to:
  /// **'Удалить'**
  String get actionDelete;

  /// No description provided for @actionSend.
  ///
  /// In ru, this message translates to:
  /// **'Отправить'**
  String get actionSend;

  /// Кнопка правки в строке справочника; коротко, потому что стоит в одной строке с названием
  ///
  /// In ru, this message translates to:
  /// **'Изм.'**
  String get actionEditShort;

  /// Подпись крестика удаления для скринридера
  ///
  /// In ru, this message translates to:
  /// **'Удалить запись'**
  String get actionRemove;

  /// No description provided for @actionRetry.
  ///
  /// In ru, this message translates to:
  /// **'Повторить'**
  String get actionRetry;

  /// Подпись клавиши стирания на цифровой клавиатуре
  ///
  /// In ru, this message translates to:
  /// **'Стереть'**
  String get actionBackspace;

  /// No description provided for @navRequests.
  ///
  /// In ru, this message translates to:
  /// **'Заявки'**
  String get navRequests;

  /// No description provided for @navCatalog.
  ///
  /// In ru, this message translates to:
  /// **'Справочник'**
  String get navCatalog;

  /// No description provided for @statusDraft.
  ///
  /// In ru, this message translates to:
  /// **'Черновик'**
  String get statusDraft;

  /// No description provided for @statusSaved.
  ///
  /// In ru, this message translates to:
  /// **'Сохранена'**
  String get statusSaved;

  /// No description provided for @statusSent.
  ///
  /// In ru, this message translates to:
  /// **'Отправлена'**
  String get statusSent;

  /// No description provided for @unitPiece.
  ///
  /// In ru, this message translates to:
  /// **'шт.'**
  String get unitPiece;

  /// No description provided for @unitMeter.
  ///
  /// In ru, this message translates to:
  /// **'м.п.'**
  String get unitMeter;

  /// No description provided for @unitSet.
  ///
  /// In ru, this message translates to:
  /// **'комплект'**
  String get unitSet;

  /// No description provided for @requestsTitle.
  ///
  /// In ru, this message translates to:
  /// **'Заявки'**
  String get requestsTitle;

  /// No description provided for @requestsSubtitle.
  ///
  /// In ru, this message translates to:
  /// **'{count, plural, one{{count} заявка} few{{count} заявки} many{{count} заявок} other{{count} заявки}}'**
  String requestsSubtitle(int count);

  /// No description provided for @requestsSearchHint.
  ///
  /// In ru, this message translates to:
  /// **'Поиск по заявкам'**
  String get requestsSearchHint;

  /// No description provided for @requestsFilterAll.
  ///
  /// In ru, this message translates to:
  /// **'Все'**
  String get requestsFilterAll;

  /// No description provided for @requestsFilterDrafts.
  ///
  /// In ru, this message translates to:
  /// **'Черновики'**
  String get requestsFilterDrafts;

  /// No description provided for @requestsFilterSaved.
  ///
  /// In ru, this message translates to:
  /// **'Сохранённые'**
  String get requestsFilterSaved;

  /// No description provided for @requestsFilterSent.
  ///
  /// In ru, this message translates to:
  /// **'Отправленные'**
  String get requestsFilterSent;

  /// No description provided for @requestsFoldersLabel.
  ///
  /// In ru, this message translates to:
  /// **'Папки'**
  String get requestsFoldersLabel;

  /// Кнопка «+ Папка»: плюс рисует иконка, слово приходит отсюда
  ///
  /// In ru, this message translates to:
  /// **'Папка'**
  String get requestsFolderNew;

  /// No description provided for @requestsListAll.
  ///
  /// In ru, this message translates to:
  /// **'Все заявки · {count}'**
  String requestsListAll(int count);

  /// No description provided for @requestsListInFolder.
  ///
  /// In ru, this message translates to:
  /// **'Заявки в папке · {count}'**
  String requestsListInFolder(int count);

  /// Перенос строки намеренный: вторая строка — подсказка действия
  ///
  /// In ru, this message translates to:
  /// **'Ничего не найдено.\nИзмените запрос или фильтр.'**
  String get requestsEmpty;

  /// No description provided for @requestsCreate.
  ///
  /// In ru, this message translates to:
  /// **'Создать заявку'**
  String get requestsCreate;

  /// No description provided for @requestPositions.
  ///
  /// In ru, this message translates to:
  /// **'{count, plural, one{{count} позиция} few{{count} позиции} many{{count} позиций} other{{count} позиции}}'**
  String requestPositions(int count);

  /// Только слово: число рядом с ним рисуется моноширинным шрифтом и потому стоит отдельным текстом
  ///
  /// In ru, this message translates to:
  /// **'{count, plural, one{позиция} few{позиции} many{позиций} other{позиции}}'**
  String requestPositionsWord(int count);

  /// Шаблон intl для даты заявки. В ARB, потому что порядок частей даты — свойство локали
  ///
  /// In ru, this message translates to:
  /// **'dd.MM.yyyy'**
  String get dateFormatShort;

  /// Счётчик заявок в строке папки — моноширинный, без слова
  ///
  /// In ru, this message translates to:
  /// **'{count}'**
  String requestFolderCount(int count);

  /// No description provided for @requestDetailTitle.
  ///
  /// In ru, this message translates to:
  /// **'Заявка'**
  String get requestDetailTitle;

  /// No description provided for @requestNameLabel.
  ///
  /// In ru, this message translates to:
  /// **'Название заявки'**
  String get requestNameLabel;

  /// No description provided for @requestMaterialsLabel.
  ///
  /// In ru, this message translates to:
  /// **'Материалы · {count}'**
  String requestMaterialsLabel(int count);

  /// No description provided for @requestItemsEmpty.
  ///
  /// In ru, this message translates to:
  /// **'В заявке пока нет материалов.\nНажмите «Добавить материал».'**
  String get requestItemsEmpty;

  /// No description provided for @requestAddMaterial.
  ///
  /// In ru, this message translates to:
  /// **'Добавить материал'**
  String get requestAddMaterial;

  /// No description provided for @requestIncreaseQuantity.
  ///
  /// In ru, this message translates to:
  /// **'Увеличить количество'**
  String get requestIncreaseQuantity;

  /// No description provided for @requestDecreaseQuantity.
  ///
  /// In ru, this message translates to:
  /// **'Уменьшить количество'**
  String get requestDecreaseQuantity;

  /// No description provided for @requestItemTitle.
  ///
  /// In ru, this message translates to:
  /// **'Позиция заявки'**
  String get requestItemTitle;

  /// No description provided for @requestItemReplaceMaterial.
  ///
  /// In ru, this message translates to:
  /// **'Заменить материал'**
  String get requestItemReplaceMaterial;

  /// No description provided for @pickTitle.
  ///
  /// In ru, this message translates to:
  /// **'Добавить материал'**
  String get pickTitle;

  /// No description provided for @pickSubtitle.
  ///
  /// In ru, this message translates to:
  /// **'Категория, материал и количество'**
  String get pickSubtitle;

  /// No description provided for @pickSearchHint.
  ///
  /// In ru, this message translates to:
  /// **'Поиск по материалам'**
  String get pickSearchHint;

  /// No description provided for @pickHintTree.
  ///
  /// In ru, this message translates to:
  /// **'Категория → подкатегория → материал'**
  String get pickHintTree;

  /// No description provided for @pickHintFound.
  ///
  /// In ru, this message translates to:
  /// **'Найдено · {count}'**
  String pickHintFound(int count);

  /// No description provided for @pickAddToRequest.
  ///
  /// In ru, this message translates to:
  /// **'Добавить в заявку'**
  String get pickAddToRequest;

  /// Метка раскрытой строки дерева вместо счётчика
  ///
  /// In ru, this message translates to:
  /// **'−'**
  String get pickCollapseMark;

  /// Подпись над списком, пока первый поиск ещё идёт
  ///
  /// In ru, this message translates to:
  /// **'Ищем…'**
  String get pickSearching;

  /// Пустой результат поиска по справочнику
  ///
  /// In ru, this message translates to:
  /// **'Ничего не найдено.\nПроверьте запрос или откройте дерево.'**
  String get pickNothingFound;

  /// Возврат к строке поиска из глубины длинного списка
  ///
  /// In ru, this message translates to:
  /// **'Наверх'**
  String get pickScrollTop;

  /// Счётчики свёрнутой категории. Число материалов важнее числа подкатегорий: по нему видно, что в ППР дерево листать не стоит
  ///
  /// In ru, this message translates to:
  /// **'{subcategories} подкат. · {materials} мат.'**
  String pickCategoryMeta(int subcategories, int materials);

  /// No description provided for @pickSubcategoriesShort.
  ///
  /// In ru, this message translates to:
  /// **'{count} подкат.'**
  String pickSubcategoriesShort(int count);

  /// No description provided for @pickMaterialsShort.
  ///
  /// In ru, this message translates to:
  /// **'{count} мат.'**
  String pickMaterialsShort(int count);

  /// No description provided for @quantityLabel.
  ///
  /// In ru, this message translates to:
  /// **'Количество'**
  String get quantityLabel;

  /// No description provided for @quantityHint.
  ///
  /// In ru, this message translates to:
  /// **'Единица из справочника'**
  String get quantityHint;

  /// Заглушка на табло, пока количество не введено
  ///
  /// In ru, this message translates to:
  /// **'0'**
  String get quantityEmpty;

  /// No description provided for @catalogTitle.
  ///
  /// In ru, this message translates to:
  /// **'Справочник'**
  String get catalogTitle;

  /// No description provided for @catalogSubtitle.
  ///
  /// In ru, this message translates to:
  /// **'Категории, подкатегории и материалы'**
  String get catalogSubtitle;

  /// No description provided for @catalogTabCategories.
  ///
  /// In ru, this message translates to:
  /// **'Категории'**
  String get catalogTabCategories;

  /// No description provided for @catalogTabMaterials.
  ///
  /// In ru, this message translates to:
  /// **'Материалы'**
  String get catalogTabMaterials;

  /// No description provided for @catalogCategoriesLabel.
  ///
  /// In ru, this message translates to:
  /// **'Категории · {count}'**
  String catalogCategoriesLabel(int count);

  /// No description provided for @catalogMaterialsLabel.
  ///
  /// In ru, this message translates to:
  /// **'Материалы · {count}'**
  String catalogMaterialsLabel(int count);

  /// No description provided for @catalogSubcategoriesLabel.
  ///
  /// In ru, this message translates to:
  /// **'Подкатегории · {count}'**
  String catalogSubcategoriesLabel(int count);

  /// No description provided for @catalogCategoryMeta.
  ///
  /// In ru, this message translates to:
  /// **'{count} подкат. · {names}'**
  String catalogCategoryMeta(int count, String names);

  /// No description provided for @catalogMaterialsInCategory.
  ///
  /// In ru, this message translates to:
  /// **'{count, plural, one{{count} материал в категории} few{{count} материала в категории} many{{count} материалов в категории} other{{count} материала в категории}}'**
  String catalogMaterialsInCategory(int count);

  /// No description provided for @catalogMaterialsCount.
  ///
  /// In ru, this message translates to:
  /// **'{count, plural, one{{count} материал} few{{count} материала} many{{count} материалов} other{{count} материала}}'**
  String catalogMaterialsCount(int count);

  /// No description provided for @catalogCategoriesEmpty.
  ///
  /// In ru, this message translates to:
  /// **'В справочнике нет категорий.\nЗагрузите прайс или добавьте категорию.'**
  String get catalogCategoriesEmpty;

  /// No description provided for @catalogSubcategoriesEmpty.
  ///
  /// In ru, this message translates to:
  /// **'В категории нет подкатегорий.\nНажмите «+ Подкатегория».'**
  String get catalogSubcategoriesEmpty;

  /// No description provided for @catalogMaterialsEmpty.
  ///
  /// In ru, this message translates to:
  /// **'В подкатегории нет материалов.\nНажмите «+ Материал».'**
  String get catalogMaterialsEmpty;

  /// No description provided for @catalogImportTitle.
  ///
  /// In ru, this message translates to:
  /// **'Обновить справочник'**
  String get catalogImportTitle;

  /// No description provided for @catalogImportSubtitle.
  ///
  /// In ru, this message translates to:
  /// **'Импорт из файла прайса'**
  String get catalogImportSubtitle;

  /// Подпись кнопки-иконки в шапке справочника для скринридера
  ///
  /// In ru, this message translates to:
  /// **'Загрузить прайс'**
  String get catalogImportOpen;

  /// No description provided for @catalogImportIntro.
  ///
  /// In ru, this message translates to:
  /// **'Справочник целиком берётся из файла прайса заказчика. Выберите файл — приложение разберёт его и покажет, что именно загрузится.'**
  String get catalogImportIntro;

  /// No description provided for @catalogImportFormats.
  ///
  /// In ru, this message translates to:
  /// **'Excel (.xlsx), лист «Материал». Колонки: категория, подкатегория, материал, единица измерения.'**
  String get catalogImportFormats;

  /// No description provided for @catalogImportPickFile.
  ///
  /// In ru, this message translates to:
  /// **'Выбрать файл'**
  String get catalogImportPickFile;

  /// No description provided for @catalogImportPickAnother.
  ///
  /// In ru, this message translates to:
  /// **'Выбрать другой файл'**
  String get catalogImportPickAnother;

  /// No description provided for @catalogImportParsing.
  ///
  /// In ru, this message translates to:
  /// **'Разбираем файл…'**
  String get catalogImportParsing;

  /// No description provided for @catalogImportFileLabel.
  ///
  /// In ru, this message translates to:
  /// **'Файл'**
  String get catalogImportFileLabel;

  /// No description provided for @catalogImportStatsLabel.
  ///
  /// In ru, this message translates to:
  /// **'Будет загружено'**
  String get catalogImportStatsLabel;

  /// No description provided for @catalogImportCategories.
  ///
  /// In ru, this message translates to:
  /// **'Категории'**
  String get catalogImportCategories;

  /// No description provided for @catalogImportSubcategories.
  ///
  /// In ru, this message translates to:
  /// **'Подкатегории'**
  String get catalogImportSubcategories;

  /// No description provided for @catalogImportMaterials.
  ///
  /// In ru, this message translates to:
  /// **'Материалы'**
  String get catalogImportMaterials;

  /// No description provided for @catalogImportWarningsLabel.
  ///
  /// In ru, this message translates to:
  /// **'Предупреждения'**
  String get catalogImportWarningsLabel;

  /// No description provided for @catalogImportDuplicates.
  ///
  /// In ru, this message translates to:
  /// **'{count, plural, one{Удалён {count} полный дубль строки} few{Удалено {count} полных дубля строк} many{Удалено {count} полных дублей строк} other{Удалено {count} полных дубля строк}}'**
  String catalogImportDuplicates(int count);

  /// No description provided for @catalogImportTrimmed.
  ///
  /// In ru, this message translates to:
  /// **'{count, plural, one{В {count} строке убраны лишние пробелы} few{В {count} строках убраны лишние пробелы} many{В {count} строках убраны лишние пробелы} other{В {count} строках убраны лишние пробелы}}'**
  String catalogImportTrimmed(int count);

  /// No description provided for @catalogImportSkipped.
  ///
  /// In ru, this message translates to:
  /// **'{count, plural, one{Пропущена {count} строка без названия или категории} few{Пропущено {count} строки без названия или категории} many{Пропущено {count} строк без названия или категории} other{Пропущено {count} строки без названия или категории}}'**
  String catalogImportSkipped(int count);

  /// No description provided for @catalogImportUnknownUnits.
  ///
  /// In ru, this message translates to:
  /// **'Неизвестные единицы измерения: {units}. Допустимы только шт., м.п. и комплект — такие строки не загрузятся.'**
  String catalogImportUnknownUnits(String units);

  /// No description provided for @catalogImportReplaceNote.
  ///
  /// In ru, this message translates to:
  /// **'Импорт заменяет справочник целиком. Заявки не изменятся: в них лежат копии материалов на момент добавления.'**
  String get catalogImportReplaceNote;

  /// No description provided for @catalogImportApply.
  ///
  /// In ru, this message translates to:
  /// **'Заменить справочник'**
  String get catalogImportApply;

  /// No description provided for @catalogImportRetry.
  ///
  /// In ru, this message translates to:
  /// **'Повторить'**
  String get catalogImportRetry;

  /// No description provided for @confirmImportTitle.
  ///
  /// In ru, this message translates to:
  /// **'Заменить справочник?'**
  String get confirmImportTitle;

  /// No description provided for @confirmImportText.
  ///
  /// In ru, this message translates to:
  /// **'Текущие {count} материалов будут удалены и заменены содержимым файла.'**
  String confirmImportText(int count);

  /// No description provided for @confirmImportAction.
  ///
  /// In ru, this message translates to:
  /// **'Заменить'**
  String get confirmImportAction;

  /// No description provided for @snackCatalogImported.
  ///
  /// In ru, this message translates to:
  /// **'Справочник обновлён: {count} материалов'**
  String snackCatalogImported(int count);

  /// No description provided for @catalogNewCategory.
  ///
  /// In ru, this message translates to:
  /// **'Категория'**
  String get catalogNewCategory;

  /// No description provided for @catalogNewSubcategory.
  ///
  /// In ru, this message translates to:
  /// **'Подкатегория'**
  String get catalogNewSubcategory;

  /// No description provided for @catalogNewMaterial.
  ///
  /// In ru, this message translates to:
  /// **'Материал'**
  String get catalogNewMaterial;

  /// Вторая строка материала в плоском списке справочника
  ///
  /// In ru, this message translates to:
  /// **'{path} · {unit}'**
  String catalogMaterialMeta(String path, String unit);

  /// Путь материала. Стрелка — часть строки, а не склейка в коде
  ///
  /// In ru, this message translates to:
  /// **'{category} → {subcategory}'**
  String materialPath(String category, String subcategory);

  /// Количество в карточке позиции: целое число, моноширинно
  ///
  /// In ru, this message translates to:
  /// **'{value}'**
  String materialQuantity(int value);

  /// No description provided for @formTitleCategory.
  ///
  /// In ru, this message translates to:
  /// **'Категория'**
  String get formTitleCategory;

  /// No description provided for @formTitleSubcategory.
  ///
  /// In ru, this message translates to:
  /// **'Подкатегория'**
  String get formTitleSubcategory;

  /// No description provided for @formTitleMaterial.
  ///
  /// In ru, this message translates to:
  /// **'Материал'**
  String get formTitleMaterial;

  /// No description provided for @formTitleFolder.
  ///
  /// In ru, this message translates to:
  /// **'Папка'**
  String get formTitleFolder;

  /// No description provided for @formSubtitleNew.
  ///
  /// In ru, this message translates to:
  /// **'Новая запись'**
  String get formSubtitleNew;

  /// No description provided for @formSubtitleEdit.
  ///
  /// In ru, this message translates to:
  /// **'Редактирование'**
  String get formSubtitleEdit;

  /// No description provided for @formNameLabel.
  ///
  /// In ru, this message translates to:
  /// **'Название'**
  String get formNameLabel;

  /// No description provided for @formNameHint.
  ///
  /// In ru, this message translates to:
  /// **'Например, Труба ⌀100/2000'**
  String get formNameHint;

  /// No description provided for @formCategoryLabel.
  ///
  /// In ru, this message translates to:
  /// **'Категория'**
  String get formCategoryLabel;

  /// No description provided for @formSubcategoryLabel.
  ///
  /// In ru, this message translates to:
  /// **'Подкатегория'**
  String get formSubcategoryLabel;

  /// No description provided for @formUnitLabel.
  ///
  /// In ru, this message translates to:
  /// **'Единица измерения'**
  String get formUnitLabel;

  /// No description provided for @formNameRequired.
  ///
  /// In ru, this message translates to:
  /// **'Введите название'**
  String get formNameRequired;

  /// No description provided for @formSubcategoryRequired.
  ///
  /// In ru, this message translates to:
  /// **'Выберите подкатегорию'**
  String get formSubcategoryRequired;

  /// No description provided for @sendSheetTitle.
  ///
  /// In ru, this message translates to:
  /// **'Отправить заявку'**
  String get sendSheetTitle;

  /// No description provided for @sendSheetSubtitle.
  ///
  /// In ru, this message translates to:
  /// **'Выберите формат вложения'**
  String get sendSheetSubtitle;

  /// No description provided for @sendFormatXml.
  ///
  /// In ru, this message translates to:
  /// **'XML'**
  String get sendFormatXml;

  /// No description provided for @sendFormatPdf.
  ///
  /// In ru, this message translates to:
  /// **'PDF'**
  String get sendFormatPdf;

  /// No description provided for @sendFormatBoth.
  ///
  /// In ru, this message translates to:
  /// **'XML и PDF'**
  String get sendFormatBoth;

  /// No description provided for @confirmDeleteRequestTitle.
  ///
  /// In ru, this message translates to:
  /// **'Удалить заявку?'**
  String get confirmDeleteRequestTitle;

  /// No description provided for @confirmDeleteRequestText.
  ///
  /// In ru, this message translates to:
  /// **'Заявка «{name}» и все её {count} позиций будут удалены с устройства.'**
  String confirmDeleteRequestText(String name, int count);

  /// No description provided for @confirmDeleteCategoryTitle.
  ///
  /// In ru, this message translates to:
  /// **'Удалить категорию?'**
  String get confirmDeleteCategoryTitle;

  /// No description provided for @confirmDeleteCategoryText.
  ///
  /// In ru, this message translates to:
  /// **'Категория «{name}» удалится вместе со всеми подкатегориями и материалами внутри. Заявки не изменятся.'**
  String confirmDeleteCategoryText(String name);

  /// No description provided for @confirmDeleteSubcategoryTitle.
  ///
  /// In ru, this message translates to:
  /// **'Удалить подкатегорию?'**
  String get confirmDeleteSubcategoryTitle;

  /// No description provided for @confirmDeleteSubcategoryText.
  ///
  /// In ru, this message translates to:
  /// **'Подкатегория «{name}» удалится вместе с материалами внутри. Заявки не изменятся.'**
  String confirmDeleteSubcategoryText(String name);

  /// No description provided for @confirmDeleteMaterialTitle.
  ///
  /// In ru, this message translates to:
  /// **'Удалить материал?'**
  String get confirmDeleteMaterialTitle;

  /// No description provided for @confirmDeleteMaterialText.
  ///
  /// In ru, this message translates to:
  /// **'Материал «{name}» удалится из справочника. В заявках он останется: там хранятся копии.'**
  String confirmDeleteMaterialText(String name);

  /// No description provided for @catalogMaterialsEmptyAll.
  ///
  /// In ru, this message translates to:
  /// **'В справочнике нет материалов.\nЗагрузите прайс или добавьте материал.'**
  String get catalogMaterialsEmptyAll;

  /// No description provided for @confirmDeleteItemTitle.
  ///
  /// In ru, this message translates to:
  /// **'Удалить материал?'**
  String get confirmDeleteItemTitle;

  /// No description provided for @confirmDeleteItemText.
  ///
  /// In ru, this message translates to:
  /// **'Позиция будет удалена из заявки.'**
  String get confirmDeleteItemText;

  /// No description provided for @snackQuantityRequired.
  ///
  /// In ru, this message translates to:
  /// **'Укажите количество'**
  String get snackQuantityRequired;

  /// No description provided for @snackQuantityUpdated.
  ///
  /// In ru, this message translates to:
  /// **'Количество обновлено'**
  String get snackQuantityUpdated;

  /// No description provided for @snackMaterialAdded.
  ///
  /// In ru, this message translates to:
  /// **'{name} · {quantity} {unit} — добавлено'**
  String snackMaterialAdded(String name, int quantity, String unit);

  /// No description provided for @snackMaterialReplaced.
  ///
  /// In ru, this message translates to:
  /// **'Материал заменён на {name}'**
  String snackMaterialReplaced(String name);

  /// No description provided for @snackMaterialRemovedFromRequest.
  ///
  /// In ru, this message translates to:
  /// **'Материал удалён из заявки'**
  String get snackMaterialRemovedFromRequest;

  /// No description provided for @snackSavedToDevice.
  ///
  /// In ru, this message translates to:
  /// **'Сохранено на устройство: XML и PDF'**
  String get snackSavedToDevice;

  /// No description provided for @snackSent.
  ///
  /// In ru, this message translates to:
  /// **'Отправлено · {format}'**
  String snackSent(String format);

  /// No description provided for @snackRequestDeleted.
  ///
  /// In ru, this message translates to:
  /// **'Заявка удалена'**
  String get snackRequestDeleted;

  /// No description provided for @snackFolderCreated.
  ///
  /// In ru, this message translates to:
  /// **'Папка создана'**
  String get snackFolderCreated;

  /// No description provided for @snackCategorySaved.
  ///
  /// In ru, this message translates to:
  /// **'Категория сохранена'**
  String get snackCategorySaved;

  /// No description provided for @snackSubcategorySaved.
  ///
  /// In ru, this message translates to:
  /// **'Подкатегория сохранена'**
  String get snackSubcategorySaved;

  /// No description provided for @snackMaterialSaved.
  ///
  /// In ru, this message translates to:
  /// **'Материал сохранён'**
  String get snackMaterialSaved;

  /// No description provided for @snackCategoryRemoved.
  ///
  /// In ru, this message translates to:
  /// **'Категория удалена'**
  String get snackCategoryRemoved;

  /// No description provided for @snackSubcategoryRemoved.
  ///
  /// In ru, this message translates to:
  /// **'Подкатегория удалена'**
  String get snackSubcategoryRemoved;

  /// No description provided for @snackMaterialRemovedFromCatalog.
  ///
  /// In ru, this message translates to:
  /// **'Материал удалён из справочника'**
  String get snackMaterialRemovedFromCatalog;

  /// No description provided for @routeNotFound.
  ///
  /// In ru, this message translates to:
  /// **'Такого экрана нет.\nВозможно, ссылка устарела.'**
  String get routeNotFound;

  /// No description provided for @routeNotFoundAction.
  ///
  /// In ru, this message translates to:
  /// **'К заявкам'**
  String get routeNotFoundAction;

  /// No description provided for @errorTimeout.
  ///
  /// In ru, this message translates to:
  /// **'Сервер не ответил вовремя. Попробуйте ещё раз.'**
  String get errorTimeout;

  /// No description provided for @errorConnection.
  ///
  /// In ru, this message translates to:
  /// **'Нет связи с сервером. Проверьте подключение.'**
  String get errorConnection;

  /// No description provided for @errorCertificate.
  ///
  /// In ru, this message translates to:
  /// **'Не удалось проверить сертификат сервера.'**
  String get errorCertificate;

  /// No description provided for @errorFormat.
  ///
  /// In ru, this message translates to:
  /// **'Сервер ответил в неожиданном формате.'**
  String get errorFormat;

  /// No description provided for @errorStorage.
  ///
  /// In ru, this message translates to:
  /// **'Не удалось прочитать данные на устройстве.'**
  String get errorStorage;

  /// No description provided for @errorPlatform.
  ///
  /// In ru, this message translates to:
  /// **'Устройство отклонило операцию.'**
  String get errorPlatform;

  /// No description provided for @errorUnknown.
  ///
  /// In ru, this message translates to:
  /// **'Что-то пошло не так. Попробуйте ещё раз.'**
  String get errorUnknown;
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) =>
      <String>['ru'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'ru':
      return AppLocalizationsRu();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.',
  );
}
