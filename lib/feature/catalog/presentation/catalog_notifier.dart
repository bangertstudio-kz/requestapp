import '../../../core/presentation/request_notifier.dart';
import '../data/catalog_repository.dart';
import '../domain/entities/catalog_category.dart';

/// Дерево справочника целиком.
///
/// App-scoped и один на приложение: его читают и экран подбора, и справочник,
/// и форма материала. Второй нотифаер на те же данные означал бы два разных
/// представления об одном справочнике на соседних экранах.
class CatalogNotifier extends RequestNotifier<List<CatalogCategory>, Null> {
  CatalogNotifier(this._repository);

  final CatalogRepository _repository;

  @override
  Future<List<CatalogCategory>> fetch(Null params) => _repository.categories();
}
