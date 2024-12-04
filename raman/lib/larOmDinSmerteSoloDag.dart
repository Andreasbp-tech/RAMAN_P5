import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import 'navigationbars.dart';
import 'fetch_data.dart' as data;
import 'laromdinsmerteMellemPage.dart' as laromdinsmerteMellemPage;

class LarOmDinSmerteSoloDagPage1 extends StatefulWidget {
  int chosenDateIndex;
  bool goodDay;
  bool badDay;
  LarOmDinSmerteSoloDagPage1(
      {super.key,
      required this.chosenDateIndex,
      required this.goodDay,
      required this.badDay});

  @override
  State<LarOmDinSmerteSoloDagPage1> createState() =>
      _LarOmDinSmerteSoloDagPage1State();
}

class _LarOmDinSmerteSoloDagPage1State
    extends State<LarOmDinSmerteSoloDagPage1> {
  List<Map<String, Map<String, bool>>> aktiviteterForAlleIndlesteGodeDage = [];
  List<Map<String, Map<String, bool>>> aktiviteterForAlleIndlesteDarligeDage =
      [];
  String chosenDate = "";

  List<String> top10aktiviteter = [];
  final PageController _pageController = PageController();

  final List<Color> cardColors = [
    Colors.red,
    Colors.green,
    Colors.blue,
    Colors.orange,
    Colors.purple,
    Colors.yellow,
    Colors.cyan,
    Colors.pink,
    Colors.teal,
    Colors.brown,
  ];
  Map<String, Map<String, bool>> aktiviteterForDagen = {};

  @override
  void initState() {
    super.initState();
    _fetchData();
    processData();
  }

  _fetchData() {
    chosenDate = laromdinsmerteMellemPage.chosenDateForLarOmDinSmerte;
    aktiviteterForAlleIndlesteGodeDage = data.dataGodeDageForUseInApp;
    aktiviteterForAlleIndlesteDarligeDage = data.dataBadDaysForUseInApp;
    if (widget.goodDay) {
      aktiviteterForDagen =
          data.dataGodeDageForUseInApp[widget.chosenDateIndex];
    } else if (widget.badDay) {
      aktiviteterForDagen = data.dataBadDaysForUseInApp[widget.chosenDateIndex];
    }
  }

  void processData() {
    Map<String, int> trueCountMap = {};

    for (var map in aktiviteterForAlleIndlesteGodeDage) {
      map.forEach((key, value) {
        value.forEach((innerKey, innerValue) {
          if (innerValue) {
            trueCountMap[innerKey] = (trueCountMap[innerKey] ?? 0) + 1;
          }
        });
      });
    }

    var sortedEntries = trueCountMap.entries.toList()
      ..sort((a, b) => b.value.compareTo(a.value));

    top10aktiviteter = sortedEntries.take(10).map((e) => e.key).toList();
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 243, 243, 228),
      appBar: Topappbar(
        pagename: chosenDate,
      ),
      bottomNavigationBar: const Bottomappbar(),
      body: Column(
        children: [
          Expanded(
            child: PageView(
              controller: _pageController,
              children: <Widget>[
                SingleChildScrollView(
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      children: [
                        // GridView.builder(
                        //   shrinkWrap: true,
                        //   itemCount: top10aktiviteter.length,
                        //   gridDelegate:
                        //       const SliverGridDelegateWithFixedCrossAxisCount(
                        //     crossAxisCount: 5,
                        //     childAspectRatio: 2,
                        //   ),
                        //   itemBuilder: (context, index) {
                        //     return Card(
                        //       color: cardColors[index % cardColors.length],
                        //       child: Center(
                        //         child: Text(top10aktiviteter[index]),
                        //       ),
                        //     );
                        //   },
                        // ),
                        const SizedBox(height: 20),
                        CustomBarChart(
                            aktiviteterForDagen: aktiviteterForDagen,
                            cardColors: cardColors,
                            top10aktiviteter: top10aktiviteter)
                      ],
                    ),
                  ),
                ),
                SingleChildScrollView(
                  child: Container(),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: SmoothPageIndicator(
              controller: _pageController,
              count: 2,
              effect: WormEffect(
                dotHeight: 12,
                dotWidth: 12,
                activeDotColor: Colors.blue,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class LegendWidget extends StatelessWidget {
  const LegendWidget({
    super.key,
    required this.name,
    required this.color,
  });
  final String name;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 10,
          height: 10,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: color,
          ),
        ),
        const SizedBox(width: 6),
        Text(
          name,
          style: const TextStyle(
            color: Color(0xff757391),
            fontSize: 16,
          ),
        ),
      ],
    );
  }
}

class LegendsListWidget extends StatelessWidget {
  const LegendsListWidget({
    super.key,
    required this.legends,
  });
  final List<Legend> legends;

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: 16,
      children: legends
          .map(
            (e) => LegendWidget(
              name: e.name,
              color: e.color,
            ),
          )
          .toList(),
    );
  }
}

