import 'package:flutter/material.dart';

class ScanBrackets extends StatefulWidget {
  final double size;
  const ScanBrackets({super.key, this.size = 260});

  @override
  State<ScanBrackets> createState() => _ScanBracketsState();
}

class _ScanBracketsState extends State<ScanBrackets> with SingleTickerProviderStateMixin {
  late final AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(vsync: this, duration: const Duration(seconds: 1));
    _controller.repeat(reverse: true);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: widget.size,
      height: widget.size * 0.7,
      child: AnimatedBuilder(
        animation: _controller,
        builder: (context, child) {
          final opacity = 0.4 + 0.6 * _controller.value;
          return CustomPaint(
            painter: _BracketPainter(opacity: opacity),
          );
        },
      ),
    );
  }
}

class _BracketPainter extends CustomPainter {
  final double opacity;
  _BracketPainter({required this.opacity});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.white.withOpacity(opacity)
      ..strokeWidth = 3.0
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;

    const corner = 20.0;

    // top-left
    canvas.drawPath(
      Path()
        ..moveTo(0, corner)
        ..lineTo(0, 0)
        ..lineTo(corner, 0),
      paint,
    );

    // top-right
    canvas.drawPath(
      Path()
        ..moveTo(size.width - corner, 0)
        ..lineTo(size.width, 0)
        ..lineTo(size.width, corner),
      paint,
    );

    // bottom-right
    canvas.drawPath(
      Path()
        ..moveTo(size.width, size.height - corner)
        ..lineTo(size.width, size.height)
        ..lineTo(size.width - corner, size.height),
      paint,
    );

    // bottom-left
    canvas.drawPath(
      Path()
        ..moveTo(corner, size.height)
        ..lineTo(0, size.height)
        ..lineTo(0, size.height - corner),
      paint,
    );
  }

  @override
  bool shouldRepaint(covariant _BracketPainter oldDelegate) => oldDelegate.opacity != opacity;
}
