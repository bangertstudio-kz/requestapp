import '../../../../core/domain/entities/params.dart';
import 'catalog_import.dart';
import 'item_draft.dart';

/// Создание, переименование или переезд категории. `id == null` — создание.
///
/// Один класс на все уровни: «завести подкатегорию» — это та же операция
/// с непустым [parentId], и второй набор параметров под неё только повторял
/// бы первый.
class SaveCategoryParams extends Params {
  const SaveCategoryParams({this.id, required this.name, this.parentId});

  final String? id;
  final String name;

  /// `null` — категория на верхнем уровне.
  final String? parentId;
}

class SaveItemParams extends Params {
  const SaveItemParams(this.draft);

  final ItemDraft draft;
}

/// Удаление записи справочника любого уровня.
class CatalogEntryParams extends Params {
  const CatalogEntryParams(this.id);

  final String id;
}

/// Разбор выбранного файла. `categoryId == null` — импорт в корень.
class ParseImportParams extends Params {
  const ParseImportParams({required this.filePath, this.categoryId});

  final String filePath;
  final String? categoryId;
}

class ApplyImportParams extends Params {
  const ApplyImportParams(this.import);

  final CatalogImport import;
}
