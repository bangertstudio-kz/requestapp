import '../../../generated/app_localizations.dart';
import '../domain/entities/item_unit.dart';

/// Подпись единицы измерения.
///
/// Функция, а не `extension` на enum: подпись — это presentation, и
/// доменное значение не должно уметь себя называть. Один `switch` вместо
/// шести одинаковых по экранам — тот случай, когда общий код честнее копии.
String itemUnitLabel(AppLocalizations l10n, ItemUnit unit) =>
    switch (unit) {
      ItemUnit.piece => l10n.unitPiece,
      ItemUnit.meter => l10n.unitMeter,
      ItemUnit.set => l10n.unitSet,
    };
