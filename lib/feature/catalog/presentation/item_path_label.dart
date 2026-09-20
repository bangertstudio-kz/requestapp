import '../../../generated/app_localizations.dart';

/// Путь материала одной строкой: «Канализация → Труба → Чугунная».
///
/// Функция, а не строка в ARB с двумя подстановками: длина пути теперь
/// любая, и фраза с фиксированным числом звеньев перестала бы её выражать.
/// Разделитель при этом остаётся в ARB — он зависит от языка.
String itemPathLabel(AppLocalizations l10n, List<String> path) =>
    path.join(l10n.pathSeparator);
