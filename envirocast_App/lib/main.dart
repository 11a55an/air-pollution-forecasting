import 'package:envirocast/screens/air_condition_screen.dart';
import 'package:envirocast/screens/splash_screen.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:envirocast/bloc/weather_bloc_bloc.dart';
import 'package:envirocast/screens/home_screen.dart';
import 'package:geolocator/geolocator.dart';

void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  if (kIsWeb){
    await Firebase.initializeApp(options: FirebaseOptions(
        apiKey: "AIzaSyAmP9IpsbyS5ww6ABJgCpKmPFDafNXvNuk",
        authDomain: "aqi-testing3.firebaseapp.com",
        databaseURL: "https://aqi-testing3-default-rtdb.europe-west1.firebasedatabase.app",
        projectId: "aqi-testing3",
        storageBucket: "aqi-testing3.appspot.com",
        messagingSenderId: "1045067506323",
        appId: "1:1045067506323:web:b09e90a2cf62fb33b66366"
    ));
  }
  else{
    await Firebase.initializeApp();
  }

  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: SplashScreen(),

    );
  }
}
