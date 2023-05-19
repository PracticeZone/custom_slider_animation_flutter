import 'package:custom_slider/colors.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'dart:math';

import 'slider_controller.dart';

class CustomSlider extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _CustomSlider();
}

class _CustomSlider extends State<CustomSlider>
    with SingleTickerProviderStateMixin {
  late AnimationController controller;
  late Animation<double> animation;

  @override
  void initState() {
    super.initState();
    controller = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 200));
    animation = Tween<double>(begin: 0, end: 1)
        .animate(CurvedAnimation(parent: controller, curve: Curves.easeInOut));

    controller.addListener(() {
      setState(() {
        slider.animate(animation.value);
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onPanDown: (details) {
        controller.forward();
      },
      onPanEnd: (details) {
        controller.reverse();
      },
      onPanUpdate: (details) {
        setState(() {
          slider.updatePosition(details.delta.dx);
        });
      },
      child: Container(
        constraints: const BoxConstraints.expand(),
        margin: const EdgeInsets.symmetric(vertical: 32),
        child: CustomPaint(
          painter: SliderPainter(),
        ),
      ),
    );
  }
}

class SliderPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    slider.initialize(size);
    Paint linePaint = Paint()
      ..style = PaintingStyle.stroke
      ..color = color.primary
      ..strokeWidth = slider.strokeWidth;

    Paint circlePaint = Paint()..color = color.primary;
    canvas.drawCircle(slider.getCirclePosition(), slider.radius, circlePaint);

    Offset line1S = Offset(0, slider.centerY);
    Offset line1E = Offset(
        slider.getCirclePosition().dx - slider.radius - slider.margin,
        slider.centerY);
    canvas.drawLine(line1S, line1E, linePaint);

    Offset line2S = Offset(
        slider.getCirclePosition().dx + slider.radius + slider.margin,
        slider.centerY);
    Offset line2E = Offset(slider.width, slider.centerY);

    canvas.drawLine(line2S, line2E, linePaint);

    double startX = 0.0;

    double amplitude = slider.radius * slider.animationProgress;
    Offset curveS = Offset(line1E.dx - 1, line1E.dy);
    Offset curveE = Offset(line2S.dx + 1, line2S.dy);
    double endX = curveE.dx - curveS.dx;
    double period = 2 * pi / endX;
    final path = Path();

    for (double x = startX; x <= endX; x++) {
      double y = amplitude * sin(period * x - pi / 2) + amplitude;
      Offset point = Offset(curveS.dx + x, slider.centerY - y);
      if (x == startX) {
        path.moveTo(point.dx, point.dy);
      } else {
        path.lineTo(point.dx, point.dy);
      }
    }

    canvas.drawPath(path, linePaint);

    //draw min value
    final text1 = drawText(">${slider.minValue - 1}", color.textSecondary, 0.5);
    final text1Offset = Offset(slider.margin - text1.width / 2,
        slider.centerY + slider.margin / 2 + text1.height / 2);
    text1.paint(canvas, text1Offset);

    // draw max value
    final text2 = drawText("${slider.maxValue + 1}<", color.textSecondary, 0.5);
    Offset text2Offset = Offset(slider.width - slider.margin - text2.width / 2,
        slider.centerY + slider.margin / 2 + text2.height / 2);
    text2.paint(canvas, text2Offset);

    // draw current value
    final mainText = drawText(slider.value, color.tertiary, 0.6);
    Offset mainTextOffset = Offset(
        slider.getCirclePosition().dx - mainText.width / 2,
        slider.getCirclePosition().dy -
            2.5 * slider.margin +
            mainText.height / 2);

    // draw current value container
    double left = mainTextOffset.dx - slider.margin / 3;
    double right = left + mainText.width + slider.margin / 1.5;
    double top = mainTextOffset.dy - slider.margin / 6;
    double bottom = top + mainText.height + slider.margin / 3;
    final rect =
        RRect.fromLTRBR(left, top, right, bottom, const Radius.circular(8));
    final rectPaint = Paint()..color = color.primary;
    canvas.drawRRect(rect, rectPaint);
    mainText.paint(canvas, mainTextOffset);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }

  drawText(String text, Color color, double fontSize) {
    double size = fontSize * slider.spacing;
    final textStyle =
        TextStyle(color: color, fontSize: size, fontFamily: 'Poppins');
    final textSpan = TextSpan(text: text, style: textStyle);
    final textPainter =
        TextPainter(text: textSpan, textDirection: TextDirection.ltr);
    textPainter.layout();
    return textPainter;
  }
}
