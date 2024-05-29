import 'dart:ui';
import 'package:envirocast/screens/detail_screen.dart';
import 'package:kdgaugeview/kdgaugeview.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'forecasting_screen.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/cupertino.dart';
import 'package:intl/intl.dart';

class OutdoorScreen extends StatelessWidget {
  final Color colorUp;
  final Color colorDown;
  const OutdoorScreen({
    Key? key,
    required this.colorUp,
    required this.colorDown,}) : super(key: key);

  Future<Map<String, dynamic>> fetchAirData() async {
    final response = await http.get(Uri.parse('https://api.weatherbit.io/v2.0/history/airquality?city=Gujrat&tz=local&key=42439ec554bf49f7b59e4e0f08f45c9f'));
    final responsePred = await http.post(Uri.parse('http://ec2-16-16-98-137.eu-north-1.compute.amazonaws.com:8080/all'));
    print(responsePred.body);
    // Get today's date
    DateTime startDate = DateTime.now();

    // Get yesterday's date
    DateTime endDate = startDate.add(Duration(days: 1));

    // Format dates to 'YYYY-MM-DD'
    String formattedEndDate = DateFormat('yyyy-MM-dd').format(endDate);
    String formattedStartDate = DateFormat('yyyy-MM-dd').format(startDate);

    // Construct the URL with query parameters
    String url = 'https://api.weatherbit.io/v2.0/history/hourly?city=Gujrat&tz=local&start_date=$formattedStartDate&end_date=$formattedEndDate&key=42439ec554bf49f7b59e4e0f08f45c9f';

    // Make the HTTP GET request
    final responseTemp = await http.get(Uri.parse(url));

    if (response.statusCode == 200 && responseTemp.statusCode == 200 && responsePred.statusCode == 200) {
      Map<String, dynamic> airData = jsonDecode(response.body);
      Map<String, dynamic> predData = jsonDecode(responsePred.body);
      Map<String, dynamic> weatherData = jsonDecode(responseTemp.body);

      return {
        'airData': SampleAirData.fromJson(airData),
        'weatherData': SampleWeatherData.fromJson(weatherData),
        'predData': SamplePredData.fromJson(predData),
      };
    } else {
      throw Exception('Failed to load air or weather data');
    }
  }

  @override
  Widget build(BuildContext context) {

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
      body:SafeArea(
    child: FutureBuilder<Map<String, dynamic>>(
    future: fetchAirData(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else {
            SampleAirData sampleAirData = snapshot.data!['airData'];
            SampleWeatherData sampleWeatherData = snapshot.data!['weatherData'];
            SamplePredData samplePredData = snapshot.data!['predData'];


            return Padding(
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
    fontWeight: FontWeight.w700,
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
    maxSpeed: 500,
    speed: sampleAirData.aqi,
    animate: true,
    duration: Duration(seconds: 5),
    alertSpeedArray: [100, 200, 300, 400],
    alertColorArray: [
    Colors.green,
    Colors.yellow,
    Colors.orange,
    Colors.red
    ],
    unitOfMeasurement: "AQI",
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
    'Temp',
    style: TextStyle(
    color: Colors.white,
    fontSize: 20,
    fontWeight: FontWeight.w300,
    ),
    ),
    SizedBox(height: 1),
    Text(
      '${sampleWeatherData.temp!.toStringAsFixed(0)}°C',
    style: TextStyle(
    color: Colors.white,
    fontSize: 20,
    fontWeight: FontWeight.w700,
    ),
    ),
    Text(
    'Exp_1h: ${samplePredData.temp[0]!.toStringAsFixed(0)}',
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
    '${sampleAirData.aqi!.toStringAsFixed(0)}',
    style: TextStyle(
    color: Colors.white,
    fontWeight: FontWeight.w700,
    fontSize: 20,
    ),
    ),
    Text(
    'Exp_1h: ${samplePredData.aqi[0]!.toStringAsFixed(0)}',
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
    '${sampleAirData.Co!.toStringAsFixed(0)}',
    style: TextStyle(
    color: Colors.white,
    fontWeight: FontWeight.w700,
    fontSize: 20,
    ),
    ),
    SizedBox(height: 1),
    Text(
    'Exp_1h: ${samplePredData.Co[0]!.toStringAsFixed(0)}',
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
    '${sampleAirData.NO2!.toStringAsFixed(0)}',
    style: TextStyle(
    color: Colors.white,
    fontWeight: FontWeight.w700,
    fontSize: 20,
    ),
    ),
    Text(
    'Exp_1h: ${samplePredData.NO2[0]!.toStringAsFixed(0)}',
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
    '${sampleAirData.O3!.toStringAsFixed(0)}',
    style: TextStyle(
    color: Colors.white,
    fontWeight: FontWeight.w700,
    fontSize: 20),
    ),
    Text(
    'Exp_1h: ${samplePredData.O3[0]!.toStringAsFixed(0)}',
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
    '${sampleAirData.So2!.toStringAsFixed(0)}',
    style: TextStyle(
    color: Colors.white,
    fontWeight: FontWeight.w700,
    fontSize: 20),
    ),
    Text(
    'Exp_1h: ${samplePredData.So2[0]!.toStringAsFixed(0)}',
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
    'Exp_1h: ${samplePredData.PM2[0]!.toStringAsFixed(0)}',
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
    'Exp_1h: ${samplePredData.PM10[0]!.toStringAsFixed(0)}',
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
    );
    }
    }
    )
    )
    );
  }
}

class SampleAirData {
  final dynamic aqi;
  final dynamic Co;
  final dynamic NO2;
  final dynamic O3;
  final dynamic So2;
  final dynamic PM2;
  final dynamic PM10;

  SampleAirData({
    this.aqi,
    this.Co,
    this.NO2,
    this.O3,
    this.So2,
    this.PM2,
    this.PM10,
  });
  
  

  factory SampleAirData.fromJson(Map<String, dynamic> json) {
    return SampleAirData(
      aqi: json['data'][0]['aqi'],
      Co: json['data'][0]['co'],
      NO2: json['data'][0]['no2'],
      O3: json['data'][0]['o3'],
      So2: json['data'][0]['so2'],
      PM2: json['data'][0]['pm25'],
      PM10: json['data'][0]['pm10'],
    );
  }
}

class SampleWeatherData {
  final dynamic temp;

  SampleWeatherData({
    this.temp
  });

  factory SampleWeatherData.fromJson(Map<String, dynamic> json) {
    // Get the last non-null temperature value
    List<dynamic> weatherDataList = json['data'];
    double temp1 = 0;
    for (var item in weatherDataList.reversed) {
      if (item['temp'] != null) {
        temp1 = item['temp'];
        break;
      }
    }
    return SampleWeatherData(
      temp: temp1
    );
  }
}

class SamplePredData {
  final dynamic temp;
  final dynamic aqi;
  final dynamic Co;
  final dynamic NO2;
  final dynamic O3;
  final dynamic So2;
  final dynamic PM2;
  final dynamic PM10;

  SamplePredData({
    this.temp,
    this.aqi,
    this.Co,
    this.NO2,
    this.O3,
    this.So2,
    this.PM2,
    this.PM10,
  });

  factory SamplePredData.fromJson(Map<String, dynamic> json) {
    return SamplePredData(
      temp: json['temp'],
      aqi: json['aqi'],
      Co: json['co'],
      NO2: json['no2'],
      O3: json['o3'],
      So2: json['so2'],
      PM2: json['pm25'],
      PM10: json['pm10'],
    );
  }
}