class Legend {
  Legend(this.name, this.color);
  final String name;
  final Color color;
}

class CustomBarChart extends StatelessWidget {
  Map<String, Map<String, bool>> aktiviteterForDagen;
  List<String> top10aktiviteter;
  List<Color> cardColors;
  CustomBarChart(
      {super.key,
      required this.aktiviteterForDagen,
      required this.cardColors,
      required this.top10aktiviteter});

  final pilateColor = Colors.purple;
  final cyclingColor = Colors.cyan;
  final quickWorkoutColor = Colors.blue;
  final betweenSpace = 0.0;
  final double barWidth = 20;

  addDoubleToList(Map<String, bool> inputMap, double doubleSize) {
    Map<String, double> outputMap = {};
    inputMap.forEach((key, value) {
      outputMap[key] = value ? doubleSize : 0.0;
    });
    print(outputMap);
    return outputMap;
  }

  BarChartGroupData generateGroupData(
      int x,
      Map<String, double> top10aktiviteterMedDouble,
      double barWidth,
      List<String> top10aktiviteter,
      double betweenSpace) {
    return BarChartGroupData(
      x: x,
      groupVertically: true,
      barsSpace: 15,
      barRods: List.generate(top10aktiviteter.length, (index) {
        double fromY = index == 0
            ? 0
            : top10aktiviteter
                    .take(index)
                    .map((activity) =>
                        top10aktiviteterMedDouble[activity] ?? 0.0)
                    .reduce((a, b) => a + b) +
                (index * betweenSpace);
        double toY =
            fromY + (top10aktiviteterMedDouble[top10aktiviteter[index]] ?? 0.0);
        return BarChartRodData(
          fromY: fromY,
          toY: toY,
          color: cardColors[index % cardColors.length],
          width: barWidth,
        );
      }),
    );
  }

