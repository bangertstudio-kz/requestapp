import '../../../feature/catalog/data/datasources/drift_catalog_local_data_source.dart';
import '../../../feature/catalog/data/drift_catalog_repository.dart';
import '../../../feature/requests/data/datasources/drift_request_local_data_source.dart';
import '../../../feature/requests/data/drift_request_repository.dart';
import '../../database/app_database.dart';
import 'dependency_container.dart';

/// Контейнер на SQLite: справочник и заявки переживают перезапуск.
///
/// Единственное место, где датасорсы встречаются с репозиториями.
///
/// Хранилище не наполняется ничем: новое устройство открывает приложение
/// с пустым справочником и подсказкой, что прайс можно загрузить. Заведённые
/// за человека категории и папки пришлось бы удалять вручную, и первым
/// впечатлением от приложения был бы чужой порядок.
class DriftRootFactory implements DependencyFactory {
  const DriftRootFactory();

  @override
  Future<RootContainer> create() async {
    final database = AppDatabase();

    return RootContainer(
      requestRepository: DriftRequestRepository(
        DriftRequestLocalDataSource(database),
      ),
      catalogRepository: DriftCatalogRepository(
        DriftCatalogLocalDataSource(database),
      ),
    );
  }
}
