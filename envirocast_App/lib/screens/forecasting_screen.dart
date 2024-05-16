import 'dart:ui';
import 'package:lottie/lottie.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class ForecastScreen extends StatelessWidget {
  final Color colorUp;
  final Color colorDown;
  const ForecastScreen({
    Key? key,
    required this.colorUp,
    required this.colorDown,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {


    DateTime Now = DateTime.now(); // Get the current date and time
    int weekdayNumber = Now.weekday - 1; // Get the weekday number (0-6)
    print("Today is: $weekdayNumber");



    List<String> weekdays = [
      "Monday",
      "Tuesday",
      "Wednesday",
      "Thursday",
      "Friday",
      "Saturday",
      "Sunday"
    ];
    List<String> weather = [
      "snowy",
      "sunny",
      "thunder",
      "haze",
      "rain",
      "cloudysunny",
      "cloudy"
    ];
    List<double> Temp = [
      12,
      34,
      20,
      24,
      32,
      30,
      25,
    ];


    String today = weekdays[weekdayNumber];


    List<String> parameters = [
      " ",
      "Temp",
      "AQI",
      "CO",
      "NO2",
      "O3",
      "SO2",
      "PM2",
      "PM10"
    ];

    List<SampleAirData> airQualityData = [
      SampleAirData(
          weekday: "Mon",
          temp: 100,
          aqi: 150,
          Co: 1.0,
          NO2: 10,
          O3: 30,
          So2: 14,
          PM2: 26,
          PM10: 10),
      SampleAirData(
          weekday: "Tue",
          temp: 200,
          aqi: 250,
          Co: 1.2,
          NO2: 20,
          O3: 40,
          So2: 15,
          PM2: 40,
          PM10: 40),
      SampleAirData(
          weekday: "Wed",
          temp: 300,
          aqi: 350,
          Co: 2.0,
          NO2: 30,
          O3: 50,
          So2: 34,
          PM2: 26,
          PM10: 20),
      SampleAirData(
          weekday: "Thur",
          temp: 400,
          aqi: 450,
          Co: 2.3,
          NO2: 40,
          O3: 60,
          So2: 55,
          PM2: 30,
          PM10: 44),
      SampleAirData(
          weekday: "Fri",
          temp: 500,
          aqi: 550,
          Co: 1.4,
          NO2: 50,
          O3: 70,
          So2: 26,
          PM2: 27,
          PM10: 30),
      SampleAirData(
          weekday: "Sat",
          temp: 600,
          aqi: 650,
          Co: 2.0,
          NO2: 60,
          O3: 80,
          So2: 16,
          PM2: 15,
          PM10: 46),
      SampleAirData(
          weekday: "Sun",
          temp: 700,
          aqi: 750,
          Co: 1.9,
          NO2: 70,
          O3: 90,
          So2: 95,
          PM2: 20,
          PM10: 56),
    ];


    TextStyle colTitles = const TextStyle(
        fontStyle: FontStyle.italic,
        fontSize: 20,
        fontWeight: FontWeight.bold,
        color: Color(0xffa6e1f5));
    TextStyle rowTitles = const TextStyle(fontSize: 18, color: Colors.white);

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
                            'Forecasting',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 35,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                        SizedBox(
                          height: 25,
                        ),
                        ClipOval(
                          child: Lottie.asset(
                            'assets/girl.json',
                          ),
                        ),
                        const Padding(
                          padding: EdgeInsets.symmetric(vertical: 25.0),
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Text(
                              'Today',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                                fontSize: 24,
                              ),
                            ),
                            Text(
                              'Next 7 Days',
                              style: TextStyle(
                                  fontWeight: FontWeight.w600,
                                  fontSize: 18,
                                  color: Colors.cyan),
                            ),
                          ],
                        ),
                        Row(children: [
                          Text(
                            '${today}',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                              fontSize: 20,
                            ),
                          ),
                        ]),
                        const Padding(
                          padding: EdgeInsets.symmetric(vertical: 14.0),
                          child: Divider(
                            color: Colors.grey,
                          ),
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                        SingleChildScrollView(
                            scrollDirection: Axis.horizontal,
                            child: DataTable(
                              columns: <DataColumn>[
                                for (String parameter in parameters)
                                  DataColumn(
                                    label: Text(parameter,
                                        style:
                                            colTitles), // Assuming 'titles' is a TextStyle
                                  ),
                              ],
                              rows: <DataRow>[
                                for (final airData
                                    in airQualityData) // Use 'final' for immutability
                                  DataRow(
                                    cells: <DataCell>[
                                      DataCell(Text(airData.weekday,
                                          style: colTitles)),
                                      DataCell(Text(airData.temp.toString(),
                                          style:
                                              rowTitles)), // Convert AQI to string
                                      DataCell(Text(airData.aqi.toString(),
                                          style:
                                              rowTitles)), // Convert temp to string
                                      DataCell(Text(airData.Co.toString(),
                                          style:
                                              rowTitles)), // Format CO with 1 decimal
                                      DataCell(Text(airData.NO2.toString(),
                                          style: rowTitles)),
                                      DataCell(Text(airData.O3.toString(),
                                          style: rowTitles)),
                                      DataCell(Text(airData.So2.toString(),
                                          style: rowTitles)),
                                      DataCell(Text(airData.PM2.toString(),
                                          style: rowTitles)),
                                      DataCell(Text(airData.PM10.toString(),
                                          style: rowTitles)),
                                    ],
                                  ),
                              ],
                            )),

                         SizedBox(
                          height: 40,
                        ),
                        Text(
                          'Weather Forecast',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                            fontSize: 24,
                          ),
                        ),
                        SizedBox(
                          height: 15,
                        ),

                        Container(
                          height: 200,
                          child: ListView.separated(
                            physics: BouncingScrollPhysics(),
                            scrollDirection: Axis.horizontal,
                            separatorBuilder: (context, index) =>
                                VerticalDivider(
                                  color: Colors.transparent,
                                  width: 5,
                                ),
                            itemCount: weekdays.length,
                            itemBuilder: (context, index) {
                              //String data;

                              return Container(
                                width: 140,
                                height: 150,
                                child: Card(
                                  color: Color(0xffdbefff),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(15),
                                  ),
                                  child: Container(
                                    child: Column(
                                      mainAxisAlignment:
                                      MainAxisAlignment.center,
                                      children: <Widget>[
                                        Text(
                                          '${weekdays[index]}',
                                           style: Theme.of(context)
                                              .textTheme
                                              .caption
                                              ?.copyWith(
                                            fontSize: 18,
                                            fontWeight: FontWeight.bold,
                                            color: Colors.black45,
                                            fontFamily: 'flutterfonts',
                                          ),
                                        ),
                                        Text(
                                              '${Temp[index]}°C',
                                          style: Theme.of(context)
                                              .textTheme
                                              .caption
                                              ?.copyWith(
                                            fontSize: 18,
                                            fontWeight: FontWeight.bold,
                                            color: Colors.black45,
                                            fontFamily: 'flutterfonts',
                                          ),
                                        ),
                                        Container(
                                          width: 90,
                                          height: 90,
                                          decoration: BoxDecoration(
                                            image: DecorationImage(
                                              image: AssetImage(
                                                (() {
                                                  switch (weather[index]) {
                                                    case == 'thunder':
                                                      return 'assets/1.png';
                                                    case == 'rain':
                                                      return 'assets/2.png';
                                                    case == 'snowy':
                                                      return 'assets/4.png';
                                                    case == 'haze':
                                                      return 'assets/9.png';
                                                    case 'sunny':
                                                      return 'assets/6.png';
                                                    case == 'cloudysunny':
                                                      return 'assets/7.png';
                                                    case == 'cloudy':
                                                      return 'assets/8.png';
                                                    default:
                                                      return 'assets/7.png';
                                                  }
                                                })(),
                                              ),
                                              fit: BoxFit.cover,
                                            ),
                                          ),
                                        ),
                                        Text(
                                          '${weather[index]}',
                                          style: Theme.of(context)
                                              .textTheme
                                              .caption!
                                              .copyWith(
                                            color: Colors.black45,
                                            fontFamily: 'flutterfonts',
                                            fontSize: 14,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              );
                            },
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

class SampleAirData {
  final String weekday;
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
  final double? Temp;
  final double? weather;



  SampleAirData({
    required this.weekday,
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
    this.Temp,
    this.weather,
  });
}
