import '../../../generated/app_localizations.dart';
import '../domain/entities/material_unit.dart';

/// Подпись единицы измерения.
///
/// Функция, а не `extension` на enum: подпись — это presentation, и
/// доменное значение не должно уметь себя называть. Один `switch` вместо
/// шести одинаковых по экранам — тот случай, когда общий код честнее копии.
String materialUnitLabel(AppLocalizations l10n, MaterialUnit unit) =>
    switch (unit) {
      MaterialUnit.piece => l10n.unitPiece,
      MaterialUnit.meter => l10n.unitMeter,
      MaterialUnit.set => l10n.unitSet,
    };
