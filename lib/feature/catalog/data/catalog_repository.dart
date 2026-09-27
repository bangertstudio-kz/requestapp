import '../domain/entities/catalog_category.dart';
import '../domain/entities/catalog_import.dart';
import '../domain/entities/catalog_item.dart';
import '../domain/entities/item_draft.dart';

/// Справочник материалов: дерево, поиск и правки.
abstract interface class CatalogRepository {
  /// Всё дерево целиком, любой глубины. 326 материалов помещаются в память
  /// и нужны сразу: экран подбора разворачивает ветки на месте, и догрузка
  /// листа по нажатию была бы спиннером там, где ожидался список.
  Future<List<CatalogCategory>> categories();

  /// Плоский поиск по названиям материалов во всём справочнике.
  Future<List<CatalogItem>> searchItems(String query);

  /// Создаёт категорию, переименовывает её или переносит в другое место
  /// дерева. `id == null` — создание, `parentId == null` — верхний уровень.
  ///
  /// Одна операция на все уровни: «завести подкатегорию» — это создание
  /// с непустым родителем, «поднять её наверх» — правка с пустым.
  ///
  /// [parentId] обязателен, хотя и может быть `null`: необязательным он
  /// однажды молча подставил `null` в вызове, забывшем его передать, и
  /// категории переставали попадать внутрь выбранной. Теперь место
  /// приходится называть вслух на каждом вызове.
  Future<void> saveCategory({
    String? id,
    required String name,
    required String? parentId,
  });

  /// Удаляет категорию вместе со всем, что в ней лежит.
  Future<void> deleteCategory(String id);

  /// Создаёт, переименовывает или переносит материал в другую категорию.
  Future<void> saveItem(ItemDraft draft);

  Future<void> deleteItem(String id);

  /// Задаёт порядок материалов категории: [itemIds] — все её материалы
  /// в новом порядке. Весь список, а не «откуда и куда»: сдвиг одной строки
  /// перенумеровывает соседей, и считать это на двух сторонах значит однажды
  /// разойтись.
  Future<void> reorderItems(String categoryId, List<String> itemIds);

  /// Разбирает файл и считает, что даст импорт в [categoryId]
  /// (`null` — в корень справочника). Справочник при этом не трогает:
  /// пользователь должен увидеть цифры до того, как согласится.
  Future<CatalogImport> parseImport(String filePath, {String? categoryId});

  /// Вливает разобранный файл в справочник. Возвращает число материалов.
  ///
  /// Принимает разбор целиком, а не путь к файлу: человек согласился
  /// на цифры, которые увидел, и повторный разбор мог бы дать другие.
  Future<int> applyImport(CatalogImport import);
}
