/// Дизайн-система приложения «Заявки на материалы».
///
/// Единственный публичный вход пакета: только экспорты. Сырая палитра
/// (`src/tokens/colors.dart`) намеренно не экспортируется — приложение берёт
/// цвет по смыслу через `context.request`, а не по значению.
library;

export 'src/theme/request_text_theme.dart';
export 'src/theme/request_theme.dart';
export 'src/theme/request_tokens.dart' show RequestTokens, RequestTokensX;
export 'src/tokens/dimens.dart';
export 'src/widgets/app_button.dart';
export 'src/widgets/app_card.dart';
export 'src/widgets/app_chip.dart';
export 'src/widgets/app_empty_state.dart';
export 'src/widgets/app_fab.dart';
export 'src/widgets/app_icon_button.dart';
export 'src/widgets/app_labeled_field.dart';
export 'src/widgets/app_meta_badge.dart';
export 'src/widgets/app_nav_bar.dart';
export 'src/widgets/app_numeric_keypad.dart';
export 'src/widgets/app_quantity_display.dart';
export 'src/widgets/app_scroll_top_button.dart';
export 'src/widgets/app_search_field.dart';
export 'src/widgets/app_section_label.dart';
export 'src/widgets/app_sheet.dart';
export 'src/widgets/app_snack.dart';
export 'src/widgets/app_status_chip.dart';
export 'src/widgets/app_stepper_button.dart';
export 'src/widgets/app_top_bar.dart';
export 'src/widgets/app_tree_row.dart';
