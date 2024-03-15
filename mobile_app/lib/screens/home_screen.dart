import 'dart:ui';
import 'package:sliding_switch/sliding_switch.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({Key? key}) : super(key: key);

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

    // Sample weather data
    final sampleWeatherData = SampleWeatherData(
      weatherConditionCode: 800,
      temperature: 25.0,
      date: DateTime.now(),
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
            SizedBox(height: 8),
            Center(
              child:Text(
              greeting,
              style: TextStyle(
                color: Colors.white,
                fontSize: 25,
                fontWeight: FontWeight.bold,
              ),
            ),
            ),
            // Display weather icon
            Image.asset(
              'assets/1.png',
            ),
            Center(
              child: Text(
                '${sampleWeatherData.temperature!.round()}°C ',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 55,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
            Center(
              child: Text(
                DateFormat('EEEE dd - ')
                    .add_jm()
                    .format(sampleWeatherData.date!),
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                  fontWeight: FontWeight.w300,
                ),
              ),
            ),
            SizedBox(height: 30),
            // const Padding(
            //   padding: EdgeInsets.symmetric(vertical: 5.0),
            //   child: Divider(
            //     color: Colors.grey,
            //   ),
            // ),
            SizedBox(height: 6),
            Expanded(
              child: Align(
                alignment: FractionalOffset.bottomCenter,
                child: Center(
              child: SlidingSwitch(
                value: false,
                width: 250,
                onChanged: (bool value) {},
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
            )
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

class SampleWeatherData {
  final int? weatherConditionCode;
  final double? temperature;
  final DateTime? date;

  SampleWeatherData({
    this.weatherConditionCode,
    this.temperature,
    this.date,
  });
}
