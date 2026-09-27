import '../../../feature/catalog/data/mock_catalog_repository.dart';
import '../../../feature/requests/data/mock_request_repository.dart';
import '../../../feature/settings/data/preferences_settings_repository.dart';
import 'dependency_container.dart';

/// Контейнер на моках: справочник из настоящего прайса, заявки в памяти.
///
/// Не тестовая заглушка. Пока не решено, куда отправляется заявка и как
/// хранятся файлы (см. `docs/architecture-prompt.md`, раздел «не определено»),
/// это единственный работающий вход в приложение — и он обязан проходить
/// сценарий целиком, а не до первого экрана.
class MockRootFactory implements DependencyFactory {
  const MockRootFactory();

  @override
  Future<RootContainer> create() async => RootContainer(
    requestRepository: MockRequestRepository(),
    catalogRepository: MockCatalogRepository(),
    settingsRepository: const PreferencesSettingsRepository(),
  );
}
