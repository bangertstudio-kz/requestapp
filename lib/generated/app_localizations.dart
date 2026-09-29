import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_en.dart';
import 'app_localizations_kk.dart';
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
  static const List<Locale> supportedLocales = <Locale>[
    Locale('en'),
    Locale('kk'),
    Locale('ru'),
    Locale('ru', 'CAT'),
  ];

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

  /// Подпись ручки перетаскивания строки для скринридера
  ///
  /// In ru, this message translates to:
  /// **'Перетащить, чтобы изменить порядок'**
  String get actionReorder;

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

  /// No description provided for @navSettings.
  ///
  /// In ru, this message translates to:
  /// **'Настройки'**
  String get navSettings;

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

  /// Подпись над списком внутри категории: там и вложенные категории, и материалы
  ///
  /// In ru, this message translates to:
  /// **'Внутри · {count}'**
  String catalogInsideLabel(int count);

  /// No description provided for @catalogCategoryMeta.
  ///
  /// In ru, this message translates to:
  /// **'{count} внутри · {names}'**
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

  /// No description provided for @catalogInsideEmpty.
  ///
  /// In ru, this message translates to:
  /// **'Здесь пока пусто.\nДобавьте категорию или материал.'**
  String get catalogInsideEmpty;

  /// No description provided for @catalogMaterialsEmpty.
  ///
  /// In ru, this message translates to:
  /// **'В категории нет материалов.\nНажмите «+ Материал».'**
  String get catalogMaterialsEmpty;

  /// No description provided for @catalogImportTitle.
  ///
  /// In ru, this message translates to:
  /// **'Обновить справочник'**
  String get catalogImportTitle;

  /// No description provided for @catalogImportSubtitle.
  ///
  /// In ru, this message translates to:
  /// **'Импорт материалов из Excel'**
  String get catalogImportSubtitle;

  /// Подпись кнопки-иконки в шапке справочника для скринридера
  ///
  /// In ru, this message translates to:
  /// **'Загрузить материалы'**
  String get catalogImportOpen;

  /// Подпись кнопки-иконки выгрузки справочника или категории для скринридера
  ///
  /// In ru, this message translates to:
  /// **'Выгрузить в Excel'**
  String get catalogExportOpen;

  /// Тема письма при отправке выгрузки всего справочника
  ///
  /// In ru, this message translates to:
  /// **'Справочник материалов'**
  String get catalogExportSubject;

  /// No description provided for @catalogImportHowTitle.
  ///
  /// In ru, this message translates to:
  /// **'Как подготовить файл'**
  String get catalogImportHowTitle;

  /// No description provided for @catalogImportHowStep1.
  ///
  /// In ru, this message translates to:
  /// **'Попросите чат — ChatGPT, Claude и подобные — собрать ваш прайс в файл Excel. Промт ниже.'**
  String get catalogImportHowStep1;

  /// No description provided for @catalogImportHowStep2.
  ///
  /// In ru, this message translates to:
  /// **'Скачайте готовый .xlsx из чата. Если чат не умеет файлы — он выведет таблицу: скопируйте её в пустой лист Excel и сохраните как .xlsx.'**
  String get catalogImportHowStep2;

  /// No description provided for @catalogImportHowStep3.
  ///
  /// In ru, this message translates to:
  /// **'Вернитесь сюда, выберите категорию и файл.'**
  String get catalogImportHowStep3;

  /// No description provided for @catalogImportPromptShow.
  ///
  /// In ru, this message translates to:
  /// **'Показать промт'**
  String get catalogImportPromptShow;

  /// No description provided for @catalogImportPromptHide.
  ///
  /// In ru, this message translates to:
  /// **'Скрыть промт'**
  String get catalogImportPromptHide;

  /// No description provided for @catalogImportPromptCopy.
  ///
  /// In ru, this message translates to:
  /// **'Скопировать промт'**
  String get catalogImportPromptCopy;

  /// No description provided for @catalogImportPromptCopied.
  ///
  /// In ru, this message translates to:
  /// **'Промт скопирован'**
  String get catalogImportPromptCopied;

  /// Готовый промт для чата: просит собрать произвольный прайс в .xlsx нужного формата
  ///
  /// In ru, this message translates to:
  /// **'Собери мой список материалов в файл Excel (.xlsx) и дай его скачать.\n\nВ файле один лист с названием «Материалы» и три колонки; первая строка — заголовок:\n1) Путь   2) Материал   3) Единица\n\nПравила:\n- «Путь» — вложенные категории через « / », например: Труба / Чугунная. Если материал кладётся прямо в выбранную категорию — оставь пусто.\n- «Материал» — название целиком, как в прайсе, вместе с типоразмером.\n- «Единица» — строго одно из: шт., м.п., комплект. Если в исходнике другая единица — выбери ближайшую из этих трёх.\n- Одна строка — один материал. Ничего не придумывай: чего нет в исходнике, оставь пусто.\n- Никаких лишних листов, колонок, итогов и пояснений внутри файла.\n\nЕсли сделать файл не можешь — выведи ту же таблицу текстом, колонки раздели табуляцией: её можно вставить в пустой лист Excel и сохранить как .xlsx.\n\nВот список:\n'**
  String get catalogImportPrompt;

  /// No description provided for @catalogImportTargetLabel.
  ///
  /// In ru, this message translates to:
  /// **'Куда загрузить'**
  String get catalogImportTargetLabel;

  /// No description provided for @catalogImportTargetRoot.
  ///
  /// In ru, this message translates to:
  /// **'В корень справочника'**
  String get catalogImportTargetRoot;

  /// No description provided for @catalogImportTargetHint.
  ///
  /// In ru, this message translates to:
  /// **'Пути из файла считаются от выбранной категории'**
  String get catalogImportTargetHint;

  /// No description provided for @catalogImportRootNote.
  ///
  /// In ru, this message translates to:
  /// **'В корне справочника материал лежать не может: строки с пустым путём будут пропущены.'**
  String get catalogImportRootNote;

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
  /// **'Что изменится'**
  String get catalogImportStatsLabel;

  /// No description provided for @catalogImportAdded.
  ///
  /// In ru, this message translates to:
  /// **'Новых материалов'**
  String get catalogImportAdded;

  /// No description provided for @catalogImportUpdated.
  ///
  /// In ru, this message translates to:
  /// **'Обновится'**
  String get catalogImportUpdated;

  /// No description provided for @catalogImportCategoriesCreated.
  ///
  /// In ru, this message translates to:
  /// **'Новых категорий'**
  String get catalogImportCategoriesCreated;

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
  /// **'{count, plural, one{Пропущена {count} строка: нет названия, неизвестна единица или некуда положить} few{Пропущено {count} строки: нет названия, неизвестна единица или некуда положить} many{Пропущено {count} строк: нет названия, неизвестна единица или некуда положить} other{Пропущено {count} строки: нет названия, неизвестна единица или некуда положить}}'**
  String catalogImportSkipped(int count);

  /// No description provided for @catalogImportUnknownUnits.
  ///
  /// In ru, this message translates to:
  /// **'Неизвестные единицы измерения: {units}. Допустимы только шт., м.п. и комплект — такие строки не загрузятся.'**
  String catalogImportUnknownUnits(String units);

  /// No description provided for @catalogImportReplaceNote.
  ///
  /// In ru, this message translates to:
  /// **'Импорт дополняет справочник: материал с таким же названием в той же ветке обновится, остальные добавятся. Заявки не изменятся — в них лежат копии материалов на момент добавления.'**
  String get catalogImportReplaceNote;

  /// No description provided for @catalogImportApply.
  ///
  /// In ru, this message translates to:
  /// **'Добавить в справочник'**
  String get catalogImportApply;

  /// No description provided for @catalogImportRetry.
  ///
  /// In ru, this message translates to:
  /// **'Повторить'**
  String get catalogImportRetry;

  /// No description provided for @confirmImportTitle.
  ///
  /// In ru, this message translates to:
  /// **'Добавить в справочник?'**
  String get confirmImportTitle;

  /// No description provided for @confirmImportText.
  ///
  /// In ru, this message translates to:
  /// **'В справочник будет записано {count} материалов из файла.'**
  String confirmImportText(int count);

  /// No description provided for @confirmImportAction.
  ///
  /// In ru, this message translates to:
  /// **'Добавить'**
  String get confirmImportAction;

  /// No description provided for @snackCatalogImported.
  ///
  /// In ru, this message translates to:
  /// **'Загружено материалов: {count}'**
  String snackCatalogImported(int count);

  /// No description provided for @catalogNewCategory.
  ///
  /// In ru, this message translates to:
  /// **'Категория'**
  String get catalogNewCategory;

  /// No description provided for @catalogAdd.
  ///
  /// In ru, this message translates to:
  /// **'Добавить'**
  String get catalogAdd;

  /// No description provided for @catalogAddTitle.
  ///
  /// In ru, this message translates to:
  /// **'Что добавить'**
  String get catalogAddTitle;

  /// No description provided for @catalogAddCategory.
  ///
  /// In ru, this message translates to:
  /// **'Категорию'**
  String get catalogAddCategory;

  /// No description provided for @catalogAddItem.
  ///
  /// In ru, this message translates to:
  /// **'Материал'**
  String get catalogAddItem;

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

  /// Разделитель звеньев пути. В строке, а не в коде: длина пути теперь любая, а знак зависит от языка
  ///
  /// In ru, this message translates to:
  /// **' → '**
  String get pathSeparator;

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

  /// No description provided for @formPlacementLabel.
  ///
  /// In ru, this message translates to:
  /// **'Где разместить'**
  String get formPlacementLabel;

  /// No description provided for @formPlacementRoot.
  ///
  /// In ru, this message translates to:
  /// **'На верхнем уровне'**
  String get formPlacementRoot;

  /// No description provided for @formPlacementInside.
  ///
  /// In ru, this message translates to:
  /// **'Внутри другой категории'**
  String get formPlacementInside;

  /// No description provided for @formParentLabel.
  ///
  /// In ru, this message translates to:
  /// **'Внутри'**
  String get formParentLabel;

  /// No description provided for @formParentEmpty.
  ///
  /// In ru, this message translates to:
  /// **'Выберите категорию'**
  String get formParentEmpty;

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

  /// No description provided for @formCategoryRequired.
  ///
  /// In ru, this message translates to:
  /// **'Выберите категорию'**
  String get formCategoryRequired;

  /// No description provided for @folderSheetTitle.
  ///
  /// In ru, this message translates to:
  /// **'Перенести заявку'**
  String get folderSheetTitle;

  /// No description provided for @folderSheetCurrent.
  ///
  /// In ru, this message translates to:
  /// **'Сейчас: {name}'**
  String folderSheetCurrent(String name);

  /// No description provided for @folderSheetHere.
  ///
  /// In ru, this message translates to:
  /// **'здесь'**
  String get folderSheetHere;

  /// No description provided for @folderOutside.
  ///
  /// In ru, this message translates to:
  /// **'Вне папок'**
  String get folderOutside;

  /// No description provided for @folderNew.
  ///
  /// In ru, this message translates to:
  /// **'Новая папка…'**
  String get folderNew;

  /// No description provided for @requestFolderLabel.
  ///
  /// In ru, this message translates to:
  /// **'Папка'**
  String get requestFolderLabel;

  /// No description provided for @previewTitle.
  ///
  /// In ru, this message translates to:
  /// **'Проверьте файлы'**
  String get previewTitle;

  /// No description provided for @previewFileSize.
  ///
  /// In ru, this message translates to:
  /// **'{size} КБ'**
  String previewFileSize(String size);

  /// No description provided for @previewPdfFailed.
  ///
  /// In ru, this message translates to:
  /// **'Не удалось показать страницы PDF'**
  String get previewPdfFailed;

  /// No description provided for @previewSheetFailed.
  ///
  /// In ru, this message translates to:
  /// **'Не удалось прочитать таблицу'**
  String get previewSheetFailed;

  /// No description provided for @itemDeletedFromCatalog.
  ///
  /// In ru, this message translates to:
  /// **'Материал удалён'**
  String get itemDeletedFromCatalog;

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

  /// No description provided for @sendFormatExcel.
  ///
  /// In ru, this message translates to:
  /// **'Excel'**
  String get sendFormatExcel;

  /// No description provided for @sendFormatPdf.
  ///
  /// In ru, this message translates to:
  /// **'PDF'**
  String get sendFormatPdf;

  /// No description provided for @sendFormatBoth.
  ///
  /// In ru, this message translates to:
  /// **'Excel и PDF'**
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

  /// Материал уже был в заявке, и у позиции поменялось количество
  ///
  /// In ru, this message translates to:
  /// **'{name} · теперь {quantity} {unit}'**
  String snackMaterialQuantityUpdated(String name, int quantity, String unit);

  /// No description provided for @duplicateTitle.
  ///
  /// In ru, this message translates to:
  /// **'Материал уже в заявке'**
  String get duplicateTitle;

  /// No description provided for @duplicateText.
  ///
  /// In ru, this message translates to:
  /// **'{name} — сейчас {current} {unit}.'**
  String duplicateText(String name, int current, String unit);

  /// No description provided for @duplicateAdd.
  ///
  /// In ru, this message translates to:
  /// **'Прибавить · будет {total} {unit}'**
  String duplicateAdd(int total, String unit);

  /// No description provided for @duplicateReplace.
  ///
  /// In ru, this message translates to:
  /// **'Заменить на {quantity} {unit}'**
  String duplicateReplace(int quantity, String unit);

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

  /// No description provided for @snackNothingToSend.
  ///
  /// In ru, this message translates to:
  /// **'В заявке нет позиций — отправлять нечего'**
  String get snackNothingToSend;

  /// No description provided for @snackMovedToFolder.
  ///
  /// In ru, this message translates to:
  /// **'Заявка перенесена в «{name}»'**
  String snackMovedToFolder(String name);

  /// No description provided for @snackMovedOutOfFolders.
  ///
  /// In ru, this message translates to:
  /// **'Заявка вынесена из папок'**
  String get snackMovedOutOfFolders;

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

  /// No description provided for @snackMaterialRemovedFromCatalog.
  ///
  /// In ru, this message translates to:
  /// **'Материал удалён из справочника'**
  String get snackMaterialRemovedFromCatalog;

  /// No description provided for @settingsTitle.
  ///
  /// In ru, this message translates to:
  /// **'Настройки'**
  String get settingsTitle;

  /// No description provided for @settingsSubtitle.
  ///
  /// In ru, this message translates to:
  /// **'Параметры приложения'**
  String get settingsSubtitle;

  /// No description provided for @settingsLanguageLabel.
  ///
  /// In ru, this message translates to:
  /// **'Язык'**
  String get settingsLanguageLabel;

  /// Название языка на нём самом — одинаковое во всех переводах, чтобы свой язык находился из любого
  ///
  /// In ru, this message translates to:
  /// **'Русский'**
  String get languageRussian;

  /// Название языка на нём самом — одинаковое во всех переводах
  ///
  /// In ru, this message translates to:
  /// **'English'**
  String get languageEnglish;

  /// Название языка на нём самом — одинаковое во всех переводах
  ///
  /// In ru, this message translates to:
  /// **'Қазақша'**
  String get languageKazakh;

  /// Шуточный язык. Название одинаковое во всех переводах: из кошачьего нужно суметь вернуться
  ///
  /// In ru, this message translates to:
  /// **'Кошачий 🐱'**
  String get languageCat;

  /// No description provided for @settingsThemeLabel.
  ///
  /// In ru, this message translates to:
  /// **'Тема'**
  String get settingsThemeLabel;

  /// No description provided for @themeSystem.
  ///
  /// In ru, this message translates to:
  /// **'Как в системе'**
  String get themeSystem;

  /// No description provided for @themeLight.
  ///
  /// In ru, this message translates to:
  /// **'Светлая'**
  String get themeLight;

  /// No description provided for @themeDark.
  ///
  /// In ru, this message translates to:
  /// **'Тёмная'**
  String get themeDark;

  /// No description provided for @settingsPrivacyPolicy.
  ///
  /// In ru, this message translates to:
  /// **'Политика конфиденциальности'**
  String get settingsPrivacyPolicy;

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
      <String>['en', 'kk', 'ru'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when language+country codes are specified.
  switch (locale.languageCode) {
    case 'ru':
      {
        switch (locale.countryCode) {
          case 'CAT':
            return AppLocalizationsRuCat();
        }
        break;
      }
  }

  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'en':
      return AppLocalizationsEn();
    case 'kk':
      return AppLocalizationsKk();
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
