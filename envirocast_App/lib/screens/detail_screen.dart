import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:lottie/lottie.dart';
import 'package:kdgaugeview/kdgaugeview.dart';
import 'package:intl/intl.dart'; // Import the intl package

class DetailScreen extends StatelessWidget {
  final String parameterName;
  final List<dynamic> parameterData;
  final double parameterValue;
  final double predictedValue;
  final double speedValue;
  final Color colorUp;
  final Color colorDown;

  const DetailScreen({
    Key? key,
    required this.parameterName,
    required this.parameterData,
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
    } else if (speedValue < 150) {
      return Colors.orange; // Unhealthy
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
    } else {
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
    } else {
      return 'assets/Poor.json';
    }
  }

  IconData getIconData() {
    final color = getGaugeColor();
    if (color == Colors.green) {
      return Icons.sentiment_very_satisfied_outlined; // Good
    } else if (color == Colors.yellow) {
      return Icons.sentiment_satisfied_alt_outlined; // Moderate
    } else if (color == Colors.orange) {
      return Icons.sentiment_neutral_outlined; // Unhealthy
    } else {
      return Icons.sentiment_very_dissatisfied_outlined; // Poor
    }
  }

  @override
  Widget build(BuildContext context) {
    // Ensure parameterData is cast to List<double>
    final List<double> forecastValues = parameterData.map((e) => (e as num).toDouble()).toList();

    final List<PollutantData> forecastData = List.generate(
      168, // 7 days * 24 hours
          (index) => PollutantData(
        dateTime: DateTime.now().add(Duration(hours: index)),
        value: forecastValues[index % forecastValues.length], // Use modulo to prevent out-of-range error
      ),
    );

    final gaugeColor = getGaugeColor();
    final conditionText = getConditionText();
    final conditionFace = getConditionFace();

    return Scaffold(
      backgroundColor: Colors.black,
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        systemOverlayStyle: const SystemUiOverlayStyle(
          statusBarBrightness: Brightness.dark,
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.fromLTRB(40, 1.2 * kToolbarHeight, 40, 20),
        child: SizedBox(
          height: MediaQuery.of(context).size.height,
          child: Stack(
            children: [
              Align(
                alignment: const AlignmentDirectional(3, -0.3),
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
                alignment: const AlignmentDirectional(-3, -0.3),
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
                alignment: const AlignmentDirectional(0, -1.2),
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
                  decoration: const BoxDecoration(color: Colors.transparent),
                ),
              ),
              SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(
                      height: 8,
                    ),
                    const Center(
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
                        conditionFace,
                      ),
                    ),
                    ///////////**********Attributes************//////////
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              parameterName,
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 1),
                            Text(
                              '$parameterValue',
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 20,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            // to print the Good Moderate... with color
                            const SizedBox(height: 1),
                            Text(
                              conditionText,
                              style: TextStyle(
                                color: gaugeColor,
                                fontSize: 25,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 1),
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
                            duration: const Duration(seconds: 5),
                            alertSpeedArray: const [0, 50, 100, 150],
                            alertColorArray: const [
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
                    const SizedBox(height: 6),
                    ListView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(), // Prevent inner scrolling
                      itemCount: forecastData.length,
                      itemBuilder: (context, index) {
                        final data = forecastData[index];
                        final formattedDate = DateFormat('hh:mm a, dd/MM').format(data.dateTime); // Format date and time
                        return Card(
                          margin: const EdgeInsets.all(8.0),
                          child: ListTile(
                            title: Text(formattedDate),
                            subtitle: Text(
                              'Pollutant Value: ${data.value.toStringAsFixed(2)}',
                            ),
                          ),
                        );
                      },
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

class PollutantData {
  final DateTime dateTime;
  final double value;

  PollutantData({required this.dateTime, required this.value});
}
