import 'package:envirocast/screens/splash_screen.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

void main() async{
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(options: const FirebaseOptions(
      apiKey: "AIzaSyAmP9IpsbyS5ww6ABJgCpKmPFDafNXvNuk",
      authDomain: "aqi-testing3.firebaseapp.com",
      databaseURL: "https://aqi-testing3-default-rtdb.europe-west1.firebasedatabase.app",
      projectId: "aqi-testing3",
      storageBucket: "aqi-testing3.appspot.com",
      messagingSenderId: "1045067506323",
      appId: "1:1045067506323:web:b09e90a2cf62fb33b66366"
  ));
  

  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: SplashScreen(),

    );
  }
}
