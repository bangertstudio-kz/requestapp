// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Kazakh (`kk`).
class AppLocalizationsKk extends AppLocalizations {
  AppLocalizationsKk([String locale = 'kk']) : super(locale);

  @override
  String get appTitle => 'Материалдарға өтінімдер';

  @override
  String get actionBack => 'Артқа';

  @override
  String get actionClose => 'Жабу';

  @override
  String get actionClearSearch => 'Іздеуді тазарту';

  @override
  String get actionSave => 'Сақтау';

  @override
  String get actionCancel => 'Бас тарту';

  @override
  String get actionDelete => 'Жою';

  @override
  String get actionSend => 'Жіберу';

  @override
  String get actionEditShort => 'Өзг.';

  @override
  String get actionRemove => 'Жазбаны жою';

  @override
  String get actionReorder => 'Ретін өзгерту үшін сүйреңіз';

  @override
  String get actionRetry => 'Қайталау';

  @override
  String get actionBackspace => 'Өшіру';

  @override
  String get navRequests => 'Өтінімдер';

  @override
  String get navCatalog => 'Анықтамалық';

  @override
  String get navSettings => 'Баптаулар';

  @override
  String get statusDraft => 'Жоба';

  @override
  String get statusSaved => 'Сақталды';

  @override
  String get statusSent => 'Жіберілді';

  @override
  String get unitPiece => 'дана';

  @override
  String get unitMeter => 'қ.м.';

  @override
  String get unitSet => 'жинақ';

  @override
  String get requestsTitle => 'Өтінімдер';

