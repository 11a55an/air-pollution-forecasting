import 'dart:ui';
import 'package:envirocast/screens/detail_screen.dart';
import 'package:kdgaugeview/kdgaugeview.dart';
import 'package:sliding_switch/sliding_switch.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'home_screen.dart';
import 'outdoor_screen.dart';
import 'package:flutter/cupertino.dart';

class AirConditionScreen extends StatelessWidget {
  final Color colorUp;
  final Color colorDown;
  const AirConditionScreen({
    Key? key,
    required this.colorUp,
    required this.colorDown,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {

    final sampleAirData = SampleAirData(
      dust: 1.0,
      lpg: 1.0,
      naturalGas: 1.0,
      NH2: 1.0,
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
              SingleChildScrollView(
                child: Container(
                  width: MediaQuery.of(context).size.width,
                  height: 850,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(
                        height: 8,
                      ),

                      Center(
                        child: Text(
                          'Indoor Air Data',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 35,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                      const Padding(
                        padding: EdgeInsets.symmetric(vertical: 10.0),
                      ),
                      Container(
                        width: 320,
                        height: 300,
                        child: Center(
                          child: KdGaugeView(
                            minSpeed: 0,
                            maxSpeed: 200,
                            speed: 105,
                            animate: true,
                            duration: Duration(seconds: 5),
                            alertSpeedArray: [50, 100, 150, 200],
                            alertColorArray: [
                              Colors.green,
                              Colors.yellow,
                              Colors.orange,
                              Colors.red
                            ],
                            unitOfMeasurement: "ppm",
                            gaugeWidth: 15,
                            minMaxTextStyle: const TextStyle(
                                color: Colors.white, fontSize: 20),
                            unitOfMeasurementTextStyle: const TextStyle(
                                color: Colors.white,
                                fontSize: 30,
                                fontWeight: FontWeight.w500),
                            speedTextStyle: const TextStyle(
                                color: Colors.white,
                                fontSize: 50,
                                fontWeight: FontWeight.w600),
                            //activeGaugeColor: Colors.white,
                          ),
                        ),
                      ),

                      Center(
                        child: ElevatedButton(
                          onPressed: () {
                            print('Outdoor');
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => OutdoorScreen(colorUp: colorUp,
                                    colorDown: colorDown,)),
                            );
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Color.fromARGB(43, 204, 203, 203),
                            minimumSize: Size(150, 50), // Button size
                            padding: EdgeInsets.symmetric(
                                horizontal: 16), // Button padding
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(
                                  30), // Button border radius
                            ),
                          ),
                          child: Text(
                            'Outdoor',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 25,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ),
                      ),

                      const Padding(
                        padding: EdgeInsets.symmetric(vertical: 10.0),
                      ),

                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          GestureDetector(
                            onTap: () {
                              // Navigate to detail screen
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => DetailScreen(
                                          parameterName: 'Natural Gass',
                                          parameterValue: 2.0,
                                          predictedValue: 0,
                                          speedValue: 45,
                                          colorUp: colorUp,
                                          colorDown: colorDown,)));

                              // You can use Navigator.push or any other navigation method here
                            },
                            child: Row(
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
                                      '${sampleAirData.naturalGas!}',
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
                          ),
                          GestureDetector(
                            onTap: () {
                              // Navigate to detail screen
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => DetailScreen(
                                          parameterName: 'LPG',
                                          parameterValue: 1.0,
                                          predictedValue: 0,
                                          speedValue: 55,
                                        colorUp: colorUp,
                                        colorDown: colorDown,)));

                              // You can use Navigator.push or any other navigation method here
                            },
                            child: Row(
                              children: [
                                Icon(
                                  CupertinoIcons.flame,
                                  color: Colors.white,
                                  size: 35,
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
                                      '${sampleAirData.lpg!}',
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
                          GestureDetector(
                            onTap: () {
                              // Navigate to detail screen
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => DetailScreen(
                                          parameterName: 'Dust',
                                          parameterValue: 120,
                                          predictedValue: 0,
                                          speedValue: 120,
                                        colorUp: colorUp,
                                        colorDown: colorDown,)));

                              // You can use Navigator.push or any other navigation method here
                            },
                            child: Row(
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
                          ),
                          GestureDetector(
                            onTap: () {
                              // Navigate to detail screen
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => DetailScreen(
                                          parameterName: 'NH2',
                                          parameterValue: 180,
                                          predictedValue: 0,
                                          speedValue: 180,
                                        colorUp: colorUp,
                                        colorDown: colorDown,)));

                              // You can use Navigator.push or any other navigation method here
                            },
                            child: Row(
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
                                      '${sampleAirData.NH2!}',
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
                          GestureDetector(
                            onTap: () {
                              // Navigate to detail screen
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => DetailScreen(
                                          parameterName: 'Smoke',
                                          parameterValue: 45,
                                          predictedValue: 0,
                                          speedValue: 45,
                                        colorUp: colorUp,
                                        colorDown: colorDown,)));

                              // You can use Navigator.push or any other navigation method here
                            },
                            child: Row(
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
                                          fontSize: 20),
                                    ),
                                    SizedBox(height: 3),
                                    Text(
                                      '${sampleAirData.smoke!}',
                                      style: TextStyle(
                                          color: Colors.white,
                                          fontWeight: FontWeight.w700,
                                          fontSize: 20),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                          // Display min temperature
                          GestureDetector(
                            onTap: () {
                              // Navigate to detail screen
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => DetailScreen(
                                          parameterName: 'CO2',
                                          parameterValue: 66,
                                          predictedValue: 0,
                                          speedValue: 66,
                                        colorUp: colorUp,
                                        colorDown: colorDown,)));

                              // You can use Navigator.push or any other navigation method here
                            },
                            child: Row(
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
                                          fontSize: 20),
                                    ),
                                    SizedBox(height: 3),
                                    Text(
                                      '${sampleAirData.co2!}',
                                      style: TextStyle(
                                          color: Colors.white,
                                          fontWeight: FontWeight.w700,
                                          fontSize: 20),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),

                      SizedBox(height: 30),
                      // Sliding switch for weather and air condition
                      Align(
                        alignment: FractionalOffset.bottomCenter,
                        child: Center(
                          child: SlidingSwitch(
                            value: true,
                            width: 250,
                            onChanged: (bool value) {
                              print(value);
                            },
                            height: 35,
                            animationDuration:
                            const Duration(milliseconds: 400),
                            onTap: () {
                              Navigator.pop(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => HomeScreen()));
                            },
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
                    ],
                  ),
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
  final double? NH2;
  final double? smoke;
  final double? co2;
  /*final String parameterName;
  final String parameterValue;
  final String predictedValue;
  final double speedValue;*/

  SampleAirData({
    this.dust,
    this.lpg,
    this.naturalGas,
    this.NH2,
    this.smoke,
    this.co2,
    /* required this.parameterName,
    required this.parameterValue,
    required this.predictedValue,
    required this.speedValue,*/
  });
}
