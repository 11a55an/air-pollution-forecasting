import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:lottie/lottie.dart';
import 'package:intl/intl.dart'; // Import the intl package
import 'package:fl_chart/fl_chart.dart'; // Import the fl_chart package

class DetailScreen extends StatelessWidget {
  final String parameterName;
  final List<dynamic> parameterData;
  final List<dynamic> parameterRange;
  final double parameterValue;
  final double predictedValue;
  final double speedValue;
  final Color colorUp;
  final Color colorDown;

  const DetailScreen({
    Key? key,
    required this.parameterName,
    required this.parameterRange,
    required this.parameterData,
    required this.parameterValue,
    required this.predictedValue,
    required this.speedValue,
    required this.colorUp,
    required this.colorDown,
  }) : super(key: key);

  Color getGaugeColor() {
    if (speedValue < parameterRange[0]) {
      return Colors.green; // Good
    } else if (speedValue < parameterRange[1]) {
      return Colors.yellow; // Moderate
    } else if (speedValue < parameterRange[2]) {
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

  Map<DateTime, List<PollutantData>> groupForecastByDay(
      List<PollutantData> forecastData) {
    final Map<DateTime, List<PollutantData>> groupedData = {};
    for (final data in forecastData) {
      final day =
          DateTime(data.dateTime.year, data.dateTime.month, data.dateTime.day);
      if (groupedData.containsKey(day)) {
        groupedData[day]!.add(data);
      } else {
        groupedData[day] = [data];
      }
    }
    return groupedData;
  }

  @override
  Widget build(BuildContext context) {
    final List<double> forecastValues =
        parameterData.map((e) => (e as num).toDouble()).toList();
    final DateTime now = DateTime.now();
    final DateTime startOfCurrentHour =
        DateTime(now.year, now.month, now.day, now.hour);
    final List<PollutantData> forecastData = List.generate(
      168, // 7 days * 24 hours
      (index) => PollutantData(
        dateTime: startOfCurrentHour.add(Duration(hours: index + 1)),
        value: forecastValues[index % forecastValues.length],
      ),
    );

    final Map<DateTime, List<PollutantData>> groupedData =
        groupForecastByDay(forecastData);

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
                    Center(
                      child: Text(
                        parameterName,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 35,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                    Center(
                      child: Transform.scale(
                        scale: 1.0, // Adjust the scale factor as needed
                        child: Lottie.asset(
                          conditionFace,
                        ),
                      ),
                    ),
                    Center(
                      child: Text(
                        parameterValue.toStringAsFixed(0),
                        style: const TextStyle(
                            color: Colors.white,
                            fontSize: 55,
                            fontWeight: FontWeight.w600),
                      ),
                    ),
                    Center(
                      child: Text(
                        conditionText,
                        style: TextStyle(
                            color: gaugeColor,
                            fontSize: 35,
                            fontWeight: FontWeight.w500),
                      ),
                    ),
                    const SizedBox(height: 5),
                    Center(
                      child: Text(
                        DateFormat('EEEE dd •').add_jm().format(DateTime.now()),
                        style: const TextStyle(
                            color: Colors.white,
                            fontSize: 16,
                            fontWeight: FontWeight.w300),
                      ),
                    ),
                    const Padding(
                      padding: EdgeInsets.symmetric(vertical: 14.0),
                      child: Divider(
                        color: Colors.grey,
                      ),
                    ),
                    const Center(
                      child: Text(
                        "Forecast",
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: 35,
                            fontWeight: FontWeight.w500),
                      ),
                    ),
                    const SizedBox(height: 10),
                    ListView.builder(
                      padding: EdgeInsets.zero,
                      shrinkWrap: true,
                      physics:
                          const NeverScrollableScrollPhysics(), // Prevent inner scrolling
                      itemCount: groupedData.keys.length,
                      itemBuilder: (context, index) {
                        final day = groupedData.keys.elementAt(index);
                        final dayData = groupedData[day]!;
                        final minValue = dayData
                            .map((data) => data.value)
                            .reduce((a, b) => a < b ? a : b);
                        final maxValue = dayData
                            .map((data) => data.value)
                            .reduce((a, b) => a > b ? a : b);
                        return DayForecastCard(
                          day: day,
                          minValue: minValue,
                          maxValue: maxValue,
                          dayData: dayData,
                          parameterName: parameterName,
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

class DayForecastCard extends StatefulWidget {
  final DateTime day;
  final double minValue;
  final double maxValue;
  final List<PollutantData> dayData;
  final String parameterName;

  const DayForecastCard({
    Key? key,
    required this.day,
    required this.minValue,
    required this.maxValue,
    required this.dayData,
    required this.parameterName,
  }) : super(key: key);

  @override
  _DayForecastCardState createState() => _DayForecastCardState();
}

class _DayForecastCardState extends State<DayForecastCard> {
  bool _expanded = false;

  List<FlSpot> getGraphData() {
    return widget.dayData
        .map((data) =>
            FlSpot(data.dateTime.hour + data.dateTime.minute / 60, data.value))
        .toList();
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Column(
        children: [
          ListTile(
            title: Text(DateFormat('EEEE, MMM d').format(widget.day)),
            subtitle: Text(
                'Min ${widget.minValue.toStringAsFixed(0)}, Max ${widget.maxValue.toStringAsFixed(0)}'),
            trailing: IconButton(
              icon: Icon(_expanded ? Icons.expand_less : Icons.expand_more),
              onPressed: () {
                setState(() {
                  _expanded = !_expanded;
                });
              },
            ),
          ),
          if (_expanded)
            Column(
              children: [
                SizedBox(
                  height: 200,
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: LineChart(
                      LineChartData(
                        gridData: FlGridData(show: false),
                        titlesData: FlTitlesData(
                          bottomTitles: SideTitles(
                            showTitles: true,
                            getTextStyles: (context, value) => const TextStyle(
                              color: Colors.black,
                              fontWeight: FontWeight.bold,
                              fontSize: 12,
                            ),
                            margin: 8,
                            getTitles: (value) {
                              return DateFormat('HH:mm').format(widget.day
                                  .add(Duration(hours: value.toInt())));
                            },
                          ),
                          leftTitles: SideTitles(
                            showTitles: true,
                            getTextStyles: (context, value) => const TextStyle(
                              color: Colors.black,
                              fontWeight: FontWeight.bold,
                              fontSize: 12,
                            ),
                            margin: 8,
                          ),
                        ),
                        borderData: FlBorderData(
                          show: true,
                          border: const Border(
                            bottom: BorderSide(color: Colors.black, width: 1),
                            left: BorderSide(color: Colors.black, width: 1),
                            right: BorderSide(color: Colors.transparent),
                            top: BorderSide(color: Colors.transparent),
                          ),
                        ),
                        minX: 0,
                        maxX: 23,
                        minY: widget.dayData
                            .map((data) => data.value)
                            .reduce((a, b) => a < b ? a : b),
                        maxY: widget.dayData
                            .map((data) => data.value)
                            .reduce((a, b) => a > b ? a : b),
                        lineBarsData: [
                          LineChartBarData(
                            spots: getGraphData(),
                            isCurved: true,
                            colors: [Colors.blue],
                            barWidth: 2,
                            isStrokeCapRound: true,
                            dotData: FlDotData(show: false),
                            belowBarData: BarAreaData(show: false),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                ListView.builder(
                  padding: EdgeInsets.zero,
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: widget.dayData.length,
                  itemBuilder: (context, index) {
                    final data = widget.dayData[index];
                    return ListTile(
                      title: Text(DateFormat('jm').format(data.dateTime)),
                      subtitle: Text(
                          '${widget.parameterName} : ${data.value.toStringAsFixed(0)}'),
                    );
                  },
                ),
              ],
            ),
        ],
      ),
    );
  }
}

class PollutantData {
  final DateTime dateTime;
  final double value;

  PollutantData({required this.dateTime, required this.value});
}
