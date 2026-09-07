import '../../../feature/catalog/data/catalog_repository.dart';
import '../../../feature/requests/data/request_repository.dart';

/// Плоский список зависимостей приложения.
///
/// Именно плоский: по полю на репозиторий, без сервис-локатора и без
/// «god-объекта» с ролями. Потребитель, дотягивающийся до чужой капабилити,
/// когда ему нужна одна, — ровно то, что этот раскол предотвращает.
class RootContainer {
  const RootContainer({
    required this.requestRepository,
    required this.catalogRepository,
  });

  final RequestRepository requestRepository;
  final CatalogRepository catalogRepository;
}

/// Собирает контейнер до первого кадра.
///
/// Единственное место, где реализации встречаются со своими интерфейсами,
/// и единственное место для асинхронной подготовки (открыть хранилище,
/// восстановить кэш) — она обязана закончиться раньше, чем что-то нарисуется.
abstract interface class DependencyFactory {
  Future<RootContainer> create();
}
