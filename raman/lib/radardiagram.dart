import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'navigationbars.dart';
import 'fetch_data.dart' as data;

class RadarChartExample extends StatefulWidget {
  @override
  _RadarChartExampleState createState() => _RadarChartExampleState();
}

class _RadarChartExampleState extends State<RadarChartExample> {
  bool isDaySelected = true;
  bool isWeekSelected = false;
  bool isMonthSelected = false;

// data.dart
  List<double> dayData = [
    data.painValue,
    data.sleepValue,
    data.activityValue,
    data.moodValue,
    data.socialValue
  ];
  List<double> weekData = [
    data.smerteUge,
    data.sovnUge,
    data.aktivitetUge,
    data.humorUge,
    data.socialUge
  ];
  List<double> monthData = [
    data.smerteManed,
    data.sovnManed,
    data.aktivitetManed,
    data.humorManed,
    data.socialManed
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 243, 243, 228),
      appBar: Topappbar(pagename: "Radardiagram"),
      bottomNavigationBar: const Bottomappbar(),
      body: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              _buildCheckbox('Dag', Colors.blue, isDaySelected, (bool? value) {
                setState(() {
                  isDaySelected = value!;
                });
              }),
              _buildCheckbox('Uge', Colors.green, isWeekSelected,
                  (bool? value) {
                setState(() {
                  isWeekSelected = value!;
                });
              }),
              _buildCheckbox('Måned', Colors.red, isMonthSelected,
                  (bool? value) {
                setState(() {
                  isMonthSelected = value!;
                });
              }),
            ],
          ),
          Expanded(
            child: Center(
              child: SizedBox(
                height: 350, // Adjust the height as needed
                child: RadarChart(
                  RadarChartData(
                    radarTouchData: RadarTouchData(enabled: true),
                    dataSets: _getSelectedDataSets(),
                    radarBackgroundColor: Colors.transparent,
                    borderData: FlBorderData(show: false),
                    radarBorderData: BorderSide(color: Colors.transparent),
                    titlePositionPercentageOffset: 0.2,
                    titleTextStyle:
                        TextStyle(color: Colors.black, fontSize: 14),
                    getTitle: (index, angle) {
                      switch (index) {
                        case 0:
                          return RadarChartTitle(text: 'Smerte');
                        case 1:
                          return RadarChartTitle(text: 'Søvn');
                        case 2:
                          return RadarChartTitle(text: 'Aktivitet');
                        case 3:
                          return RadarChartTitle(text: 'Humør');
                        case 4:
                          return RadarChartTitle(text: 'Social');
                        default:
                          return RadarChartTitle(text: '');
                      }
                    },
                    tickCount: 5,
                    ticksTextStyle: TextStyle(color: Colors.grey, fontSize: 10),
                    tickBorderData: BorderSide(color: Colors.grey),
                    gridBorderData: BorderSide(color: Colors.grey, width: 2),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCheckbox(
      String period, Color color, bool isSelected, Function(bool?) onChanged) {
    return Row(
      children: [
        Checkbox(
          value: isSelected,
          onChanged: onChanged,
          activeColor: color,
        ),
        Text(period),
      ],
    );
  }

  List<RadarDataSet> _getSelectedDataSets() {
    List<RadarDataSet> dataSets = [];
    if (isDaySelected) {
      dataSets.add(RadarDataSet(
        fillColor: Colors.blue.withOpacity(0.3),
        borderColor: Colors.blue,
        entryRadius: 3,
        dataEntries: dayData.map((e) => RadarEntry(value: e)).toList(),
        borderWidth: 2,
      ));
    }
    if (isWeekSelected) {
      dataSets.add(RadarDataSet(
        fillColor: Colors.green.withOpacity(0.3),
        borderColor: Colors.green,
        entryRadius: 3,
        dataEntries: weekData.map((e) => RadarEntry(value: e)).toList(),
        borderWidth: 2,
      ));
    }
    if (isMonthSelected) {
      dataSets.add(RadarDataSet(
        fillColor: Colors.red.withOpacity(0.3),
        borderColor: Colors.red,
        entryRadius: 3,
        dataEntries: monthData.map((e) => RadarEntry(value: e)).toList(),
        borderWidth: 2,
      ));
    }
    if (dataSets.isEmpty) {
      dataSets.add(RadarDataSet(
        fillColor: Colors.transparent,
        borderColor: Colors.transparent,
        dataEntries: List.generate(5, (index) => RadarEntry(value: 0)),
      ));
    }
    return dataSets;
  }
}
