import 'dart:math';
import 'dart:ui';

class SliderController {
  double width = 0.0;
  double height = 0.0;
  late double centerX;
  late double centerY;
  double initRadius = 0.0;
  double radius = 0.0;
  late double margin;
  double currentX = 0.0;
  double animationProgress = 0.0;

  int minValue = 11;
  int maxValue = 59;
  String value = "";
  late double spacing;

  late double strokeWidth;

  void initialize(Size size) {
    bool updateRadius = width != size.width ? true : false;
    width = size.width;
    height = size.height;
    centerX = width / 2;
    centerY = height / 2;
    initRadius = width * 0.02;
    margin = initRadius * 4;
    strokeWidth = initRadius / 3;

    if (radius == 0 || updateRadius) {
      radius = initRadius;
    }
    //set default value
    if (value == "") {
      value = ">${minValue - 1}";
    }
  }

  void updatePosition(double increment) {
    currentX = min(max(currentX + increment, 0), width - 2 * (radius + margin));
    double currentProgress = currentX / (width - 2 * (radius + margin));
    // update slider value
    if (currentProgress == 0) {
      value = ">${minValue - 1}";
    } else if (currentProgress == 1) {
      value = "${maxValue + 1}<";
    } else {
      value = (minValue + (currentProgress * (maxValue - minValue)))
          .round()
          .toString();
    }
  }

  Offset getCirclePosition() {
    double x = currentX + radius + margin;
    double y = centerY - (margin / 2 * (animationProgress - 1));
    return Offset(x, y);
  }

  void animate(double value) {
    animationProgress = value;
    radius = initRadius * (1 + value / 8);
  }
}

final slider = SliderController();