  @override
  String requestsSubtitle(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count өтінім',
      one: '$count өтінім',
    );
    return '$_temp0';
  }

  @override
  String get requestsSearchHint => 'Өтінімдерден іздеу';

  @override
  String get requestsFilterAll => 'Барлығы';

  @override
  String get requestsFilterDrafts => 'Жобалар';

  @override
  String get requestsFilterSaved => 'Сақталғандар';

  @override
  String get requestsFilterSent => 'Жіберілгендер';

  @override
  String get requestsFoldersLabel => 'Қалталар';

  @override
  String get requestsFolderNew => 'Қалта';

  @override
  String requestsListAll(int count) {
    return 'Барлық өтінімдер · $count';
  }

  @override
  String requestsListInFolder(int count) {
    return 'Қалтадағы өтінімдер · $count';
  }

  @override
  String get requestsEmpty =>
      'Ештеңе табылмады.\nСұрауды немесе сүзгіні өзгертіңіз.';

  @override
  String get requestsCreate => 'Өтінім жасау';

  @override
  String requestPositions(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count позиция',
      one: '$count позиция',
    );
    return '$_temp0';
  }

  @override
  String requestPositionsWord(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'позиция',
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
  String get requestDetailTitle => 'Өтінім';

  @override
  String get requestNameLabel => 'Өтінім атауы';

  @override
  String requestMaterialsLabel(int count) {
    return 'Материалдар · $count';
  }

  @override
  String get requestItemsEmpty =>
      'Өтінімде әзірге материал жоқ.\n«Материал қосу» түймесін басыңыз.';

  @override
  String get requestAddMaterial => 'Материал қосу';

  @override
  String get requestIncreaseQuantity => 'Санын арттыру';

  @override
  String get requestDecreaseQuantity => 'Санын азайту';

  @override
  String get requestItemTitle => 'Өтінім позициясы';

  @override
  String get requestItemReplaceMaterial => 'Материалды ауыстыру';

  @override
  String get pickTitle => 'Материал қосу';

  @override
  String get pickSubtitle => 'Санат, материал және саны';

  @override
  String get pickSearchHint => 'Материалдардан іздеу';

  @override
  String get pickHintTree => 'Санат → ішкі санат → материал';

  @override
  String pickHintFound(int count) {
    return 'Табылды · $count';
  }

  @override
  String get pickAddToRequest => 'Өтінімге қосу';

  @override
  String get pickCollapseMark => '−';

  @override
  String get pickSearching => 'Іздеп жатырмыз…';

  @override
  String get pickNothingFound =>
      'Ештеңе табылмады.\nСұрауды тексеріңіз немесе ағашты ашыңыз.';

  @override
  String get pickScrollTop => 'Жоғарыға';

  @override
  String pickCategoryMeta(int subcategories, int materials) {
    return '$subcategories ішкі сан. · $materials мат.';
  }

  @override
  String pickSubcategoriesShort(int count) {
    return '$count ішкі сан.';
  }

  @override
  String pickMaterialsShort(int count) {
    return '$count мат.';
  }

  @override
  String get quantityLabel => 'Саны';

  @override
  String get quantityHint => 'Өлшем бірлігі анықтамалықтан';

  @override
  String get quantityEmpty => '0';

  @override
  String get catalogTitle => 'Анықтамалық';

  @override
  String get catalogSubtitle => 'Санаттар, ішкі санаттар және материалдар';

  @override
  String get catalogTabCategories => 'Санаттар';

  @override
  String get catalogTabMaterials => 'Материалдар';

  @override
  String catalogCategoriesLabel(int count) {
    return 'Санаттар · $count';
  }

  @override
  String catalogMaterialsLabel(int count) {
    return 'Материалдар · $count';
  }

  @override
  String catalogInsideLabel(int count) {
    return 'Ішінде · $count';
  }

  @override
  String catalogCategoryMeta(int count, String names) {
    return 'Ішінде $count · $names';
  }

  @override
  String catalogMaterialsInCategory(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Санатта $count материал',
      one: 'Санатта $count материал',
    );
    return '$_temp0';
  }

  @override
  String catalogMaterialsCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count материал',
      one: '$count материал',
    );
    return '$_temp0';
  }

  @override
  String get catalogCategoriesEmpty =>
      'Анықтамалықта санат жоқ.\nБағалар тізімін жүктеңіз немесе санат қосыңыз.';

  @override
  String get catalogInsideEmpty =>
      'Мұнда әзірге бос.\nСанат немесе материал қосыңыз.';

  @override
  String get catalogMaterialsEmpty =>
      'Санатта материал жоқ.\n«+ Материал» түймесін басыңыз.';

  @override
  String get catalogImportTitle => 'Анықтамалықты жаңарту';

  @override
  String get catalogImportSubtitle => 'Материалдарды Excel-ден импорттау';

  @override
  String get catalogImportOpen => 'Материалдарды жүктеу';

  @override
  String get catalogExportOpen => 'Excel-ге түсіру';

  @override
  String get catalogExportSubject => 'Материалдар анықтамалығы';

  @override
  String get catalogImportHowTitle => 'Файлды қалай дайындау керек';

  @override
  String get catalogImportHowStep1 =>
      'Чаттан — ChatGPT, Claude және т.б. — бағалар тізіміңізді Excel файлына жинауды сұраңыз. Промпт төменде.';

  @override
  String get catalogImportHowStep2 =>
      'Дайын .xlsx файлын чаттан жүктеп алыңыз. Чат файл жасай алмаса, кесте шығарады: оны бос Excel парағына көшіріп, .xlsx ретінде сақтаңыз.';

  @override
  String get catalogImportHowStep3 =>
      'Осында оралып, санат пен файлды таңдаңыз.';

  @override
  String get catalogImportPromptShow => 'Промптты көрсету';

  @override
  String get catalogImportPromptHide => 'Промптты жасыру';

  @override
  String get catalogImportPromptCopy => 'Промптты көшіру';

  @override
  String get catalogImportPromptCopied => 'Промпт көшірілді';

  @override
  String get catalogImportPrompt =>
      'Материалдар тізімімді Excel файлына (.xlsx) жинап, жүктеп алуға бер.\n\nФайлда «Материалы» деп аталатын бір парақ және үш баған болсын; бірінші жол — тақырып:\n1) Путь   2) Материал   3) Единица\n\nЕрежелер:\n- «Путь» (жол) — ішкі санаттар « / » арқылы, мысалы: Труба / Чугунная. Материал таңдалған санаттың өзіне салынса — бос қалдыр.\n- «Материал» — бағалар тізіміндегідей толық атауы, типөлшемімен бірге.\n- «Единица» (өлшем бірлігі) — тек мыналардың бірі: шт., м.п., комплект. Бастапқы тізімде басқа бірлік болса — осы үшеуінің ең жақынын таңда.\n- Бір жол — бір материал. Ештеңе ойдан шығарма: бастапқы тізімде жоқты бос қалдыр.\n- Файл ішінде артық парақ, баған, жиынтық немесе түсініктеме болмасын.\n\nФайл жасай алмасаң — сол кестені мәтінмен шығар, бағандарды табуляциямен бөл: оны бос Excel парағына қойып, .xlsx ретінде сақтауға болады.\n\nМіне, тізім:\n';

  @override
  String get catalogImportTargetLabel => 'Қайда жүктеу';

  @override
  String get catalogImportTargetRoot => 'Анықтамалықтың түбіріне';

  @override
  String get catalogImportTargetHint =>
      'Файлдағы жолдар таңдалған санаттан бастап саналады';

  @override
  String get catalogImportRootNote =>
      'Анықтамалықтың түбірінде материал жата алмайды: жолы бос жолдар өткізіліп жіберіледі.';

  @override
  String get catalogImportPickFile => 'Файлды таңдау';

  @override
  String get catalogImportPickAnother => 'Басқа файлды таңдау';

  @override
  String get catalogImportParsing => 'Файлды талдап жатырмыз…';

  @override
  String get catalogImportFileLabel => 'Файл';

  @override
  String get catalogImportStatsLabel => 'Не өзгереді';

  @override
  String get catalogImportAdded => 'Жаңа материалдар';

  @override
  String get catalogImportUpdated => 'Жаңартылады';

  @override
  String get catalogImportCategoriesCreated => 'Жаңа санаттар';

  @override
  String get catalogImportWarningsLabel => 'Ескертулер';

  @override
  String catalogImportDuplicates(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Жолдардың $count толық қайталанымы жойылды',
      one: 'Жолдың $count толық қайталанымы жойылды',
    );
    return '$_temp0';
  }

  @override
  String catalogImportTrimmed(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count жолдағы артық бос орындар алынды',
      one: '$count жолдағы артық бос орындар алынды',
    );
    return '$_temp0';
  }

  @override
  String catalogImportSkipped(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other:
          '$count жол өткізілді: атауы жоқ, өлшем бірлігі белгісіз немесе салатын жер жоқ',
      one:
          '$count жол өткізілді: атауы жоқ, өлшем бірлігі белгісіз немесе салатын жер жоқ',
    );
    return '$_temp0';
  }

  @override
  String catalogImportUnknownUnits(String units) {
    return 'Белгісіз өлшем бірліктері: $units. Тек шт., м.п. және комплект рұқсат етіледі — мұндай жолдар жүктелмейді.';
  }

  @override
  String get catalogImportReplaceNote =>
      'Импорт анықтамалықты толықтырады: сол тармақтағы атауы бірдей материал жаңартылады, қалғандары қосылады. Өтінімдер өзгермейді — оларда қосылған кездегі материалдардың көшірмелері сақталады.';

  @override
  String get catalogImportApply => 'Анықтамалыққа қосу';

  @override
  String get catalogImportRetry => 'Қайталау';

  @override
  String get confirmImportTitle => 'Анықтамалыққа қосу керек пе?';

  @override
  String confirmImportText(int count) {
    return 'Анықтамалыққа файлдан $count материал жазылады.';
  }

  @override
  String get confirmImportAction => 'Қосу';

  @override
  String snackCatalogImported(int count) {
    return 'Жүктелген материалдар: $count';
  }

  @override
  String get catalogNewCategory => 'Санат';

  @override
  String get catalogAdd => 'Қосу';

  @override
  String get catalogAddTitle => 'Не қосу керек';

  @override
  String get catalogAddCategory => 'Санат';

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
  String get formTitleCategory => 'Санат';

  @override
  String get formTitleMaterial => 'Материал';

  @override
  String get formTitleFolder => 'Қалта';

  @override
  String get formPlacementLabel => 'Қайда орналастыру';

  @override
  String get formPlacementRoot => 'Жоғарғы деңгейде';

  @override
  String get formPlacementInside => 'Басқа санаттың ішінде';

  @override
  String get formParentLabel => 'Ішінде';

  @override
  String get formParentEmpty => 'Санатты таңдаңыз';

  @override
  String get formSubtitleNew => 'Жаңа жазба';

  @override
  String get formSubtitleEdit => 'Өңдеу';

  @override
  String get formNameLabel => 'Атауы';

  @override
  String get formNameHint => 'Мысалы, Құбыр ⌀100/2000';

  @override
  String get formCategoryLabel => 'Санат';

  @override
  String get formUnitLabel => 'Өлшем бірлігі';

  @override
  String get formNameRequired => 'Атауын енгізіңіз';

  @override
  String get formCategoryRequired => 'Санатты таңдаңыз';

  @override
  String get folderSheetTitle => 'Өтінімді ауыстыру';

  @override
  String folderSheetCurrent(String name) {
    return 'Қазір: $name';
  }

  @override
  String get folderSheetHere => 'осында';

  @override
  String get folderOutside => 'Қалтадан тыс';

  @override
  String get folderNew => 'Жаңа қалта…';

  @override
  String get requestFolderLabel => 'Қалта';

  @override
  String get previewTitle => 'Файлдарды тексеріңіз';

  @override
  String previewFileSize(String size) {
    return '$size КБ';
  }

  @override
  String get previewPdfFailed => 'PDF беттерін көрсету мүмкін болмады';

  @override
  String get previewSheetFailed => 'Кестені оқу мүмкін болмады';

  @override
  String get itemDeletedFromCatalog => 'Материал жойылған';

  @override
  String get sendSheetTitle => 'Өтінімді жіберу';

  @override
  String get sendSheetSubtitle => 'Тіркеме пішімін таңдаңыз';

  @override
  String get sendFormatExcel => 'Excel';

  @override
  String get sendFormatPdf => 'PDF';

  @override
  String get sendFormatBoth => 'Excel және PDF';

  @override
  String get confirmDeleteRequestTitle => 'Өтінімді жою керек пе?';

  @override
  String confirmDeleteRequestText(String name, int count) {
    return '«$name» өтінімі және оның барлық $count позициясы құрылғыдан жойылады.';
  }

  @override
  String get confirmDeleteCategoryTitle => 'Санатты жою керек пе?';

  @override
  String confirmDeleteCategoryText(String name) {
    return '«$name» санаты ішіндегі барлық ішкі санаттармен және материалдармен бірге жойылады. Өтінімдер өзгермейді.';
  }

  @override
  String get confirmDeleteMaterialTitle => 'Материалды жою керек пе?';

  @override
  String confirmDeleteMaterialText(String name) {
    return '«$name» материалы анықтамалықтан жойылады. Өтінімдерде ол қалады: онда көшірмелер сақталады.';
  }

  @override
  String get catalogMaterialsEmptyAll =>
      'Анықтамалықта материал жоқ.\nБағалар тізімін жүктеңіз немесе материал қосыңыз.';

  @override
  String get confirmDeleteItemTitle => 'Материалды жою керек пе?';

  @override
  String get confirmDeleteItemText => 'Позиция өтінімнен жойылады.';

  @override
  String get snackQuantityRequired => 'Санын көрсетіңіз';

  @override
  String get snackQuantityUpdated => 'Саны жаңартылды';

  @override
  String snackMaterialAdded(String name, int quantity, String unit) {
    return '$name · $quantity $unit — қосылды';
  }

  @override
  String snackMaterialReplaced(String name) {
    return 'Материал $name материалына ауыстырылды';
  }

  @override
  String snackMaterialQuantityUpdated(String name, int quantity, String unit) {
    return '$name · енді $quantity $unit';
  }

  @override
  String get duplicateTitle => 'Материал өтінімде бар';

  @override
  String duplicateText(String name, int current, String unit) {
    return '$name — қазір $current $unit.';
  }

  @override
  String duplicateAdd(int total, String unit) {
    return 'Қосу · $total $unit болады';
  }

  @override
  String duplicateReplace(int quantity, String unit) {
    return '$quantity $unit етіп ауыстыру';
  }

  @override
  String get snackMaterialRemovedFromRequest => 'Материал өтінімнен жойылды';

  @override
  String get snackSavedToDevice => 'Құрылғыға сақталды: XML және PDF';

  @override
  String snackSent(String format) {
    return 'Жіберілді · $format';
  }

  @override
  String get snackRequestDeleted => 'Өтінім жойылды';

  @override
  String get snackNothingToSend =>
      'Өтінімде позиция жоқ — жіберетін ештеңе жоқ';

  @override
  String snackMovedToFolder(String name) {
    return 'Өтінім «$name» қалтасына ауыстырылды';
  }

  @override
  String get snackMovedOutOfFolders => 'Өтінім қалтадан шығарылды';

  @override
  String get snackFolderCreated => 'Қалта жасалды';

  @override
  String get snackCategorySaved => 'Санат сақталды';

  @override
  String get snackMaterialSaved => 'Материал сақталды';

  @override
  String get snackCategoryRemoved => 'Санат жойылды';

  @override
  String get snackMaterialRemovedFromCatalog =>
      'Материал анықтамалықтан жойылды';

  @override
  String get settingsTitle => 'Баптаулар';

  @override
  String get settingsSubtitle => 'Қолданба параметрлері';

  @override
  String get settingsLanguageLabel => 'Тіл';

  @override
  String get languageRussian => 'Русский';

  @override
  String get languageEnglish => 'English';

  @override
  String get languageKazakh => 'Қазақша';

  @override
  String get languageCat => 'Кошачий 🐱';

  @override
  String get settingsThemeLabel => 'Тақырып';

  @override
  String get themeSystem => 'Жүйедегідей';

  @override
  String get themeLight => 'Ашық';

  @override
  String get themeDark => 'Қараңғы';

  @override
  String get settingsPrivacyPolicy => 'Құпиялық саясаты';

  @override
  String get routeNotFound =>
      'Мұндай экран жоқ.\nСілтеме ескірген болуы мүмкін.';

  @override
  String get routeNotFoundAction => 'Өтінімдерге';

  @override
  String get errorTimeout =>
      'Сервер уақытында жауап бермеді. Қайталап көріңіз.';

  @override
  String get errorConnection => 'Сервермен байланыс жоқ. Қосылымды тексеріңіз.';

  @override
  String get errorCertificate => 'Сервер сертификатын тексеру мүмкін болмады.';

  @override
  String get errorFormat => 'Сервер күтпеген пішімде жауап берді.';

  @override
  String get errorStorage => 'Құрылғыдағы деректерді оқу мүмкін болмады.';

  @override
  String get errorPlatform => 'Құрылғы операциядан бас тартты.';

  @override
  String get errorUnknown => 'Бірдеңе дұрыс болмады. Қайталап көріңіз.';
}
