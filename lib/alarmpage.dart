import 'dart:async';

import 'package:flutter/material.dart';
import 'package:myalaram/dial_plate.dart';

class Alarmpage extends StatefulWidget {
  const Alarmpage({super.key});
  @override
  State<StatefulWidget> createState() {
    return _AlarmpageState();
  }
}

class _AlarmpageState extends State<Alarmpage> {
  late Timer _timer;
  @override
  void initState() {
    super.initState();
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      setState(() {});
    });
  }

  @override
  void dispose() {
    super.dispose();
    _timer.cancel();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(children: [
        CustomPaint(
          painter: DialPlate(context, const Color.fromARGB(255, 70, 0, 144),
              const Color.fromARGB(227, 0, 0, 0)),
        ),
      ]),
    );
  }
}
