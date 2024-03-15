import 'dart:ui';
import 'package:sliding_switch/sliding_switch.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';

class AirConditionScreen extends StatelessWidget {
  const AirConditionScreen({Key? key}) : super(key: key);


  @override
  Widget build(BuildContext context) {
    DateTime now = DateTime.now();
    DateTime morning = DateTime(now.year, now.month, now.day, 6, 0, 0);
    DateTime afternoon = DateTime(now.year, now.month, now.day, 12, 0, 0);
    DateTime evening = DateTime(now.year, now.month, now.day, 18, 0, 0);

    String greeting;
    Color colorUp;
    Color colorDown;
    if (now.isAfter(morning) && now.isBefore(afternoon)) {
      greeting = 'Good Morning';
      colorUp = Colors.yellow;
      colorDown = Colors.blue;
    } else if (now.isAfter(afternoon) && now.isBefore(evening)) {
      greeting = 'Good Afternoon';
      colorUp = Colors.orange;
      colorDown = Colors.purple;
    } else {
      greeting = 'Good Evening';
      colorUp = Colors.blue;
      colorDown = Colors.deepPurple;
    }

    final sampleAirData = SampleAirData(
      dust: 1.0,
      lpg: 1.0,
      naturalGas: 1.0,
      ammonia: 1.0,
      smoke: 1.0,
      co2: 1.0,
    );

    return Scaffold(
        backgroundColor: Colors.black,
        extendBodyBehindAppBar: true,
        appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        systemOverlayStyle: SystemUiOverlayStyle(
        statusBarBrightness: Brightness.dark,
    ),
    ),
    body: Padding(
    padding: EdgeInsets.fromLTRB(40, 1.2 * kToolbarHeight, 40, 20),
    child: SizedBox(
    height: MediaQuery.of(context).size.height,
    child: Stack(
    children: [
    Align(
    alignment: AlignmentDirectional(3, -0.3),
    child: Container(
    height: 300,
    width: 300,
    decoration: BoxDecoration(
    shape: BoxShape.circle,
    color: colorDown,
    ),
    ),
    ),
    Align(
    alignment: AlignmentDirectional(-3, -0.3),
    child: Container(
    height: 300,
    width: 300,
    decoration: BoxDecoration(
    shape: BoxShape.circle,
    color: colorDown,
    ),
    ),
    ),
    Align(
    alignment: AlignmentDirectional(0, -1.2),
    child: Container(
    height: 300,
    width: 600,
    decoration: BoxDecoration(
    color: colorUp,
    ),
    ),
    ),
    BackdropFilter(
    filter: ImageFilter.blur(sigmaX: 100.0, sigmaY: 100.0),
    child: Container(
    decoration: BoxDecoration(color: Colors.transparent),
    ),
    ),
    SizedBox(
    width: MediaQuery.of(context).size.width,
    height: MediaQuery.of(context).size.height,
    child: Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      SizedBox(
        height: 8,
      ),
      Center(
        child: Text(
          'Air Pollution',
          style: TextStyle(
            color: Colors.white,
            fontSize: 35,
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
      const Padding(
        padding: EdgeInsets.symmetric(vertical: 30.0),
      ),
      SizedBox(
        height: 8,
      ),
      Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              Icon(
                Icons.wb_sunny_outlined,
                color: Colors.white,
                size: 35,
              ),
              SizedBox(width: 5),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Natural Gas',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 20,
                      fontWeight: FontWeight.w300,
                    ),
                  ),
                  SizedBox(height: 1),
                  Text(
                    '${sampleAirData.dust!}',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 20,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ],
              ),
            ],
          ),
          Row(
            children: [
              Icon(
                Icons.fire_extinguisher,
                color: Colors.white,
                size:35,
              ),
              SizedBox(width: 8),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'LPG',
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.w300,
                      fontSize: 20,
                    ),
                  ),
                  SizedBox(height: 3),
                  Text(
                    '${sampleAirData.ammonia!}',
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.w700,
                      fontSize: 20,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
      const Padding(
        padding: EdgeInsets.symmetric(vertical: 14.0),
        child: Divider(
          color: Colors.grey,
        ),
      ),
      Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              Icon(
                Icons.dehaze,
                color: Colors.white,
                size: 35,
              ),
              SizedBox(width: 5),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Dust',
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.w300,
                      fontSize: 20,
                    ),
                  ),
                  SizedBox(height: 8),
                  Text(
                    '${sampleAirData.dust!}',
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.w700,
                      fontSize: 20,
                    ),
                  ),
                ],
              ),
            ],
          ),
          Row(
            children: [
              Icon(
                Icons.science,
                color: Colors.white,
                size: 35,
              ),
              SizedBox(width: 8),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'NH2',
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.w300,
                      fontSize: 20,
                    ),
                  ),
                  SizedBox(height: 3),
                  Text(
                    '${sampleAirData.ammonia!}',
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.w700,
                      fontSize: 20,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
      const Padding(
        padding: EdgeInsets.symmetric(vertical: 15.0),
        child: Divider(
          color: Colors.grey,
        ),
      ),
      Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          // Display max temperature
          Row(
            children: [
              Icon(
                Icons.smoke_free,
                color: Colors.white,
                size: 35,
              ),
              SizedBox(width: 5),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Smoke',
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.w300,
                      fontSize: 20
                    ),
                  ),
                  SizedBox(height: 3),
                  Text(
                    '${sampleAirData.smoke!}',
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.w700,
                      fontSize: 20
                    ),
                  ),
                ],
              ),
            ],
          ),
          // Display min temperature
          Row(
            children: [
              Icon(
                Icons.cloud,
                color: Colors.white,
                size: 35,
              ),
              SizedBox(width: 5),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'CO2',
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.w300,
                      fontSize: 20
                    ),
                  ),
                  SizedBox(height: 3),
                  Text(
                    '${sampleAirData.co2!}',
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.w700,
                      fontSize: 20
                    ),
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
      SizedBox(height: 6),
      // Sliding switch for weather and air condition
      Expanded(
        child: Align(
        alignment: FractionalOffset.bottomCenter,
        child: Center(
          child: SlidingSwitch(
            value: true,
            width: 250,
            onChanged: (bool value) {
              print(value);
            },
            height: 35,
            animationDuration: const Duration(milliseconds: 400),
            onTap: () {},
            onDoubleTap: () {},
            onSwipe: () {},
            textOff: "Weather",
            textOn: "Air Condition",
            colorOn: const Color(0xffdc6c73),
            colorOff: const Color(0xff6682c0),
            background: Color.fromARGB(43, 204, 203, 203),
            buttonColor: Color.fromARGB(42, 247, 245, 247),
            inactiveColor: const Color(0xff636f7b),
          ),
        ),
      ),
      ),
    ],
    ),
    ),
    ],
    ),
    ),
    ),
    );
  }
}

class SampleAirData {
  final double? dust;
  final double? lpg;
  final double? naturalGas;
  final double? ammonia;
  final double? smoke;
  final double? co2;

  SampleAirData({
    this.dust,
    this.lpg,
    this.naturalGas,
    this.ammonia,
    this.smoke,
    this.co2,
  });
}
