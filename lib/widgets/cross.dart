import 'package:flutter/material.dart';

class CrossWidget extends StatelessWidget {
  const CrossWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      painter: _CrossPainter(),
    );
  }
}

class _CrossPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final painter = Paint()
      ..color = Colors.black
      ..strokeWidth = 10;
    final width = size.width;
    final height = size.height;

    canvas.drawLine(const Offset(0, 0), Offset(width, height), painter);
    canvas.drawLine(Offset(0, height), Offset(width, 0), painter);
  }

  @override
  bool shouldRepaint(_CrossPainter oldDelegate) => false;

  @override
  bool shouldRebuildSemantics(_CrossPainter oldDelegate) => false;
}
