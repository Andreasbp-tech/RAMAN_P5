import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
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
  //the following variables is to have a data string for the loaded data
  final Map<String, dynamic> smerteData = {};
  final Map<String, dynamic> sleepData = {};
  final Map<String, dynamic> socialData = {};
  final Map<String, dynamic> moodData = {};
  final Map<String, dynamic> aktivitetsData = {};
  //the following variables is to define the length of data to aquire from the dB
  int datasize = 7;
  int fetchedDatasize = 31;
  //bool for defining whether the dat for the program has been loaded
  bool isLoading = true;
  List<String> lengthOfDataStatus = [
    //this List is to define the options available for the user
    "Uge",
    "Måned",
    "År",
  ];

  String? chosenDataLength =
      "Uge"; //This String? is to define what option is selected by the user, "Uge" is the predefined option
  final Map<String, bool> showParametreStatus = {
    //This Map is to define which parametre should be displayed
    "Smerte": true,
    "Søvn": false,
    "Social": false,
    "Humør": false,
    "Aktivitet": false,
  };
  @override
  void initState() {
    //the functions that is needed to run at the start of the file
    super.initState();
    _fetchData();
  }

  Future<void> _fetchData() async {
    //the function for fetching data in the database
    DateTime now = DateTime.now();

    for (var i = 0; i < fetchedDatasize; i++) {
      //loop for running through the dB, starting from todays date and going backwards
      //var i = 0; i < fetchedDatasize; i++ ==> today is the leftmost day
      //var i = fetchedDatasize; i > 0; i-- ==> today is the rightmost day
      DateTime date = now.subtract(Duration(days: i));
      String dateString = DateFormat('yyyy-MM-dd').format(date);
      String DateWithoutYYYY = DateFormat('dd-MM').format(date);
      DocumentReference docRef = FirebaseFirestore
          .instance //instance for the program to fetch data in the dB
          .collection("users")
          .doc(FirebaseAuth.instance.currentUser!.uid)
          .collection("dage")
          .doc(dateString)
          .collection("smertedagbog")
          .doc("VAS");
      DocumentSnapshot docSnapShot = await docRef.get();

      if (docSnapShot.exists) {
        //when new data is aquired save it at the appropriate data locations
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
        //when data is finsihed loading set the bool to false so that the page can be rendered
        isLoading = false;
      },
    );
    //print("jeg printer smerte: ${data["Smerte"]}");
    print(smerteData); //debugging remove at production
  }

  Widget build(BuildContext context) {
    if (isLoading) {
      //loading page, that is active until data is loaded
      //TODO: add descriptive text of why the program is loading
      return Scaffold(
        appBar: Topappbar(pagename: "Punktdiagram"),
        body: const Center(child: CircularProgressIndicator()),
      );
    }
    return Scaffold(
      //the rendering of the page
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
                        //top left most title
                        child: Text("Tid\n"),
                      ),
                      SizedBox(
                        //top left most checkbox
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
                        //top rightmost title
                        child: Text("Smerte\nParametre"),
                      ),
                      SizedBox(
                        //top rightmost checkbox
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
              const SizedBox(
                height: 30, //whitespace between checkboxes and graph
              ),
              Expanded(
                //the graph
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
  //class to make the linegraph
  //maps to take the data
  Map<String, dynamic> smerteData = {};
  Map<String, dynamic> sleepData = {};
  Map<String, dynamic> socialData = {};
  Map<String, dynamic> moodData = {};
  Map<String, dynamic> aktivitetsData = {};
  //map to define whether a parametre should be shown on the graph
  Map<String, bool> showParametreStatus = {};
  //int to define the size of the graph to be rendered
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
    //the following Lists is to convert the data into the appropriate datatype "FlSpot" for the linechart
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
            //define which borders is shown
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
              //smerte
              spots: smerteSpots, //datainput
              isCurved: false, //curved or straight lines
              color: Colors.blue, //color of line
              barWidth: 2, //width of line
              isStrokeCapRound: true,
              dotData: const FlDotData(show: true),
              show: showParametreStatus["Smerte"] ??
                  false, //whether or not the parametre should be shown
            ),
            LineChartBarData(
              //søvn
              spots: sleepSpots,
              isCurved: false,
              color: Colors.red,
              barWidth: 2,
              isStrokeCapRound: true,
              dotData: const FlDotData(show: true),
              show: showParametreStatus["Søvn"] ?? false,
            ),
            LineChartBarData(
              //social
              spots: socialSpots,
              isCurved: false,
              color: Colors.purple,
              barWidth: 2,
              isStrokeCapRound: true,
              dotData: const FlDotData(show: true),
              show: showParametreStatus["Social"] ?? false,
            ),
            LineChartBarData(
              //humør
              spots: moodSpots,
              isCurved: false,
              color: Colors.green,
              barWidth: 2,
              isStrokeCapRound: true,
              dotData: const FlDotData(show: true),
              show: showParametreStatus["Humør"] ?? false,
            ),
            LineChartBarData(
              //aktivitet
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
