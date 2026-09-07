import 'package:flutter/material.dart';

/// Пересобирает поддерево при наведении курсора.
///
/// В макете наведение меняет цвет рамки, а не только подложку, поэтому
/// стандартных `overlayColor`/`WidgetStateProperty` не хватает: они красят
/// поверх, а нам нужно перекрасить сам `Border`. На телефоне колбэк не
/// приходит вовсе, и виджет обходится нулевой ценой.
class HoverBuilder extends StatefulWidget {
  const HoverBuilder({super.key, required this.builder, this.enabled = true});

  final ValueWidgetBuilder<bool> builder;
  final bool enabled;

  @override
  State<HoverBuilder> createState() => _HoverBuilderState();
}

class _HoverBuilderState extends State<HoverBuilder> {
  bool _hovered = false;

  void _setHovered(bool value) {
    if (_hovered == value) return;
    setState(() => _hovered = value);
  }

  @override
  Widget build(BuildContext context) {
    if (!widget.enabled) return widget.builder(context, false, null);
    return MouseRegion(
      onEnter: (_) => _setHovered(true),
      onExit: (_) => _setHovered(false),
      child: widget.builder(context, _hovered, null),
    );
  }
}
