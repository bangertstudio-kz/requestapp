// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get appTitle => 'Material requests';

  @override
  String get actionBack => 'Back';

  @override
  String get actionClose => 'Close';

  @override
  String get actionClearSearch => 'Clear search';

  @override
  String get actionSave => 'Save';

  @override
  String get actionCancel => 'Cancel';

  @override
  String get actionDelete => 'Delete';

  @override
  String get actionSend => 'Send';

  @override
  String get actionEditShort => 'Edit';

  @override
  String get actionRemove => 'Delete entry';

  @override
  String get actionReorder => 'Drag to change the order';

  @override
  String get actionRetry => 'Retry';

  @override
  String get actionBackspace => 'Erase';

  @override
  String get navRequests => 'Requests';

  @override
  String get navCatalog => 'Catalog';

  @override
  String get navSettings => 'Settings';

  @override
  String get statusDraft => 'Draft';

  @override
  String get statusSaved => 'Saved';

  @override
  String get statusSent => 'Sent';

  @override
  String get unitPiece => 'pcs';

  @override
  String get unitMeter => 'lin. m';

  @override
  String get unitSet => 'set';

  @override
  String get requestsTitle => 'Requests';

  @override
  String requestsSubtitle(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count requests',
      one: '$count request',
    );
    return '$_temp0';
  }

  @override
  String get requestsSearchHint => 'Search requests';

  @override
  String get requestsFilterAll => 'All';

  @override
  String get requestsFilterDrafts => 'Drafts';

  @override
  String get requestsFilterSaved => 'Saved';

  @override
  String get requestsFilterSent => 'Sent';

  @override
  String get requestsFoldersLabel => 'Folders';

  @override
  String get requestsFolderNew => 'Folder';

  @override
  String requestsListAll(int count) {
    return 'All requests · $count';
  }

  @override
  String requestsListInFolder(int count) {
    return 'Requests in folder · $count';
  }

  @override
  String get requestsEmpty =>
      'Nothing found.\nChange the search or the filter.';

  @override
  String get requestsCreate => 'Create request';

  @override
  String requestPositions(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count items',
      one: '$count item',
    );
    return '$_temp0';
  }

  @override
  String requestPositionsWord(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'items',
      one: 'item',
    );
    return '$_temp0';
  }

  @override
  String get dateFormatShort => 'MM/dd/yyyy';

  @override
  String requestFolderCount(int count) {
    return '$count';
  }

  @override
  String get requestDetailTitle => 'Request';

  @override
  String get requestNameLabel => 'Request name';

  @override
  String requestMaterialsLabel(int count) {
    return 'Materials · $count';
  }

  @override
  String get requestItemsEmpty =>
      'No materials in the request yet.\nTap “Add material”.';

  @override
  String get requestAddMaterial => 'Add material';

  @override
  String get requestIncreaseQuantity => 'Increase quantity';

  @override
  String get requestDecreaseQuantity => 'Decrease quantity';

  @override
  String get requestItemTitle => 'Request item';

  @override
  String get requestItemReplaceMaterial => 'Replace material';

  @override
  String get pickTitle => 'Add material';

  @override
  String get pickSubtitle => 'Category, material and quantity';

  @override
  String get pickSearchHint => 'Search materials';

  @override
  String get pickHintTree => 'Category → subcategory → material';

  @override
  String pickHintFound(int count) {
    return 'Found · $count';
  }

  @override
  String get pickAddToRequest => 'Add to request';

  @override
  String get pickCollapseMark => '−';

  @override
  String get pickSearching => 'Searching…';

  @override
  String get pickNothingFound =>
      'Nothing found.\nCheck the search or open the tree.';

  @override
  String get pickScrollTop => 'To top';

  @override
  String pickCategoryMeta(int subcategories, int materials) {
    return '$subcategories subcat. · $materials mat.';
  }

  @override
  String pickSubcategoriesShort(int count) {
    return '$count subcat.';
  }

  @override
  String pickMaterialsShort(int count) {
    return '$count mat.';
  }

  @override
  String get quantityLabel => 'Quantity';

  @override
  String get quantityHint => 'Unit from the catalog';

  @override
  String get quantityEmpty => '0';

  @override
  String get catalogTitle => 'Catalog';

  @override
  String get catalogSubtitle => 'Categories, subcategories and materials';

  @override
  String get catalogTabCategories => 'Categories';

  @override
  String get catalogTabMaterials => 'Materials';

  @override
  String catalogCategoriesLabel(int count) {
    return 'Categories · $count';
  }

  @override
  String catalogMaterialsLabel(int count) {
    return 'Materials · $count';
  }

  @override
  String catalogInsideLabel(int count) {
    return 'Inside · $count';
  }

  @override
  String catalogCategoryMeta(int count, String names) {
    return '$count inside · $names';
  }

  @override
  String catalogMaterialsInCategory(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count materials in the category',
      one: '$count material in the category',
    );
    return '$_temp0';
  }

  @override
  String catalogMaterialsCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count materials',
      one: '$count material',
    );
    return '$_temp0';
  }

  @override
  String get catalogCategoriesEmpty =>
      'The catalog has no categories.\nImport a price list or add a category.';

  @override
  String get catalogInsideEmpty =>
      'Nothing here yet.\nAdd a category or a material.';

  @override
  String get catalogMaterialsEmpty =>
      'The category has no materials.\nTap “+ Material”.';

  @override
  String get catalogImportTitle => 'Update catalog';

  @override
  String get catalogImportSubtitle => 'Import materials from Excel';

  @override
  String get catalogImportOpen => 'Import materials';

  @override
  String get catalogExportOpen => 'Export to Excel';

  @override
  String get catalogExportSubject => 'Materials catalog';

  @override
  String get catalogImportHowTitle => 'How to prepare the file';

  @override
  String get catalogImportHowStep1 =>
      'Ask a chat assistant — ChatGPT, Claude or similar — to put your price list into an Excel file. The prompt is below.';

  @override
  String get catalogImportHowStep2 =>
      'Download the finished .xlsx from the chat. If the chat can\'t make files, it will print a table: copy it into an empty Excel sheet and save it as .xlsx.';

  @override
  String get catalogImportHowStep3 =>
      'Come back here, choose a category and the file.';

  @override
  String get catalogImportPromptShow => 'Show prompt';

  @override
  String get catalogImportPromptHide => 'Hide prompt';

  @override
  String get catalogImportPromptCopy => 'Copy prompt';

  @override
  String get catalogImportPromptCopied => 'Prompt copied';

  @override
  String get catalogImportPrompt =>
      'Put my list of materials into an Excel file (.xlsx) and let me download it.\n\nThe file has one sheet named «Материалы» and three columns; the first row is the header:\n1) Путь   2) Материал   3) Единица\n\nRules:\n- «Путь» (path) — nested categories separated by « / », for example: Труба / Чугунная. If the material goes straight into the chosen category, leave it empty.\n- «Материал» (material) — the full name as in the price list, including the size.\n- «Единица» (unit) — strictly one of: шт., м.п., комплект. If the source has another unit, pick the closest of these three.\n- One row — one material. Don\'t invent anything: whatever is missing in the source, leave empty.\n- No extra sheets, columns, totals or notes inside the file.\n\nIf you can\'t make a file, print the same table as text with tab-separated columns: it can be pasted into an empty Excel sheet and saved as .xlsx.\n\nHere is the list:\n';

  @override
  String get catalogImportTargetLabel => 'Import into';

  @override
  String get catalogImportTargetRoot => 'Catalog root';

  @override
  String get catalogImportTargetHint =>
      'Paths from the file start at the chosen category';

  @override
  String get catalogImportRootNote =>
      'A material can\'t sit in the catalog root: rows with an empty path will be skipped.';

  @override
  String get catalogImportPickFile => 'Choose file';

  @override
  String get catalogImportPickAnother => 'Choose another file';

  @override
  String get catalogImportParsing => 'Reading the file…';

  @override
  String get catalogImportFileLabel => 'File';

  @override
  String get catalogImportStatsLabel => 'What will change';

  @override
  String get catalogImportAdded => 'New materials';

  @override
  String get catalogImportUpdated => 'Will be updated';

  @override
  String get catalogImportCategoriesCreated => 'New categories';

  @override
  String get catalogImportWarningsLabel => 'Warnings';

  @override
  String catalogImportDuplicates(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Removed $count exact duplicate rows',
      one: 'Removed $count exact duplicate row',
    );
    return '$_temp0';
  }

  @override
  String catalogImportTrimmed(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Extra spaces removed in $count rows',
      one: 'Extra spaces removed in $count row',
    );
    return '$_temp0';
  }

  @override
  String catalogImportSkipped(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Skipped $count rows: no name, unknown unit or nowhere to put it',
      one: 'Skipped $count row: no name, unknown unit or nowhere to put it',
    );
    return '$_temp0';
  }

  @override
  String catalogImportUnknownUnits(String units) {
    return 'Unknown units: $units. Only шт., м.п. and комплект are allowed — such rows won\'t be imported.';
  }

  @override
  String get catalogImportReplaceNote =>
      'Import adds to the catalog: a material with the same name in the same branch is updated, the rest are added. Requests won\'t change — they keep copies of materials as of when they were added.';

  @override
  String get catalogImportApply => 'Add to catalog';

  @override
  String get catalogImportRetry => 'Retry';

  @override
  String get confirmImportTitle => 'Add to catalog?';

  @override
  String confirmImportText(int count) {
    return '$count materials from the file will be written to the catalog.';
  }

  @override
  String get confirmImportAction => 'Add';

  @override
  String snackCatalogImported(int count) {
    return 'Materials imported: $count';
  }

  @override
  String get catalogNewCategory => 'Category';

  @override
  String get catalogAdd => 'Add';

  @override
  String get catalogAddTitle => 'What to add';

  @override
  String get catalogAddCategory => 'Category';

  @override
  String get catalogAddItem => 'Material';

  @override
  String get catalogNewMaterial => 'Material';

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
  String get formTitleCategory => 'Category';

  @override
  String get formTitleMaterial => 'Material';

  @override
  String get formTitleFolder => 'Folder';

  @override
  String get formPlacementLabel => 'Where to place';

  @override
  String get formPlacementRoot => 'At the top level';

  @override
  String get formPlacementInside => 'Inside another category';

  @override
  String get formParentLabel => 'Inside';

  @override
  String get formParentEmpty => 'Choose a category';

  @override
  String get formSubtitleNew => 'New entry';

  @override
  String get formSubtitleEdit => 'Editing';

  @override
  String get formNameLabel => 'Name';

  @override
  String get formNameHint => 'For example, Pipe ⌀100/2000';

  @override
  String get formCategoryLabel => 'Category';

  @override
  String get formUnitLabel => 'Unit';

  @override
  String get formNameRequired => 'Enter a name';

  @override
  String get formCategoryRequired => 'Choose a category';

  @override
  String get folderSheetTitle => 'Move request';

  @override
  String folderSheetCurrent(String name) {
    return 'Now: $name';
  }

  @override
  String get folderSheetHere => 'here';

  @override
  String get folderOutside => 'No folder';

  @override
  String get folderNew => 'New folder…';

  @override
  String get requestFolderLabel => 'Folder';

  @override
  String get previewTitle => 'Check the files';

  @override
  String previewFileSize(String size) {
    return '$size KB';
  }

  @override
  String get previewPdfFailed => 'Couldn\'t show the PDF pages';

  @override
  String get previewSheetFailed => 'Couldn\'t read the spreadsheet';

  @override
  String get itemDeletedFromCatalog => 'Material deleted';

  @override
  String get sendSheetTitle => 'Send request';

  @override
  String get sendSheetSubtitle => 'Choose the attachment format';

  @override
  String get sendFormatExcel => 'Excel';

  @override
  String get sendFormatPdf => 'PDF';

  @override
  String get sendFormatBoth => 'Excel and PDF';

  @override
  String get confirmDeleteRequestTitle => 'Delete request?';

  @override
  String confirmDeleteRequestText(String name, int count) {
    return 'The request “$name” and all its $count items will be deleted from the device.';
  }

  @override
  String get confirmDeleteCategoryTitle => 'Delete category?';

  @override
  String confirmDeleteCategoryText(String name) {
    return 'The category “$name” will be deleted with all subcategories and materials inside. Requests won\'t change.';
  }

  @override
  String get confirmDeleteMaterialTitle => 'Delete material?';

  @override
  String confirmDeleteMaterialText(String name) {
    return 'The material “$name” will be deleted from the catalog. It stays in requests: they keep copies.';
  }

  @override
  String get catalogMaterialsEmptyAll =>
      'The catalog has no materials.\nImport a price list or add a material.';

  @override
  String get confirmDeleteItemTitle => 'Delete material?';

  @override
  String get confirmDeleteItemText =>
      'The item will be removed from the request.';

  @override
  String get snackQuantityRequired => 'Enter the quantity';

  @override
  String get snackQuantityUpdated => 'Quantity updated';

  @override
  String snackMaterialAdded(String name, int quantity, String unit) {
    return '$name · $quantity $unit — added';
  }

  @override
  String snackMaterialReplaced(String name) {
    return 'Material replaced with $name';
  }

  @override
  String snackMaterialQuantityUpdated(String name, int quantity, String unit) {
    return '$name · now $quantity $unit';
  }

  @override
  String get duplicateTitle => 'Material is already in the request';

  @override
  String duplicateText(String name, int current, String unit) {
    return '$name — now $current $unit.';
  }

  @override
  String duplicateAdd(int total, String unit) {
    return 'Add · will be $total $unit';
  }

  @override
  String duplicateReplace(int quantity, String unit) {
    return 'Replace with $quantity $unit';
  }

  @override
  String get snackMaterialRemovedFromRequest =>
      'Material removed from the request';

  @override
  String get snackSavedToDevice => 'Saved to the device: XML and PDF';

  @override
  String snackSent(String format) {
    return 'Sent · $format';
  }

  @override
  String get snackRequestDeleted => 'Request deleted';

  @override
  String get snackNothingToSend => 'The request has no items — nothing to send';

  @override
  String snackMovedToFolder(String name) {
    return 'Request moved to “$name”';
  }

  @override
  String get snackMovedOutOfFolders => 'Request moved out of folders';

  @override
  String get snackFolderCreated => 'Folder created';

  @override
  String get snackCategorySaved => 'Category saved';

  @override
  String get snackMaterialSaved => 'Material saved';

  @override
  String get snackCategoryRemoved => 'Category deleted';

  @override
  String get snackMaterialRemovedFromCatalog =>
      'Material deleted from the catalog';

  @override
  String get settingsTitle => 'Settings';

  @override
  String get settingsSubtitle => 'App preferences';

  @override
  String get settingsLanguageLabel => 'Language';

  @override
  String get languageRussian => 'Русский';

  @override
  String get languageEnglish => 'English';

  @override
  String get languageKazakh => 'Қазақша';

  @override
  String get languageCat => 'Кошачий 🐱';

  @override
  String get routeNotFound =>
      'There\'s no such screen.\nThe link may be outdated.';

  @override
  String get routeNotFoundAction => 'To requests';

  @override
  String get errorTimeout => 'The server didn\'t respond in time. Try again.';

  @override
  String get errorConnection =>
      'No connection to the server. Check your network.';

  @override
  String get errorCertificate => 'Couldn\'t verify the server certificate.';

  @override
  String get errorFormat => 'The server replied in an unexpected format.';

  @override
  String get errorStorage => 'Couldn\'t read data on the device.';

  @override
  String get errorPlatform => 'The device rejected the operation.';

  @override
  String get errorUnknown => 'Something went wrong. Try again.';
}
