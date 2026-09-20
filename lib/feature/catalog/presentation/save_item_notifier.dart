import '../../../core/presentation/request_notifier.dart';
import '../data/catalog_repository.dart';
import '../domain/entities/catalog_params.dart';

/// Создание, переименование и перенос материала.
///
/// Перенос в другую подкатегорию — то же сохранение: в форме это одно поле,
/// и отдельная операция «переместить» существовала бы только в коде.
class SaveItemNotifier extends RequestNotifier<String, SaveItemParams> {
  SaveItemNotifier(this._repository);

  final CatalogRepository _repository;

  @override
  Future<String> fetch(SaveItemParams params) async {
    await _repository.saveItem(params.draft);
    return params.draft.name;
  }
}
