import 'dart:ui';
import 'dart:async';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:lottie/lottie.dart';
import 'package:sliding_switch/sliding_switch.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:envirocast/bloc/weather_bloc_bloc.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:geolocator/geolocator.dart';
import 'air_condition_screen.dart';
import 'dart:developer' as developer;

class HomeScreen extends StatefulWidget {
  final Position position;
  const HomeScreen({
    Key? key,
    required this.position,
  }) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  List<ConnectivityResult> _connectionStatus = [ConnectivityResult.none];
  final Connectivity _connectivity = Connectivity();
  late StreamSubscription<List<ConnectivityResult>> _connectivitySubscription;
  bool isConnected = true;
  late Future<String> cityNameFuture;

  @override
  void initState() {
    super.initState();
    initConnectivity();
  }

  Future<void> initConnectivity() async {
    try {
      final result = await _connectivity.checkConnectivity();
      _updateConnectionStatus(result);
      _connectivitySubscription =
          _connectivity.onConnectivityChanged.listen(_updateConnectionStatus);
    } on PlatformException catch (e) {
      developer.log('Couldn\'t check connectivity status', error: e);
    }
  }

  Future<void> _updateConnectionStatus(List<ConnectivityResult> result) async {
    setState(() {
      _connectionStatus = result;
      if (result.contains(ConnectivityResult.none)) {
        isConnected = false;
      } else {
        isConnected = true;
      }
    });
    // ignore: avoid_print
    print('Connectivity changed: $_connectionStatus');
  }

  @override
  void dispose() {
    _connectivitySubscription.cancel();
    super.dispose();
  }

  Future<Map<String, dynamic>> fetchAirData() async {
    DateTime startDate = DateTime.now();
    DateTime endDate = startDate.add(const Duration(days: 1));

    String formattedEndDate = DateFormat('yyyy-MM-dd').format(endDate);
    String formattedStartDate = DateFormat('yyyy-MM-dd').format(startDate);

    double lat = widget.position.latitude;
    double lon = widget.position.longitude;
    String weatherUrl =
        'https://api.weatherbit.io/v2.0/history/hourly?lat=$lat&lon=$lon&tz=local&start_date=$formattedStartDate&end_date=$formattedEndDate&key=4aa42fc9ef084abf8b9c0656acf29d38';

    final responseTemp = await http.get(Uri.parse(weatherUrl));

    if (responseTemp.statusCode == 200) {
      Map<String, dynamic> weatherData = jsonDecode(responseTemp.body);

      List<dynamic> weatherDataList = weatherData['data'];
      Map<String, dynamic>? tempData;
      for (var item in weatherDataList.reversed) {
        if (item['temp'] != null) {
          tempData = item;
          break;
        }
      }

      if (tempData == null) {
        throw Exception('No valid temperature data found');
      }

      return {
        'tempData': tempData,
      };
    } else {
      throw Exception('Failed to load air or weather data');
    }
  }

  Widget getWeatherIcon(int code) {
    if (code >= 200 && code < 210 || code >= 212 && code < 300) {
      return Lottie.asset('assets/rainthunder.json');
    } else if (code >= 210 && code <= 212) {
      return Lottie.asset('assets/thunder.json');
    } else if (code >= 300 && code < 400) {
      return Lottie.asset('assets/rainsun.json');
    } else if (code >= 500 && code < 600) {
      return Lottie.asset('assets/heavyrain.json');
    } else if (code >= 600 && code < 700) {
      return Lottie.asset('assets/snow.json');
    } else if (code >= 700 && code < 800) {
      return Lottie.asset('assets/mist.json');
    } else if (code == 800) {
      return Lottie.asset('assets/sunny.json');
    } else if (code > 800 && code <= 803) {
      return Lottie.asset('assets/sunnycloudy.json');
    } else if (code == 804) {
      return Lottie.asset('assets/cloudy.json');
    } else {
      return Lottie.asset('assets/sunnycloudy.json');
    }
  }

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

