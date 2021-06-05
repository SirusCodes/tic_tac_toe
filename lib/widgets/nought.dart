import 'package:flutter/material.dart';

class NoughtWidget extends StatelessWidget {
  const NoughtWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      painter: _NoughtPainter(),
    );
  }
}

class _NoughtPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final painter = Paint()
      ..color = Colors.black
      ..strokeWidth = 10
      ..style = PaintingStyle.stroke;
    final width = size.width;
    final height = size.height;

    canvas.drawCircle(Offset(width / 2, height / 2), width / 2, painter);
  }

  @override
  bool shouldRepaint(_NoughtPainter oldDelegate) => false;

  @override
  bool shouldRebuildSemantics(_NoughtPainter oldDelegate) => false;
}
