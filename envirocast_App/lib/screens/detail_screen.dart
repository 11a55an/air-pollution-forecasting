import 'dart:ui';
import 'package:kdgaugeview/kdgaugeview.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/cupertino.dart';
import 'package:intl/intl.dart';
import 'package:lottie/lottie.dart';

import 'home_screen.dart';

class DetailScreen extends StatelessWidget {
  final String parameterName;
  final double parameterValue;
  final double predictedValue;
  final double speedValue;
  final Color colorUp;
  final Color colorDown;

  const DetailScreen({
    Key? key,
    required this.parameterName,
    required this.parameterValue,
    required this.predictedValue,
    required this.speedValue,
    required this.colorUp,
    required this.colorDown,
  }) : super(key: key);

  Color getGaugeColor() {
    if (speedValue < 50) {
      return Colors.green; // Good
    } else if (speedValue < 100) {
      return Colors.yellow; // Moderate
    }else if (speedValue < 150) {
      return Colors.orange; // Moderate
    } else {
      return Colors.red; // Poor
    }
  }

  String getConditionText() {
    final color = getGaugeColor();
    if (color == Colors.green) {
      return "Good";
    } else if (color == Colors.yellow) {
      return "Moderate";
    } else if (color == Colors.orange) {
      return "Unhealthy";
    }else {
      return "Poor";
    }
  }
  String getConditionFace() {
    final color = getGaugeColor();
    if (color == Colors.green) {
      return 'assets/happy.json';
    } else if (color == Colors.yellow) {
      return 'assets/Moderate.json';
    } else if (color == Colors.orange) {
      return 'assets/Unhealthy.json';
    }else {
      return'assets/Poor.json';
    }
  }

  IconData getIconData() {
    final color = getGaugeColor();
    if (color == Colors.green) {
      return Icons.sentiment_very_satisfied_outlined; // Good
    } else if (color == Colors.yellow) {
      return Icons.sentiment_satisfied_alt_outlined; // Moderate
    } else if (color == Colors.orange) {
      return Icons.sentiment_neutral_outlined; // Moderate
    }else {
      return Icons.sentiment_very_dissatisfied_outlined; // Poor
    }
  }

  @override
  Widget build(BuildContext context) {

    final gaugeColor = getGaugeColor();
    final conditionText = getConditionText();
    final iconData = getIconData();
    final conditionFace = getConditionFace();



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
              Container(
                height: MediaQuery.of(context).size.height,
                child: SingleChildScrollView(
                  child: Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(
                          height: 8,
                        ),
                        Center(
                          child: Text(
                            'Detail',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 35,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                    Transform.scale(
                      scale: 0.8, // Adjust the scale factor as needed
                      child: Lottie.asset(

                        conditionFace,),
                    ),


                        ///////////**********Attributes************//////////
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  '$parameterName',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                SizedBox(height: 1),
                                Text(
                                  '$parameterValue',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 20,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),                                 // to print the Good Moderate... with color
                                SizedBox(height: 1),
                                Text(conditionText,
                                  style: TextStyle(
                                    color: gaugeColor,
                                    fontSize: 25,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                SizedBox(height: 1),

                                Icon(
                                  iconData,
                                  color: Colors.white,
                                  size: 35,
                                ),
                                predictedValue != 0 ? Text(  // Condition
                                  "Exp_1h: $predictedValue",
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 20,
                                  ),
                                ) : SizedBox(),

                              ],
                            ),

                            // KdGauge
                            Container(
                              width: 190,
                              height: 150,
                              child: KdGaugeView(
                                minSpeed: 0,
                                maxSpeed: 200,
                                speed: speedValue,
                                animate: true,
                                duration: Duration(seconds: 5),
                                alertSpeedArray: [0, 50, 100, 150],
                                alertColorArray: [
                                  Colors.green,
                                  Colors.yellow,
                                  Colors.orange,
                                  Colors.red
                                ],
                                unitOfMeasurement: "ppm",
                                gaugeWidth: 10,
                                minMaxTextStyle: const TextStyle(
                                    color: Colors.white, fontSize: 15),
                                unitOfMeasurementTextStyle: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold),
                                speedTextStyle: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 25,
                                    fontWeight: FontWeight.bold),
                                divisionCircleColors: Colors.purpleAccent,
                                innerCirclePadding: 20,
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


                        ///////////**********Good************//////////
                        //SizedBox(width: 5),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              'Good: ',
                              style: TextStyle(
                                color: Colors.green,
                                fontSize: 20,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                            Flexible( // Wrap the second Text widget with Flexible
                              child: Text(
                                'The air is fresh and free from toxins.',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 20,
                                  fontWeight: FontWeight.w300,
                                ),
                                maxLines: 5, // Show at most 2 lines
                                overflow: TextOverflow.ellipsis,
                                textAlign: TextAlign.justify,

                              ),
                            ),
                          ],
                        ),
                        ///////////**********Moderate************//////////
                        SizedBox(height: 6),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              'Moderate: ',
                              style: TextStyle(
                                color: Colors.yellow,
                                fontSize: 20,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                            SizedBox(height: 5),
                            Flexible(
                              child: Text(
                                'Acceptable air quality for healthy adults but mild threat to sensitive individuals.',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 20,
                                  fontWeight: FontWeight.w300,
                                ),
                                maxLines: 5, // Show at most 2 lines
                                overflow: TextOverflow.ellipsis,
                                textAlign: TextAlign.justify,
                              ),)
                          ],
                        ),

                        ///////////**********Unhealthy************//////////

                        SizedBox(height: 6),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              'Unhealthy: ',
                              style: TextStyle(
                                color: Colors.orange,
                                fontSize: 20,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                            SizedBox(height: 5),
                            Flexible(
                              child: Text(
                                'This could be harmful for children and elderly ',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 20,
                                  fontWeight: FontWeight.w300,
                                ),
                                maxLines: 5, // Show at most 2 lines
                                overflow: TextOverflow.ellipsis,
                                textAlign: TextAlign.justify,
                              ),)
                          ],
                        ),

                        ///////////**********Poor************//////////
                        SizedBox(height: 6),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              'Poor: ',
                              style: TextStyle(
                                color: Colors.red,
                                fontSize: 20,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                            SizedBox(height: 5),
                            Flexible(
                              child: Text(
                                'Beware! Your Life is in danger. Prolonged exposure can lead to premature death.',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 20,
                                  fontWeight: FontWeight.w300,
                                ),
                                maxLines: 5, // Show at most 2 lines
                                overflow: TextOverflow.ellipsis,
                                textAlign: TextAlign.justify,
                              ),)
                          ],
                        ),


                        SizedBox(height: 6),
                        SizedBox(height: 6),

                        Center(
                          child: Text(
                            'Chart',
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
                        Image.asset('assets/Chart.png'),
                        SizedBox(height: 8), // Add some space between the image and the text
                        Text(
                          'Differences in January-April emissions',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),


                      ],
                    ),
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

