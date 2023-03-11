// ignore_for_file: curly_braces_in_flow_control_structures, prefer_const_constructors, prefer_final_fields, unused_field

import 'dart:math';
import 'dart:ui';
import 'package:flutter/material.dart';

///表盘
class DialPlate extends CustomPainter {
  late Paint _paintDial;
  late Paint _paintGradient;
  late double _radius;

  late double _screenWidth;
  late double _screenHeight;
  int _numPoint = 24;
  late ParagraphBuilder _timeParagraphBuilder;

  //渐变颜色
  late Color _startColor;
  late Color _endColor;

  DialPlate(BuildContext context, Color startColor, Color endColor) {
    _screenWidth = MediaQuery.of(context).size.width;
    _screenHeight = MediaQuery.of(context).size.height;
    _radius = _screenWidth / 100 * 37;

    _startColor = startColor;
    _endColor = endColor;

    _paintDial = Paint()
      ..color = Colors.white
      ..isAntiAlias = true
      ..style = PaintingStyle.fill;

    var circle = Rect.fromCircle(center: Offset(0, 0), radius: _screenHeight);
    var sweepGradient = SweepGradient(
      colors: [_startColor, _endColor],
    );
    _paintGradient = Paint()
      ..isAntiAlias = true
      ..shader = sweepGradient.createShader(circle)
      ..style = PaintingStyle.fill;

    _timeParagraphBuilder = ParagraphBuilder(ParagraphStyle(
        textAlign: TextAlign.center,
        fontSize: 70,
        maxLines: 1,
        fontWeight: FontWeight.bold));
  }

  @override
  void paint(Canvas canvas, Size size) {
    DateTime dateTime = DateTime.now();
    var hour = dateTime.hour;
    var minute = dateTime.minute;
    var second = dateTime.second;

    canvas.translate(_screenWidth / 2, _screenHeight / 100 * 37);
    //绘制渐变背景
    canvas.save();
    canvas.rotate(_getRotate(second));
    canvas.drawCircle(Offset(0, 0), _screenHeight, _paintGradient);
    canvas.restore();

    canvas.save();
    for (double i = 0; i < _numPoint; i++) {
      canvas.save();
      double deg = 360 / _numPoint * i;
      canvas.rotate(deg / 180 * pi);

      // if (isShowBigCircle(hour, i)) {
      //   Path path = Path()
      //       ..addArc(Rect.fromCircle(center: Offset(_radius, 0), radius: 8), 0,
      //         pi * 2);
      //   canvas.drawShadow(path, Colors.yellow, 4, true);
      //   _paintDial.color = Colors.yellow;
      //   canvas.drawCircle(Offset(_radius, 0), 8, _paintDial);
      // } else {
      //   _paintDial.color = Colors.white;
      //   canvas.drawCircle(Offset(_radius, 0), 3, _paintDial);
      // }
      canvas.restore();

      canvas.save();
      _timeParagraphBuilder.addText(_getTimeStr(hour, minute));

      Paragraph paragraph = _timeParagraphBuilder.build();
      paragraph.layout(ParagraphConstraints(width: 230));
      canvas.drawParagraph(paragraph, Offset(-115, -42));
      canvas.restore();
    }

    canvas.restore();
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }

  ///是否显示小时圆点
  // bool isShowBigCircle(int hour, double index) {
  //   if (hour >= 12) hour = hour - 12;
  //   int numHour = hour * 2 + 18;
  //   if (numHour < 24) {
  //     return index == numHour;
  //   } else {
  //     return index == (numHour - 24);
  //   }
  // }

  ///获取秒针显示的位置
  double _getRotate(int second) {
    var anglePer = pi * 2 / 60;
    var diff = second - 15;
    return diff * anglePer;
  }

  ///获取时间的字符串形式
  String _getTimeStr(int hour, int minute) {
    String hourStr;
    String minuteStr;
    if (hour < 10)
      hourStr = '0$hour';
    else
      hourStr = hour.toString();
    if (minute < 10)
      minuteStr = '0$minute';
    else
      minuteStr = minute.toString();
    return '$hourStr:$minuteStr';
  }
}
