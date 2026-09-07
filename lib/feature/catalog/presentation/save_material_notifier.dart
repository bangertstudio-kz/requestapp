import '../../../core/presentation/request_notifier.dart';
import '../data/catalog_repository.dart';
import '../domain/entities/catalog_params.dart';

/// Создание, переименование и перенос материала.
///
/// Перенос в другую подкатегорию — то же сохранение: в форме это одно поле,
/// и отдельная операция «переместить» существовала бы только в коде.
class SaveMaterialNotifier extends RequestNotifier<String, SaveMaterialParams> {
  SaveMaterialNotifier(this._repository);

  final CatalogRepository _repository;

  @override
  Future<String> fetch(SaveMaterialParams params) async {
    await _repository.saveMaterial(params.draft);
    return params.draft.name;
  }
}
