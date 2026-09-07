import '../../../../core/domain/entities/params.dart';
import 'catalog_import_summary.dart';
import 'material_draft.dart';

/// Создание или переименование категории. `id == null` — создание.
class SaveCategoryParams extends Params {
  const SaveCategoryParams({this.id, required this.name});

  final String? id;
  final String name;
}

/// Создание или переименование подкатегории внутри категории.
class SaveSubcategoryParams extends Params {
  const SaveSubcategoryParams({
    this.id,
    required this.categoryId,
    required this.name,
  });

  final String? id;
  final String categoryId;
  final String name;
}

class SaveMaterialParams extends Params {
  const SaveMaterialParams(this.draft);

  final MaterialDraft draft;
}

/// Удаление записи справочника любого уровня.
class CatalogEntryParams extends Params {
  const CatalogEntryParams(this.id);

  final String id;
}

class ParsePriceListParams extends Params {
  const ParsePriceListParams(this.fileName);

  final String fileName;
}

class ApplyPriceListParams extends Params {
  const ApplyPriceListParams(this.summary);

  final CatalogImportSummary summary;
}