  // BarChartGroupData generateGroupData(
  //     int x, Map<String, double> top10aktiviteterMedDouble, double barWidth,List<String>top10aktiviteter) {
  //   return BarChartGroupData(
  //     x: x,
  //     groupVertically: true,
  //     barsSpace: 25,
  //     barRods: [
  //       BarChartRodData(
  //         fromY: 0,
  //         toY: top10aktiviteterMedDouble.values.singleWhere((element) =>  element == top10aktiviteter[0],),
  //         color: cardColors[0],
  //         width: barWidth,
  //       ),
  //       BarChartRodData(
  //         fromY: top10aktiviteterMedDouble.values.elementAt(0) + betweenSpace,
  //         toY: top10aktiviteterMedDouble.values.elementAt(0) +
  //             betweenSpace +
  //             top10aktiviteterMedDouble.values.elementAt(1),
  //         color: cardColors[1],
  //         width: barWidth,
  //       ),
  //       BarChartRodData(
  //         fromY: top10aktiviteterMedDouble.values.elementAt(0) +
  //             betweenSpace +
  //             top10aktiviteterMedDouble.values.elementAt(1) +
  //             betweenSpace,
  //         toY: top10aktiviteterMedDouble.values.elementAt(0) +
  //             betweenSpace +
  //             top10aktiviteterMedDouble.values.elementAt(1) +
  //             betweenSpace +
  //             top10aktiviteterMedDouble.values.elementAt(2),
  //         color: cardColors[2],
  //         width: barWidth,
  //       ),
  //       BarChartRodData(
  //         fromY: top10aktiviteterMedDouble.values.elementAt(0) +
  //             betweenSpace +
  //             top10aktiviteterMedDouble.values.elementAt(1) +
  //             betweenSpace +
  //             top10aktiviteterMedDouble.values.elementAt(2),
  //         toY: top10aktiviteterMedDouble.values.elementAt(0) +
  //             betweenSpace +
  //             top10aktiviteterMedDouble.values.elementAt(1) +
  //             betweenSpace +
  //             top10aktiviteterMedDouble.values.elementAt(2) +
  //             betweenSpace +
  //             top10aktiviteterMedDouble.values.elementAt(3),
  //         color: cardColors[3],
  //         width: barWidth,
  //       ),
  //       BarChartRodData(
  //         fromY: top10aktiviteterMedDouble.values.elementAt(0) +
  //             betweenSpace +
  //             top10aktiviteterMedDouble.values.elementAt(1) +
  //             betweenSpace +
  //             top10aktiviteterMedDouble.values.elementAt(2) +
  //             betweenSpace +
  //             top10aktiviteterMedDouble.values.elementAt(3),
  //         toY: top10aktiviteterMedDouble.values.elementAt(0) +
  //             betweenSpace +
  //             top10aktiviteterMedDouble.values.elementAt(1) +
  //             betweenSpace +
  //             top10aktiviteterMedDouble.values.elementAt(2) +
  //             betweenSpace +
  //             top10aktiviteterMedDouble.values.elementAt(3) +
  //             betweenSpace +
  //             top10aktiviteterMedDouble.values.elementAt(4),
  //         color: cardColors[4],
  //         width: barWidth,
  //       ),
  //       BarChartRodData(
  //         fromY: top10aktiviteterMedDouble.values.elementAt(0) +
  //             betweenSpace +
  //             top10aktiviteterMedDouble.values.elementAt(1) +
  //             betweenSpace +
  //             top10aktiviteterMedDouble.values.elementAt(2) +
  //             betweenSpace +
  //             top10aktiviteterMedDouble.values.elementAt(3) +
  //             betweenSpace +
  //             top10aktiviteterMedDouble.values.elementAt(4),
  //         toY: top10aktiviteterMedDouble.values.elementAt(0) +
  //             betweenSpace +
  //             top10aktiviteterMedDouble.values.elementAt(1) +
  //             betweenSpace +
  //             top10aktiviteterMedDouble.values.elementAt(2) +
  //             betweenSpace +
  //             top10aktiviteterMedDouble.values.elementAt(3) +
  //             betweenSpace +
  //             top10aktiviteterMedDouble.values.elementAt(4) +
  //             betweenSpace +
  //             top10aktiviteterMedDouble.values.elementAt(5),
  //         color: cardColors[5],
  //         width: barWidth,
  //       ),
  //       BarChartRodData(
  //         fromY: top10aktiviteterMedDouble.values.elementAt(0) +
  //             betweenSpace +
  //             top10aktiviteterMedDouble.values.elementAt(1) +
  //             betweenSpace +
  //             top10aktiviteterMedDouble.values.elementAt(2) +
  //             betweenSpace +
  //             top10aktiviteterMedDouble.values.elementAt(3) +
  //             betweenSpace +
  //             top10aktiviteterMedDouble.values.elementAt(4) +
  //             betweenSpace +
  //             top10aktiviteterMedDouble.values.elementAt(5),
  //         toY: top10aktiviteterMedDouble.values.elementAt(0) +
  //             betweenSpace +
  //             top10aktiviteterMedDouble.values.elementAt(1) +
  //             betweenSpace +
  //             top10aktiviteterMedDouble.values.elementAt(2) +
  //             betweenSpace +
  //             top10aktiviteterMedDouble.values.elementAt(3) +
  //             betweenSpace +
  //             top10aktiviteterMedDouble.values.elementAt(4) +
  //             betweenSpace +
  //             top10aktiviteterMedDouble.values.elementAt(5) +
  //             betweenSpace +
  //             top10aktiviteterMedDouble.values.elementAt(6),
  //         color: cardColors[6],
  //         width: barWidth,
  //       ),
  //       BarChartRodData(
  //         fromY: top10aktiviteterMedDouble.values.elementAt(0) +
  //             betweenSpace +
  //             top10aktiviteterMedDouble.values.elementAt(1) +
  //             betweenSpace +
  //             top10aktiviteterMedDouble.values.elementAt(2) +
  //             betweenSpace +
  //             top10aktiviteterMedDouble.values.elementAt(3) +
  //             betweenSpace +
  //             top10aktiviteterMedDouble.values.elementAt(4) +
  //             betweenSpace +
  //             top10aktiviteterMedDouble.values.elementAt(5) +
  //             betweenSpace +
  //             top10aktiviteterMedDouble.values.elementAt(6),
  //         toY: top10aktiviteterMedDouble.values.elementAt(0) +
  //             betweenSpace +
  //             top10aktiviteterMedDouble.values.elementAt(1) +
  //             betweenSpace +
  //             top10aktiviteterMedDouble.values.elementAt(2) +
  //             betweenSpace +
  //             top10aktiviteterMedDouble.values.elementAt(3) +
  //             betweenSpace +
  //             top10aktiviteterMedDouble.values.elementAt(4) +
  //             betweenSpace +
  //             top10aktiviteterMedDouble.values.elementAt(5) +
  //             betweenSpace +
  //             top10aktiviteterMedDouble.values.elementAt(6) +
  //             betweenSpace +
  //             top10aktiviteterMedDouble.values.elementAt(7),
  //         color: cardColors[7],
  //         width: barWidth,
  //       ),
  //       BarChartRodData(
  //         fromY: top10aktiviteterMedDouble.values.elementAt(0) +
  //             betweenSpace +
  //             top10aktiviteterMedDouble.values.elementAt(1) +
  //             betweenSpace +
  //             top10aktiviteterMedDouble.values.elementAt(2) +
  //             betweenSpace +
  //             top10aktiviteterMedDouble.values.elementAt(3) +
  //             betweenSpace +
  //             top10aktiviteterMedDouble.values.elementAt(4) +
  //             betweenSpace +
  //             top10aktiviteterMedDouble.values.elementAt(5) +
  //             betweenSpace +
  //             top10aktiviteterMedDouble.values.elementAt(6) +
  //             betweenSpace +
  //             top10aktiviteterMedDouble.values.elementAt(7),
  //         toY: top10aktiviteterMedDouble.values.elementAt(0) +
  //             betweenSpace +
  //             top10aktiviteterMedDouble.values.elementAt(1) +
  //             betweenSpace +
  //             top10aktiviteterMedDouble.values.elementAt(2) +
  //             betweenSpace +
  //             top10aktiviteterMedDouble.values.elementAt(3) +
  //             betweenSpace +
  //             top10aktiviteterMedDouble.values.elementAt(4) +
  //             betweenSpace +
  //             top10aktiviteterMedDouble.values.elementAt(5) +
  //             betweenSpace +
  //             top10aktiviteterMedDouble.values.elementAt(6) +
  //             betweenSpace +
  //             top10aktiviteterMedDouble.values.elementAt(7) +
  //             betweenSpace +
  //             top10aktiviteterMedDouble.values.elementAt(8),
  //         color: cardColors[8],
  //         width: barWidth,
  //       ),
  //       BarChartRodData(
  //         fromY: top10aktiviteterMedDouble.values.elementAt(0) +
  //             betweenSpace +
  //             top10aktiviteterMedDouble.values.elementAt(1) +
  //             betweenSpace +
  //             top10aktiviteterMedDouble.values.elementAt(2) +
  //             betweenSpace +
  //             top10aktiviteterMedDouble.values.elementAt(3) +
  //             betweenSpace +
  //             top10aktiviteterMedDouble.values.elementAt(4) +
  //             betweenSpace +
  //             top10aktiviteterMedDouble.values.elementAt(5) +
  //             betweenSpace +
  //             top10aktiviteterMedDouble.values.elementAt(6) +
  //             betweenSpace +
  //             top10aktiviteterMedDouble.values.elementAt(7) +
  //             betweenSpace +
  //             top10aktiviteterMedDouble.values.elementAt(8),
  //         toY: top10aktiviteterMedDouble.values.elementAt(0) +
  //             betweenSpace +
  //             top10aktiviteterMedDouble.values.elementAt(1) +
  //             betweenSpace +
  //             top10aktiviteterMedDouble.values.elementAt(2) +
  //             betweenSpace +
  //             top10aktiviteterMedDouble.values.elementAt(3) +
  //             betweenSpace +
  //             top10aktiviteterMedDouble.values.elementAt(4) +
  //             betweenSpace +
  //             top10aktiviteterMedDouble.values.elementAt(5) +
  //             betweenSpace +
  //             top10aktiviteterMedDouble.values.elementAt(6) +
  //             betweenSpace +
  //             top10aktiviteterMedDouble.values.elementAt(7) +
  //             betweenSpace +
  //             top10aktiviteterMedDouble.values.elementAt(8) +
  //             betweenSpace +
  //             top10aktiviteterMedDouble.values.elementAt(9),
  //         color: cardColors[9],
  //         width: barWidth,
  //       ),
  //     ],
  //   );
  // }

