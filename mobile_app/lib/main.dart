import 'package:flutter/material.dart';
import 'package:weather_app/screens/air_condition_screen.dart';
import 'package:weather_app/screens/home_screen.dart';

void main() {
  runApp( MyApp());
}

class MyApp extends StatelessWidget {
   MyApp({super.key});


  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home:
            Scaffold(
              body: Center(
                child: AirConditionScreen(),
              ),
            ),
    );
  }
}