    return Scaffold(
      backgroundColor: Colors.black,
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        systemOverlayStyle:
            const SystemUiOverlayStyle(statusBarBrightness: Brightness.dark),
      ),
      body: Padding(
        padding: const EdgeInsets.fromLTRB(40, 1.2 * kToolbarHeight, 40, 20),
        child: LayoutBuilder(
          builder: (context, constraints) {
            bool isLandscape = constraints.maxWidth > constraints.maxHeight;
            double circleSize = isLandscape ? 200 : 300;

            return SizedBox(
              height: constraints.maxHeight,
              child: FutureBuilder<Map<String, dynamic>>(
                future: fetchAirData(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  } else if (!isConnected) {
                    WidgetsBinding.instance.addPostFrameCallback((_) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text(
                            'Unable to connect to the internet',
                            style: TextStyle(color: Colors.white, fontSize: 18),
                          ),
                          backgroundColor: Colors.red,
                        ),
                      );
                    });
                    return const Center(
                      child: Text(
                        'No Internet Connection',
                        style: TextStyle(color: Colors.white),
                      ),
                    );
                  } else if (snapshot.hasError) {
                    WidgetsBinding.instance.addPostFrameCallback((_) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text(
                            'Error: ${snapshot.error}',
                            style: const TextStyle(color: Colors.white),
                          ),
                          backgroundColor: Colors.red,
                        ),
                      );
                    });
                    return const Center(
                      child: Text(
                        'An error occurred',
                        style: TextStyle(color: Colors.white),
                      ),
                    );
                  } else {
                    Map<String, dynamic> tempData = snapshot.data!['tempData'];
                    return Stack(
                      children: [
                        Align(
                          alignment: const AlignmentDirectional(3, -0.3),
                          child: Container(
                            height: circleSize,
                            width: circleSize,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: colorDown,
                            ),
                          ),
                        ),
                        Align(
                          alignment: const AlignmentDirectional(-3, -0.3),
                          child: Container(
                            height: circleSize,
                            width: circleSize,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: colorDown,
                            ),
                          ),
                        ),
                        Align(
                          alignment: const AlignmentDirectional(0, -1.2),
                          child: Container(
                            height: circleSize,
                            width: circleSize * 2,
                            decoration: BoxDecoration(
                              color: colorUp,
                            ),
                          ),
                        ),
                        BackdropFilter(
                          filter:
                              ImageFilter.blur(sigmaX: 100.0, sigmaY: 100.0),
                          child: Container(
                            decoration:
                                const BoxDecoration(color: Colors.transparent),
                          ),
                        ),
                        BlocBuilder<WeatherBlocBloc, WeatherBlocState>(
                          builder: (context, state) {
                            if (state is WeatherBlocSuccess) {
                              return SingleChildScrollView(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      '📍 ${state.weather.areaName}',
                                      style: const TextStyle(
                                          color: Colors.white,
                                          fontWeight: FontWeight.w300),
                                    ),
                                    const SizedBox(height: 8),
                                    Text(
                                      greeting,
                                      style: const TextStyle(
                                          color: Colors.white,
                                          fontSize: 25,
                                          fontWeight: FontWeight.bold),
                                    ),
                                    Center(
                                      child: getWeatherIcon(
                                          state.weather.weatherConditionCode!),
                                    ),
                                    Center(
                                      child: Text(
                                        '${tempData['temp'].toStringAsFixed(0)}°C',
                                        style: const TextStyle(
                                            color: Colors.white,
                                            fontSize: 55,
                                            fontWeight: FontWeight.w600),
                                      ),
                                    ),
                                    Center(
                                      child: Text(
                                        state.weather.weatherMain!
                                            .toUpperCase(),
                                        style: const TextStyle(
                                            color: Colors.white,
                                            fontSize: 25,
                                            fontWeight: FontWeight.w500),
                                      ),
                                    ),
                                    const SizedBox(height: 5),
                                    Center(
                                      child: Text(
                                        DateFormat('EEEE dd •')
                                            .add_jm()
                                            .format(state.weather.date!),
                                        style: const TextStyle(
                                            color: Colors.white,
                                            fontSize: 16,
                                            fontWeight: FontWeight.w300),
                                      ),
                                    ),
                                    const SizedBox(height: 30),
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Row(
                                          children: [
                                            Image.asset(
                                              'assets/11.png',
                                              scale: 8,
                                            ),
                                            const SizedBox(width: 5),
                                            Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                const Text(
                                                  'Sunrise',
                                                  style: TextStyle(
                                                      color: Colors.white,
                                                      fontWeight:
                                                          FontWeight.w300),
                                                ),
                                                const SizedBox(height: 3),
                                                Text(
                                                  DateFormat().add_jm().format(
                                                      state.weather.sunrise!),
                                                  style: const TextStyle(
                                                      color: Colors.white,
                                                      fontWeight:
                                                          FontWeight.w700),
                                                ),
                                              ],
                                            )
                                          ],
                                        ),
                                        Row(
                                          children: [
                                            Image.asset(
                                              'assets/12.png',
                                              scale: 8,
                                            ),
                                            const SizedBox(width: 5),
                                            Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                const Text(
                                                  'Sunset',
                                                  style: TextStyle(
                                                      color: Colors.white,
                                                      fontWeight:
                                                          FontWeight.w300),
                                                ),
                                                const SizedBox(height: 3),
                                                Text(
                                                  DateFormat().add_jm().format(
                                                      state.weather.sunset!),
                                                  style: const TextStyle(
                                                      color: Colors.white,
                                                      fontWeight:
                                                          FontWeight.w700),
                                                ),
                                              ],
                                            )
                                          ],
                                        ),
                                      ],
                                    ),
                                    const Padding(
                                      padding:
                                          EdgeInsets.symmetric(vertical: 5.0),
                                      child: Divider(
                                        color: Colors.grey,
                                      ),
                                    ),
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Row(
                                          children: [
                                            Image.asset(
                                              'assets/13.png',
                                              scale: 8,
                                            ),
                                            const SizedBox(width: 5),
                                            Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                const Text(
                                                  'Temp Max',
                                                  style: TextStyle(
                                                      color: Colors.white,
                                                      fontWeight:
                                                          FontWeight.w300),
                                                ),
                                                const SizedBox(height: 3),
                                                Text(
                                                  "${state.weather.tempMax!.celsius!.round()} °C",
                                                  style: const TextStyle(
                                                      color: Colors.white,
                                                      fontWeight:
                                                          FontWeight.w700),
                                                ),
                                              ],
                                            ),
                                          ],
                                        ),
                                        Row(
                                          children: [
                                            Image.asset(
                                              'assets/14.png',
                                              scale: 8,
                                            ),
                                            const SizedBox(width: 5),
                                            Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                const Text(
                                                  'Temp Min',
                                                  style: TextStyle(
                                                      color: Colors.white,
                                                      fontWeight:
                                                          FontWeight.w300),
                                                ),
                                                const SizedBox(height: 3),
                                                Text(
                                                  "${state.weather.tempMin!.celsius!.round()} °C",
                                                  style: const TextStyle(
                                                      color: Colors.white,
                                                      fontWeight:
                                                          FontWeight.w700),
                                                ),
                                              ],
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                    const SizedBox(height: 40),
                                    Align(
                                      alignment: FractionalOffset.bottomCenter,
                                      child: Center(
                                        child: SlidingSwitch(
                                          value: false,
                                          width: 250,
                                          onChanged: (bool value) {},
                                          height: 35,
                                          animationDuration:
                                              const Duration(milliseconds: 400),
                                          onTap: () {
                                            Navigator.push(
                                                context,
                                                MaterialPageRoute(
                                                    builder: (context) =>
                                                        AirConditionScreen(
                                                          colorUp: colorUp,
                                                          colorDown: colorDown,
                                                        )));
                                          },
                                          onDoubleTap: () {},
                                          onSwipe: () {},
                                          textOff: "Weather",
                                          textOn: "Air Condition",
                                          colorOn: const Color(0xffdc6c73),
                                          colorOff: const Color(0xff6682c0),
                                          background: const Color.fromARGB(
                                              43, 204, 203, 203),
                                          buttonColor: const Color.fromARGB(
                                              42, 247, 245, 247),
                                          inactiveColor:
                                              const Color(0xff636f7b),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              );
                            } else {
                              return Container();
                            }
                          },
                        ),
                      ],
                    );
                  }
                },
              ),
            );
          },
        ),
      ),
    );
  }
}