  Widget bottomTitles(double value, TitleMeta meta) {
    const style = TextStyle(fontSize: 10);
    String text;
    switch (value.toInt()) {
      case 5:
        text = 'På dagen';
        break;
      case 4:
        text = '1 dag før';
        break;
      case 3:
        text = '2 dage før';
        break;
      case 2:
        text = '3 dage før';
        break;
      case 1:
        text = '4 dage før';
        break;
      case 0:
        text = '5 dage før';
      default:
        text = '';
    }
    return SideTitleWidget(
      axisSide: meta.axisSide,
      child: Text(text, style: style),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(24),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          const Text(
            'Aktiviteter',
            style: TextStyle(
              color: Colors.blue,
              fontSize: 26,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          LegendsListWidget(
            legends: [
              Legend(top10aktiviteter[0], cardColors[0]),
              Legend(top10aktiviteter[1], cardColors[1]),
              Legend(top10aktiviteter[2], cardColors[2]),
              Legend(top10aktiviteter[3], cardColors[3]),
              Legend(top10aktiviteter[4], cardColors[4]),
              Legend(top10aktiviteter[5], cardColors[5]),
              Legend(top10aktiviteter[6], cardColors[6]),
              Legend(top10aktiviteter[7], cardColors[7]),
              Legend(top10aktiviteter[8], cardColors[8]),
              Legend(top10aktiviteter[9], cardColors[9]),
            ],
          ),
          const SizedBox(height: 5),
          AspectRatio(
            aspectRatio: 0.7,
            child: BarChart(
              BarChartData(
                alignment: BarChartAlignment.spaceBetween,
                titlesData: FlTitlesData(
                  leftTitles: const AxisTitles(),
                  rightTitles: const AxisTitles(),
                  topTitles: const AxisTitles(),
                  bottomTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      getTitlesWidget: bottomTitles,
                      reservedSize: 30,
                    ),
                  ),
                ),
                barTouchData: BarTouchData(enabled: false),
                borderData: FlBorderData(show: true),
                gridData: const FlGridData(show: true),
                barGroups: [
                  generateGroupData(
                      0,
                      addDoubleToList(
                          aktiviteterForDagen.values.elementAt(5), 1.0),
                      barWidth,
                      top10aktiviteter,
                      0.0),
                  generateGroupData(
                      1,
                      addDoubleToList(
                          aktiviteterForDagen.values.elementAt(4), 1.0),
                      barWidth,
                      top10aktiviteter,
                      0.0),
                  generateGroupData(
                      2,
                      addDoubleToList(
                          aktiviteterForDagen.values.elementAt(3), 1.0),
                      barWidth,
                      top10aktiviteter,
                      0.0),
                  generateGroupData(
                      3,
                      addDoubleToList(
                          aktiviteterForDagen.values.elementAt(2), 1.0),
                      barWidth,
                      top10aktiviteter,
                      0.0),
                  generateGroupData(
                      4,
                      addDoubleToList(
                          aktiviteterForDagen.values.elementAt(1), 1.0),
                      barWidth,
                      top10aktiviteter,
                      0.0),
                  generateGroupData(
                      5,
                      addDoubleToList(
                          aktiviteterForDagen.values.elementAt(0), 1.0),
                      barWidth,
                      top10aktiviteter,
                      0.0),
                ],
                maxY: 10,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
