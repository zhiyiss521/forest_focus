import 'dart:math';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../widget/FocusTime.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {

  double minutes = 10;

  String get plantName {
    if (minutes < 20) {
      return 'assets/plant_1.png';
    } else if (minutes < 40) {
      return 'assets/plant_2.png';
    } else if (minutes < 60) {
      return 'assets/plant_3.png';
    } else {
      return 'assets/plant_4.png';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFF4CAF93),
      extendBody: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
      ),
      body: Center(
        child: Column(
          children: [
            SizedBox(
              width: 320,
              height: 320,
              child: Stack(
                alignment: Alignment.center,
                children: [
                  FocusTimerWidget(
                    initialMinutes: minutes,
                    maxMinutes: 100,
                    onChanged: (value){
                      setState(() {
                        minutes = value;
                      });
                    },
                  ),
                  Image.asset(
                      plantName,
                    width: 200,
                    height: 200,
                  ),
                ],
              )
            ),


            Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  minutes.round().toString(),
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 64,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const Text(
                  "minutes",
                  style: TextStyle(
                    color: Colors.white70,
                    fontSize: 18,
                  ),
                ),
              ],
            ),
          ],
        )
      )
    );
  }
}

