import 'dart:ui';
import 'package:envirocast/screens/detail_screen.dart';
import 'package:kdgaugeview/kdgaugeview.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'forecasting_screen.dart';
import 'home_screen.dart';
import 'package:flutter/cupertino.dart';

class OutdoorScreen extends StatelessWidget {
  final Color colorUp;
  final Color colorDown;
  const OutdoorScreen({
    Key? key,
    required this.colorUp,
    required this.colorDown,}) : super(key: key);

  @override
  Widget build(BuildContext context) {

    final sampleAirData = SampleAirData(
      temp: 1.0,
      aqi: 1.0,
      Co: 1.0,
      NO2: 1.0,
      O3: 2.0,
      So2: 2.0,
      PM2: 1.0,
      PM10: 1.0,
      predTemp: 1.5,
      predAqi: 1.3,
      predCo: 1.0,
      predNO2: 1.0,
      predO3: 1.0,
      predSo2: 1.0,
      predPM2: 2.0,
      predPM10: 2.0,
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
                  height: 990,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(
                        height: 8,
                      ),
                      Center(
                        child: Text(
                          'Outdoor Air Data',
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
                            speed: 49,
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
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => ForecastScreen(colorUp: colorUp,
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
                            'Forecast',
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
                                          parameterName: 'Temperature',
                                          parameterValue: 16,
                                          predictedValue: 10,
                                          speedValue: 45,
                                        colorUp: colorUp,
                                        colorDown: colorDown,)));

                              // You can use Navigator.push or any other navigation method here
                            },
                            child: Row(
                              children: [
                                Icon(
                                  CupertinoIcons.thermometer,
                                  color: Colors.white,
                                  size: 35,
                                ),
                                SizedBox(width: 5),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      'Temperature',
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 20,
                                        fontWeight: FontWeight.w300,
                                      ),
                                    ),
                                    SizedBox(height: 1),
                                    Text(
                                      '${sampleAirData.temp!}',
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 20,
                                        fontWeight: FontWeight.w700,
                                      ),
                                    ),
                                    Text(
                                      'Exp_1h: ${sampleAirData.predTemp!}',
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 20,
                                        fontWeight: FontWeight.w300,
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
                                          parameterName: 'AQI',
                                          parameterValue: 1.0,
                                          predictedValue: 20,
                                          speedValue: 145,
                                        colorUp: colorUp,
                                        colorDown: colorDown,)));

                              // You can use Navigator.push or any other navigation method here
                            },
                            child: Row(
                              children: [
                                Icon(
                                  CupertinoIcons.wind,
                                  color: Colors.white,
                                  size: 35,
                                ),
                                SizedBox(width: 8),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      'AQI',
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontWeight: FontWeight.w300,
                                        fontSize: 20,
                                      ),
                                    ),
                                    SizedBox(height: 3),
                                    Text(
                                      '${sampleAirData.aqi!}',
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontWeight: FontWeight.w700,
                                        fontSize: 20,
                                      ),
                                    ),
                                    Text(
                                      'Exp_1h: ${sampleAirData.predAqi!}',
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 20,
                                        fontWeight: FontWeight.w300,
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
                                          parameterName: 'CO',
                                          parameterValue: 1.6,
                                          predictedValue: 10,
                                          speedValue: 101,
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
                                SizedBox(width: 5),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      'CO',
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontWeight: FontWeight.w300,
                                        fontSize: 20,
                                      ),
                                    ),
                                    SizedBox(height: 8),
                                    Text(
                                      '${sampleAirData.Co!}',
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontWeight: FontWeight.w700,
                                        fontSize: 20,
                                      ),
                                    ),
                                    SizedBox(height: 1),
                                    Text(
                                      'Exp_1h: ${sampleAirData.predCo!}',
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 20,
                                        fontWeight: FontWeight.w300,
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
                                          parameterName: 'NO2',
                                          parameterValue: 2.1,
                                          predictedValue: 30,
                                          speedValue: 200,
                                        colorUp: colorUp,
                                        colorDown: colorDown,)));

                              // You can use Navigator.push or any other navigation method here
                            },
                            child: Row(
                              children: [
                                Icon(
                                  CupertinoIcons.gauge,
                                  color: Colors.white,
                                  size: 35,
                                ),
                                SizedBox(width: 8),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      'NO2',
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontWeight: FontWeight.w300,
                                        fontSize: 20,
                                      ),
                                    ),
                                    SizedBox(height: 3),
                                    Text(
                                      '${sampleAirData.NO2!}',
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontWeight: FontWeight.w700,
                                        fontSize: 20,
                                      ),
                                    ),
                                    Text(
                                      'Exp_1h: ${sampleAirData.predNO2!}',
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 20,
                                        fontWeight: FontWeight.w300,
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
                                          parameterName: 'O3',
                                          parameterValue: 1.2,
                                          predictedValue: 10,
                                          speedValue: 45,
                                        colorUp: colorUp,
                                        colorDown: colorDown,)));

                              // You can use Navigator.push or any other navigation method here
                            },
                            child: Row(
                              children: [
                                Icon(
                                  CupertinoIcons.cloud,
                                  color: Colors.white,
                                  size: 35,
                                ),
                                SizedBox(width: 5),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      'O3',
                                      style: TextStyle(
                                          color: Colors.white,
                                          fontWeight: FontWeight.w300,
                                          fontSize: 20),
                                    ),
                                    SizedBox(height: 3),
                                    Text(
                                      '${sampleAirData.O3!}',
                                      style: TextStyle(
                                          color: Colors.white,
                                          fontWeight: FontWeight.w700,
                                          fontSize: 20),
                                    ),
                                    Text(
                                      'Exp_1h: ${sampleAirData.predO3!}',
                                      style: TextStyle(
                                          color: Colors.white,
                                          fontWeight: FontWeight.w300,
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
                                          parameterName: 'SO2',
                                          parameterValue: 2.5,
                                          predictedValue: 20,
                                          speedValue: 120,
                                        colorUp: colorUp,
                                        colorDown: colorDown,)));

                              // You can use Navigator.push or any other navigation method here
                            },
                            child: Row(
                              children: [
                                Icon(
                                  Icons.fire_extinguisher,
                                  color: Colors.white,
                                  size: 35,
                                ),
                                SizedBox(width: 5),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      'SO2',
                                      style: TextStyle(
                                          color: Colors.white,
                                          fontWeight: FontWeight.w300,
                                          fontSize: 20),
                                    ),
                                    SizedBox(height: 3),
                                    Text(
                                      '${sampleAirData.So2!}',
                                      style: TextStyle(
                                          color: Colors.white,
                                          fontWeight: FontWeight.w700,
                                          fontSize: 20),
                                    ),
                                    Text(
                                      'Exp_1h: ${sampleAirData.predSo2!}',
                                      style: TextStyle(
                                          color: Colors.white,
                                          fontWeight: FontWeight.w300,
                                          fontSize: 20),
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
                                          parameterName: 'PM2',
                                          parameterValue: 2.3,
                                          predictedValue: 10,
                                          speedValue: 65,
                                        colorUp: colorUp,
                                        colorDown: colorDown,)));

                              // You can use Navigator.push or any other navigation method here
                            },
                            child: Row(
                              children: [
                                Icon(
                                  CupertinoIcons.flame_fill,
                                  color: Colors.white,
                                  size: 35,
                                ),
                                SizedBox(width: 5),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      'PM2',
                                      style: TextStyle(
                                          color: Colors.white,
                                          fontWeight: FontWeight.w300,
                                          fontSize: 20),
                                    ),
                                    SizedBox(height: 3),
                                    Text(
                                      '${sampleAirData.PM2!}',
                                      style: TextStyle(
                                          color: Colors.white,
                                          fontWeight: FontWeight.w700,
                                          fontSize: 20),
                                    ),
                                    Text(
                                      'Exp_1h: ${sampleAirData.predPM2!}',
                                      style: TextStyle(
                                          color: Colors.white,
                                          fontWeight: FontWeight.w300,
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
                                          parameterName: 'PM10',
                                          parameterValue: 1.5,
                                          predictedValue: 30,
                                          speedValue: 75,
                                        colorUp: colorUp,
                                        colorDown: colorDown,)));

                              // You can use Navigator.push or any other navigation method here
                            },
                            child: Row(
                              children: [
                                Icon(
                                  CupertinoIcons.waveform_path,
                                  color: Colors.white,
                                  size: 35,
                                ),
                                SizedBox(width: 5),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      'PM10',
                                      style: TextStyle(
                                          color: Colors.white,
                                          fontWeight: FontWeight.w300,
                                          fontSize: 20),
                                    ),
                                    SizedBox(height: 3),
                                    Text(
                                      '${sampleAirData.PM10!}',
                                      style: TextStyle(
                                          color: Colors.white,
                                          fontWeight: FontWeight.w700,
                                          fontSize: 20),
                                    ),
                                    Text(
                                      'Exp_1h: ${sampleAirData.predPM10!}',
                                      style: TextStyle(
                                          color: Colors.white,
                                          fontWeight: FontWeight.w300,
                                          fontSize: 20),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 6),
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
  final double? temp;
  final double? aqi;
  final double? Co;
  final double? NO2;
  final double? O3;
  final double? So2;
  final double? PM2;
  final double? PM10;
  final double? predTemp;
  final double? predAqi;
  final double? predCo;
  final double? predNO2;
  final double? predO3;
  final double? predSo2;
  final double? predPM2;
  final double? predPM10;

  SampleAirData({
    this.temp,
    this.aqi,
    this.Co,
    this.NO2,
    this.O3,
    this.So2,
    this.PM2,
    this.PM10,
    this.predTemp,
    this.predAqi,
    this.predCo,
    this.predNO2,
    this.predO3,
    this.predSo2,
    this.predPM2,
    this.predPM10,
  });
}
