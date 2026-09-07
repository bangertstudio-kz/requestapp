import 'package:flutter/material.dart';

import '../theme/request_tokens.dart';

/// Подпись секции: «ПАПКИ», «МАТЕРИАЛЫ · 4», «КОЛИЧЕСТВО».
///
/// Регистр поднимает виджет, а не ARB: в файле переводов строка должна
/// читаться так, как её написал человек, иначе её неудобно переводить и
/// невозможно переиспользовать в предложении.
class AppSectionLabel extends StatelessWidget {
  const AppSectionLabel(this.text, {super.key});

  final String text;

  @override
  Widget build(BuildContext context) {
    final tokens = context.request;
    return Text(text.toUpperCase(), style: tokens.text.sectionLabel);
  }
}
