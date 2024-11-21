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

Future<void> _data() async {
  DateTime now = DateTime.now();
  final Map<String, dynamic> SmerteData = {};
  for (var i = 0; i < 30; i++) {
    DateTime date = now.subtract(Duration(days: i));
    String dateString = DateFormat('yyyy-MM-dd').format(now);
    DocumentReference docRef = FirebaseFirestore.instance
        .collection("users")
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .collection("dage")
        .doc(dateString)
        .collection("smertedagbog")
        .doc("smertedagbog");
    DocumentSnapshot docSnapShot = await docRef.get();
    var data = docSnapShot.data() as Map<String, dynamic>;
    SmerteData.addEntries(newEntries)
  }

  print("jeg printer smerte: ${data["Smerte"]}");
  print(data);
}

class _PunktdiagramState extends State<Punktdiagram> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: Topappbar(pagename: "Punktdiagram"),
      bottomNavigationBar: const BottomAppBar(),
      body: LineChartSample(),
    );
  }
}

class LineChartSample extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: ElevatedButton(onPressed: _data, child: const Text('Færdig')),
      // child: LineChart(
      //   LineChartData(
      //     borderData: FlBorderData(
      //       show: true,
      //       border: const Border(
      //         bottom: BorderSide(color: Colors.black, width: 2),
      //         left: BorderSide(color: Colors.black, width: 2),
      //         top: BorderSide(color: Colors.transparent),
      //         right: BorderSide(color: Colors.transparent),
      //       ),
      //     ),
      //     titlesData: const FlTitlesData(
      //       topTitles: AxisTitles(
      //         sideTitles: SideTitles(showTitles: false),
      //       ),
      //       rightTitles: AxisTitles(
      //         sideTitles: SideTitles(showTitles: false),
      //       ),
      //     ),
      //     lineBarsData: [
      //       LineChartBarData(
      //         spots: [
      //           FlSpot(0, 1),
      //           FlSpot(1, 3),
      //           FlSpot(2, 10),
      //           FlSpot(3, 7),
      //           FlSpot(4, 12),
      //           FlSpot(5, 13),
      //           FlSpot(6, 17),
      //           FlSpot(7, 15),
      //           FlSpot(8, 20),
      //         ],
      //         isCurved: false,
      //         color: Colors.blue,
      //         barWidth: 4,
      //         isStrokeCapRound: true,
      //         dotData: FlDotData(show: true),
      //       ),
      //     ],
      //   ),
      // ),
    );
  }
}
