import 'package:flutter/material.dart';

class RoundedUnderlineTabIndicator extends Decoration {
  final BorderSide borderSide;
  final double radius;
  final EdgeInsetsGeometry insets;

  const RoundedUnderlineTabIndicator({
    this.borderSide = const BorderSide(width: 0.0, color: Colors.white),
    this.radius = 4.0,
    this.insets = EdgeInsets.zero,
  });

  @override
  BoxPainter createBoxPainter([VoidCallback? onChanged]) {
    return _RoundedUnderlinePainter(this, onChanged);
  }
}

class _RoundedUnderlinePainter extends BoxPainter {
  final RoundedUnderlineTabIndicator decoration;

  _RoundedUnderlinePainter(this.decoration, VoidCallback? onChanged)
    : super(onChanged);

  @override
  void paint(Canvas canvas, Offset offset, ImageConfiguration config) {
    assert(config.size != null);
    final Rect rect = offset & config.size!;
    final TextDirection textDirection = config.textDirection!;

    final Rect indicator = decoration.insets
        .resolve(textDirection)
        .deflateRect(
          Rect.fromLTWH(
            rect.left,
            rect.bottom - decoration.borderSide.width,
            rect.width,
            decoration.borderSide.width,
          ),
        );

    final RRect rrect = RRect.fromRectAndRadius(
      indicator,
      Radius.circular(decoration.radius),
    );

    final Paint paint = decoration.borderSide.toPaint();
    canvas.drawRRect(rrect, paint);
  }
}
