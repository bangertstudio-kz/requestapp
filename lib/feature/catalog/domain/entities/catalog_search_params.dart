import '../../../../core/domain/entities/params.dart';

/// Поиск по всем материалам справочника.
class CatalogSearchParams extends Params {
  const CatalogSearchParams(this.query);

  final String query;
}
