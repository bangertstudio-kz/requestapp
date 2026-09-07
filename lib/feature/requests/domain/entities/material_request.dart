import 'request_item.dart';
import 'request_status.dart';

/// Заявка на материалы.
class MaterialRequest {
  const MaterialRequest({
    required this.id,
    required this.name,
    required this.createdAt,
    required this.status,
    required this.folderId,
    required this.items,
  });

  final String id;
  final String name;

  /// Дата хранится как дата, а не как «04.09.2026»: формат выбирает экран
  /// по локали, а сортировка и фильтр работают только по типу.
  final DateTime createdAt;

  final RequestStatus status;

  /// `null` — заявка лежит вне папок. Обязательное поле с пустой строкой
  /// вместо этого заставило бы каждое место проверять строку на пустоту.
  final String? folderId;

  final List<RequestItem> items;
}

/// Правки заявки как операции над сущностью.
///
/// В домене, а не в экране: «увеличить количество» — это операция над
/// заявкой, и её результат один и тот же, откуда бы её ни позвали.
extension RequestItemEdits on MaterialRequest {
  MaterialRequest withItems(List<RequestItem> items) => MaterialRequest(
    id: id,
    name: name,
    createdAt: createdAt,
    status: status,
    folderId: folderId,
    items: items,
  );

  MaterialRequest withName(String value) => MaterialRequest(
    id: id,
    name: value,
    createdAt: createdAt,
    status: status,
    folderId: folderId,
    items: items,
  );

  MaterialRequest replacingItem(RequestItem item) => withItems([
    for (final existing in items)
      if (existing.id == item.id) item else existing,
  ]);

  MaterialRequest removingItem(String itemId) => withItems([
    for (final item in items)
      if (item.id != itemId) item,
  ]);
}
