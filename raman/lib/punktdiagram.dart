import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:raman/navigationbars.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:intl/intl.dart';

class Punktdiagram extends StatefulWidget {
  Punktdiagram({super.key});

  @override
  State<Punktdiagram> createState() => _PunktdiagramState();
}

class _PunktdiagramState extends State<Punktdiagram> {
  final Map<String, dynamic> smerteData = {};
  final Map<String, dynamic> sleepData = {};
  final Map<String, dynamic> socialData = {};
  final Map<String, dynamic> moodData = {};
  final Map<String, dynamic> aktivitetsData = {};
  bool showSmerte = true;
  bool showSleep = true;
  bool showSocial = true;
  bool showMood = true;
  bool showAktivitet = true;
  bool isLoading = true;
  int datasize = 7;
  int fetchedDatasize = 31;
  List<String> lengthOfDataStatus = [
    "Uge",
    "Måned",
    "År",
  ];
  String? chosenDataLength = "Uge";
  final Map<String, bool> showParametreStatus = {
    "Smerte": true,
    "Søvn": false,
    "Social": false,
    "Humør": false,
    "Aktivitet": false,
  };
  @override
  void initState() {
    super.initState();
    _fetchData();
  }

  Future<void> _fetchData() async {
    DateTime now = DateTime.now();

    for (var i = 0; i < fetchedDatasize; i++) {
      DateTime date = now.subtract(Duration(days: i));
      String dateString = DateFormat('yyyy-MM-dd').format(date);
      String DateWithoutYYYY = DateFormat('dd-MM').format(date);
      DocumentReference docRef = FirebaseFirestore.instance
          .collection("users")
          .doc(FirebaseAuth.instance.currentUser!.uid)
          .collection("dage")
          .doc(dateString)
          .collection("smertedagbog")
          .doc("VAS");
      DocumentSnapshot docSnapShot = await docRef.get();

      if (docSnapShot.exists) {
        Map<String, dynamic> data = docSnapShot.data() as Map<String, dynamic>;
        setState(() {
          smerteData.addEntries([MapEntry(DateWithoutYYYY, data["Smerte"])]);
          sleepData.addEntries([MapEntry(DateWithoutYYYY, data["Søvn"])]);
          socialData.addEntries([MapEntry(DateWithoutYYYY, data["Social"])]);
          moodData.addEntries([MapEntry(DateWithoutYYYY, data["Humør"])]);
          aktivitetsData.addEntries(
              [MapEntry(DateWithoutYYYY, data["Aktivitetsniveau"])]);
          // isLoading = false;
        });
      }
    }
    setState(
      () {
        isLoading = false;
      },
    );
    //print("jeg printer smerte: ${data["Smerte"]}");
    print(smerteData);
  }

  Widget build(BuildContext context) {
    if (isLoading) {
      return Scaffold(
        appBar: Topappbar(pagename: "Punktdiagram"),
        body: const Center(child: CircularProgressIndicator()),
      );
    }
    return Scaffold(
      appBar: Topappbar(pagename: "Punktdiagram"),
      bottomNavigationBar: const Bottomappbar(),
      body: Stack(
        children: <Widget>[
          Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              const SizedBox(
                height: 30, //whitespace in top of screen
              ),
              Row(
                children: <Widget>[
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(
                        child: Text("Tid\n"),
                      ),
                      SizedBox(
                        height: 90,
                        width: 180,
                        child: ListView(
                          children: showParametreStatus.keys.map((String key) {
                            return CheckboxListTile(
                              title: Text(key),
                              value: showParametreStatus[key],
                              onChanged: (bool? value) {
                                setState(() {
                                  showParametreStatus[key] = value!;
                                });
                              },
                            );
                          }).toList(),
                        ),
                      )
                    ],
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      const SizedBox(
                        child: Text("Smerte\nParametre"),
                      ),
                      SizedBox(
                        height: 90,
                        width: 180,
                        child: ListView(
                          children: lengthOfDataStatus.map((String item) {
                            return ListTile(
                              title: Text(item),
                              leading: Radio<String>(
                                value: item,
                                groupValue: chosenDataLength,
                                onChanged: (String? value) {
                                  setState(() {
                                    chosenDataLength = value;
                                    _fetchData();
                                    if (chosenDataLength == "Uge") {
                                      datasize = 7;
                                    } else if (chosenDataLength == "Måned") {
                                      datasize = 31;
                                    }
                                  });
                                },
                              ),
                            );
                          }).toList(),
                        ),
                      ),
                    ],
                  )
                ],
              ),
              //need to add checklist of enabled graphs
              const SizedBox(
                height: 30, //whitespace between checkboxes and graph
              ),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.only(right: 16, left: 6),
                  child: LineChartSample(
                      smerteData: smerteData,
                      sleepData: sleepData,
                      socialData: socialData,
                      moodData: moodData,
                      aktivitetsData: aktivitetsData,
                      showParametreStatus: showParametreStatus,
                      datasize: datasize),
                ),
              ),
            ],
          )
        ],
      ),
    );
  }
}

