import 'dart:ui';
import 'package:firebase_database/firebase_database.dart';
import 'package:kdgaugeview/kdgaugeview.dart';
import 'package:sliding_switch/sliding_switch.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'home_screen.dart';
import 'outdoor_screen.dart';
import 'package:flutter/cupertino.dart';
import 'package:geolocator/geolocator.dart';

class AirConditionScreen extends StatefulWidget {
  final Color colorUp;
  final Color colorDown;
  final Position position;
  const AirConditionScreen({
    Key? key,
    required this.colorUp,
    required this.colorDown,
    required this.position,
  }) : super(key: key);
  @override
  _AirConditionScreenState createState() => _AirConditionScreenState();
}

class _AirConditionScreenState extends State<AirConditionScreen> {
  late final stream = FirebaseDatabase.instance.ref('sensor_data').onValue;


  @override
  void initState() {
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
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
      body: StreamBuilder(
        stream: stream,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            final data = snapshot.data?.snapshot.value as Map?;
            if (data == null) {
              return const Text('No data');
            }
            final dust = data['dust'];
            final humidity = data['humidity'];
            final mq135 = data['mq135'];
            final mq5 = data['mq5'];
            final mq7 = data['mq7'];
            final temperature = data['temperature'];
    return Padding(
    padding: const EdgeInsets.fromLTRB(40, 1.2 * kToolbarHeight, 40, 20),
    child: SizedBox(
    height: MediaQuery
        .of(context)
        .size
        .height,
    child: Stack(
    children: [
    Align(
    alignment: const AlignmentDirectional(3, -0.3),
    child: Container(
    height: 300,
    width: 300,
    decoration: BoxDecoration(
    shape: BoxShape.circle,
    color: widget.colorDown,
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
    color: widget.colorDown,
    ),
    ),
    ),
    Align(
    alignment: const AlignmentDirectional(0, -1.2),
    child: Container(
    height: 300,
    width: 600,
    decoration: BoxDecoration(
    color: widget.colorUp,
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
    child: Container(
    width: MediaQuery
        .of(context)
        .size
        .width,
    height: 850,
    child: Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
    const SizedBox(
    height: 8,
    ),

    const Center(
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
    Center(
      child:
    Container(
    width: 320,
    height: 300,
    child: Center(
    child: KdGaugeView(
    minSpeed: 0,
    maxSpeed: 200,
    speed: dust.toDouble(),
    animate: true,
    duration: const Duration(seconds: 5),
    alertSpeedArray: const[50, 100, 150, 200],
    alertColorArray: const [
    Colors.green,
    Colors.yellow,
    Colors.orange,
    Colors.red
    ],
    unitOfMeasurement: "Dust",
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
    ),

    Center(
    child: ElevatedButton(
    onPressed: () {
    Navigator.push(
    context,
    MaterialPageRoute(
    builder: (context) =>
    OutdoorScreen(position: widget.position, colorUp: widget.colorUp,
    colorDown: widget.colorDown,)),
    );
    },
    style: ElevatedButton.styleFrom(
    backgroundColor: const Color.fromARGB(
    43, 204, 203, 203),
    minimumSize: const Size(150, 50), // Button size
    padding: const EdgeInsets.symmetric(
    horizontal: 16), // Button padding
    shape: RoundedRectangleBorder(
    borderRadius: BorderRadius.circular(
    30), // Button border radius
    ),
    ),
    child: const Text(
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
    Row(
    children: [
    const Icon(
    Icons.wb_sunny_outlined,
    color: Colors.white,
    size: 35,
    ),
    const SizedBox(width: 5),
    Column(
    crossAxisAlignment: CrossAxisAlignment
        .start,
    children: [
    const Text(
    'Temp',
    style: TextStyle(
    color: Colors.white,
    fontSize: 20,
    fontWeight: FontWeight.w300,
    ),
    ),
    const SizedBox(height: 1),
    Text(
    '${temperature!.toStringAsFixed(0)}',
    style: const TextStyle(
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
    const Icon(
    CupertinoIcons.flame,
    color: Colors.white,
    size: 35,
    ),
    const SizedBox(width: 8),
    Column(
    crossAxisAlignment: CrossAxisAlignment
        .start,
    children: [
    const Text(
    'LPG',
    style: TextStyle(
    color: Colors.white,
    fontWeight: FontWeight.w300,
    fontSize: 20,
    ),
    ),
    const SizedBox(height: 3),
    Text(
    '${mq5!}',
    style: const TextStyle(
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
    const Icon(
    Icons.cloud,
    color: Colors.white,
    size: 35,
    ),
    const SizedBox(width: 5),
    Column(
    crossAxisAlignment: CrossAxisAlignment
        .start,
    children: [
    const Text(
    'Natural Gas',
    style: TextStyle(
    color: Colors.white,
    fontWeight: FontWeight.w300,
    fontSize: 20,
    ),
    ),
    const SizedBox(height: 8),
    Text(
    '${mq135!}',
    style:const TextStyle(
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
    const Icon(
    Icons.dehaze,
    color: Colors.white,
    size: 35,
    ),
    const SizedBox(width: 8),
    Column(
    crossAxisAlignment: CrossAxisAlignment
        .start,
    children: [
    const Text(
    'Dust',
    style: TextStyle(
    color: Colors.white,
    fontWeight: FontWeight.w300,
    fontSize: 20,
    ),
    ),
    const SizedBox(height: 3),
    Text(
    '${dust!}',
    style: const TextStyle(
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
    const Icon(
    Icons.thermostat,
    color: Colors.white,
    size: 35,
    ),
    const SizedBox(width: 5),
    Column(
    crossAxisAlignment: CrossAxisAlignment
        .start,
    children: [
    const Text(
    'Humidity',
    style: TextStyle(
    color: Colors.white,
    fontWeight: FontWeight.w300,
    fontSize: 20),
    ),
    const SizedBox(height: 3),
    Text(
    '${humidity!}',
    style: const TextStyle(
    color: Colors.white,
    fontWeight: FontWeight.w700,
    fontSize: 20),
    ),
    ],
    ),
    ],
    ),
    // Display min temperature
    Row(
    children: [
    const Icon(
    Icons.science,
    color: Colors.white,
    size: 35,
    ),
    const SizedBox(width: 5),
    Column(
    crossAxisAlignment: CrossAxisAlignment
        .start,
    children: [
    const Text(
    'CO',
    style: TextStyle(
    color: Colors.white,
    fontWeight: FontWeight.w300,
    fontSize: 20),
    ),
    const SizedBox(height: 3),
    Text(
    '${mq7!}',
    style: const TextStyle(
    color: Colors.white,
    fontWeight: FontWeight.w700,
    fontSize: 20),
    ),
    ],
    ),
    ],
    ),
    ],
    ),

    const SizedBox(height: 30),
    // Sliding switch for weather and air condition
    Align(
    alignment: FractionalOffset.bottomCenter,
    child: Center(
    child: SlidingSwitch(
    value: true,
    width: 250,
    onChanged: (bool value) {
    },
    height: 35,
    animationDuration:
    const Duration(milliseconds: 400),
    onTap: () {
    Navigator.pop(
    context,
    MaterialPageRoute(
    builder: (context) => HomeScreen(position: widget.position,)));
    },
    onDoubleTap: () {},
    onSwipe: () {},
    textOff: "Weather",
    textOn: "Air Condition",
    colorOn: const Color(0xffdc6c73),
    colorOff: const Color(0xff6682c0),
    background: const Color.fromARGB(43, 204, 203, 203),
    buttonColor: const Color.fromARGB(42, 247, 245, 247),
    inactiveColor: const Color(0xff636f7b),
    ),
    ),
    ),
    ],
    ),
    ),
    ),
    ]
    ),
    ),
    );
          }
          if (snapshot.hasError) {
            return Text(snapshot.error.toString());
          }
          return const Text('....');
        },
      )
    );}}

class SampleAirData {
  final double? dust;
  final double? lpg;
  final double? naturalGas;
  final double? nh2;
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
    this.nh2,
    this.smoke,
    this.co2,
    /* required this.parameterName,
    required this.parameterValue,
    required this.predictedValue,
    required this.speedValue,*/
  });
}
