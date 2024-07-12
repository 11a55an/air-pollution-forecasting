import 'dart:async';
import 'dart:ui';
import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:envirocast/notifications_controller.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:kdgaugeview/kdgaugeview.dart';
import 'outdoor_screen.dart';
import 'dart:developer' as developer;

class AirConditionScreen extends StatefulWidget {
  final Color colorUp;
  final Color colorDown;
  const AirConditionScreen({
    Key? key,
    required this.colorUp,
    required this.colorDown,
  }) : super(key: key);

  @override
  AirConditionScreenState createState() => AirConditionScreenState();
}

class AirConditionScreenState extends State<AirConditionScreen> {
  late final stream = FirebaseDatabase.instance.ref('sensor_data').onValue;
  List<ConnectivityResult> _connectionStatus = [ConnectivityResult.none];
  final Connectivity _connectivity = Connectivity();
  late StreamSubscription<List<ConnectivityResult>> _connectivitySubscription;
  bool isConnected = true;

  @override
  void initState() {
    initConnectivity();
    super.initState();
    AwesomeNotifications().setListeners(
      onActionReceivedMethod: NotificationsController.onActionReceivedMethod,
      onNotificationCreatedMethod:
          NotificationsController.onNotificationCreateMethod,
      onNotificationDisplayedMethod:
          NotificationsController.onNotificationDisplayedMethod,
      onDismissActionReceivedMethod:
          NotificationsController.onDismissActionReceivedMethod,
    );
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
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
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
          } else if (snapshot.hasData) {
            final data = snapshot.data?.snapshot.value as Map?;
            if (data == null) {
              return const Center(
                child: Text(
                  'No data',
                  style: TextStyle(color: Colors.white),
                ),
              );
            }

            final dust = data['dust'].toDouble();
            final humidity = data['humidity'].toDouble();
            final mq135 = data['mq135'].toDouble();
            final mq5 = data['mq5'].toDouble();
            final mq7 = data['mq7'].toDouble();
            final temperature = data['temperature'].toDouble();

            // Your notification logic goes here
            checkAndCreateNotifications(dust, mq5, mq135, mq7, humidity);

            return buildAirConditionView(
              dust: dust,
              humidity: humidity,
              mq135: mq135,
              mq5: mq5,
              mq7: mq7,
              temperature: temperature,
            );
          } else {
            return const Center(
              child: Text(
                'No data available',
                style: TextStyle(color: Colors.white),
              ),
            );
          }
        },
      ),
    );
  }

  void checkAndCreateNotifications(
    double? dust,
    double? mq5,
    double? mq135,
    double? mq7,
    double? humidity,
  ) {
    if (dust != null &&
        dust > 150.0 &&
        !NotificationsController.activeNotifications.contains(1)) {
      AwesomeNotifications().createNotification(
        content: NotificationContent(
          id: 1,
          channelKey: "envirocast",
          title: "Too much Dust",
          body: "The amount of dust indoor is too high at $dust",
        ),
      );
    }

    if (mq5 != null &&
        mq5 > 100.0 &&
        !NotificationsController.activeNotifications.contains(2)) {
      AwesomeNotifications().createNotification(
        content: NotificationContent(
          id: 2,
          channelKey: "envirocast",
          title: "Too much LPG",
          body: "The amount of LPG indoor is too high at $mq5",
        ),
      );
    }

    if (mq135 != null &&
        mq135 > 80.0 &&
        !NotificationsController.activeNotifications.contains(3)) {
      AwesomeNotifications().createNotification(
        content: NotificationContent(
          id: 3,
          channelKey: "envirocast",
          title: "Too much Natural Gas",
          body: "The amount of natural gas indoor is too high at $mq135",
        ),
      );
    }

    if (mq7 != null &&
        mq7 > 50.0 &&
        !NotificationsController.activeNotifications.contains(4)) {
      AwesomeNotifications().createNotification(
        content: NotificationContent(
          id: 4,
          channelKey: "envirocast",
          title: "Too much CO",
          body: "The amount of CO indoor is too high at $mq7",
        ),
      );
    }

    if (humidity != null &&
        humidity > 70.0 &&
        !NotificationsController.activeNotifications.contains(5)) {
      AwesomeNotifications().createNotification(
        content: NotificationContent(
          id: 5,
          channelKey: "envirocast",
          title: "Too much Humidity",
          body: "The value of humidity indoor is too high at $humidity",
        ),
      );
    }
  }

  Widget buildAirConditionView({
    required double dust,
    required double humidity,
    required double mq135,
    required double mq5,
    required double mq7,
    required double temperature,
  }) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(40, 1.2 * kToolbarHeight, 40, 20),
      child: SizedBox(
        height: MediaQuery.of(context).size.height,
        child: Stack(children: [
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
            child: SizedBox(
              width: MediaQuery.of(context).size.width,
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
                    child: SizedBox(
                      width: 320,
                      height: 300,
                      child: Center(
                        child: KdGaugeView(
                          minSpeed: 0,
                          maxSpeed: 200,
                          speed: dust.toDouble(),
                          animate: true,
                          duration: const Duration(seconds: 5),
                          alertSpeedArray: const [50, 100, 150, 200],
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
                              builder: (context) => OutdoorScreen(
                                    colorUp: widget.colorUp,
                                    colorDown: widget.colorDown,
                                  )),
                        );
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor:
                            const Color.fromARGB(43, 204, 203, 203),
                        minimumSize: const Size(150, 50), // Button size
                        padding: const EdgeInsets.symmetric(
                            horizontal: 16), // Button padding
                        shape: RoundedRectangleBorder(
                          borderRadius:
                              BorderRadius.circular(30), // Button border radius
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
                            crossAxisAlignment: CrossAxisAlignment.start,
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
                                temperature.toStringAsFixed(0),
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
                            crossAxisAlignment: CrossAxisAlignment.start,
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
                                mq5.toStringAsFixed(0),
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
                            crossAxisAlignment: CrossAxisAlignment.start,
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
                                mq135.toStringAsFixed(0),
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
                      Row(
                        children: [
                          const Icon(
                            Icons.dehaze,
                            color: Colors.white,
                            size: 35,
                          ),
                          const SizedBox(width: 8),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
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
                                dust.toStringAsFixed(0),
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
                            crossAxisAlignment: CrossAxisAlignment.start,
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
                                humidity.toStringAsFixed(0),
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
                            crossAxisAlignment: CrossAxisAlignment.start,
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
                                mq7.toStringAsFixed(0),
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
                ],
              ),
            ),
          ),
        ]),
      ),
    );
  }
}