class LineChartSample extends StatelessWidget {
  Map<String, dynamic> smerteData = {};
  Map<String, dynamic> sleepData = {};
  Map<String, dynamic> socialData = {};
  Map<String, dynamic> moodData = {};
  Map<String, dynamic> aktivitetsData = {};
  Map<String, bool> showParametreStatus = {};
  int datasize;

  LineChartSample({
    super.key,
    required this.smerteData,
    required this.sleepData,
    required this.socialData,
    required this.moodData,
    required this.aktivitetsData,
    required this.showParametreStatus,
    required this.datasize,
  });
  @override
  Widget build(BuildContext context) {
    List<FlSpot> smerteSpots = smerteData.entries
        .map((entry) {
          int index = smerteData.keys.toList().indexOf(entry.key);
          return FlSpot(index.toDouble(), entry.value);
        })
        .take(datasize)
        .toList();
    List<FlSpot> sleepSpots = sleepData.entries
        .map((entry) {
          int index = smerteData.keys.toList().indexOf(entry.key);
          return FlSpot(index.toDouble(), entry.value);
        })
        .take(datasize)
        .toList();
    List<FlSpot> socialSpots = socialData.entries
        .map((entry) {
          int index = smerteData.keys.toList().indexOf(entry.key);
          return FlSpot(index.toDouble(), entry.value);
        })
        .take(datasize)
        .toList();
    List<FlSpot> moodSpots = moodData.entries
        .map((entry) {
          int index = smerteData.keys.toList().indexOf(entry.key);
          return FlSpot(index.toDouble(), entry.value);
        })
        .take(datasize)
        .toList();
    List<FlSpot> aktivitetsSpots = aktivitetsData.entries
        .map((entry) {
          int index = smerteData.keys.toList().indexOf(entry.key);
          return FlSpot(index.toDouble(), entry.value);
        })
        .take(datasize)
        .toList();
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: LineChart(
        LineChartData(
          minX: 0,
          maxX: datasize.toDouble(),
          baselineX: 0,
          baselineY: 10,
          minY: 0,
          maxY: 10,
          borderData: FlBorderData(
            show: true,
            border: const Border(
              bottom: BorderSide(color: Colors.black, width: 2),
              left: BorderSide(color: Colors.black, width: 2),
              top: BorderSide(color: Colors.transparent),
              right: BorderSide(color: Colors.transparent),
            ),
          ),
          lineBarsData: [
            LineChartBarData(
              spots: smerteSpots,
              isCurved: false,
              color: Colors.blue,
              barWidth: 2,
              isStrokeCapRound: true,
              dotData: const FlDotData(show: true),
              show: showParametreStatus["Smerte"] ?? false,
            ),
            LineChartBarData(
              spots: sleepSpots,
              isCurved: false,
              color: Colors.red,
              barWidth: 2,
              isStrokeCapRound: true,
              dotData: const FlDotData(show: true),
              show: showParametreStatus["Søvn"] ?? false,
            ),
            LineChartBarData(
              spots: socialSpots,
              isCurved: false,
              color: Colors.purple,
              barWidth: 2,
              isStrokeCapRound: true,
              dotData: const FlDotData(show: true),
              show: showParametreStatus["Social"] ?? false,
            ),
            LineChartBarData(
              spots: moodSpots,
              isCurved: false,
              color: Colors.green,
              barWidth: 2,
              isStrokeCapRound: true,
              dotData: const FlDotData(show: true),
              show: showParametreStatus["Humør"] ?? false,
            ),
            LineChartBarData(
              spots: aktivitetsSpots,
              isCurved: false,
              color: Colors.amber,
              barWidth: 2,
              isStrokeCapRound: true,
              dotData: const FlDotData(show: true),
              show: showParametreStatus["Aktivitet"] ?? false,
            ),
          ],
          titlesData: FlTitlesData(
            bottomTitles: AxisTitles(
              sideTitles: SideTitles(
                  showTitles: true,
                  getTitlesWidget: (value, meta) {
                    if (value.toInt() >= 0 &&
                        value.toInt() < smerteData.keys.length) {
                      return Text(smerteData.keys.elementAt(value.toInt()));
                    } else {
                      return const Text('');
                    }
                  }),
            ),
            leftTitles: const AxisTitles(
              sideTitles: SideTitles(showTitles: true, reservedSize: 30),
            ),
            topTitles: const AxisTitles(
              sideTitles: SideTitles(showTitles: false),
            ),
            rightTitles: const AxisTitles(
              sideTitles: SideTitles(showTitles: false),
            ),
          ),
        ),
      ),
    );
  }
}
