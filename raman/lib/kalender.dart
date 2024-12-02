import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'navigationbars.dart';

class KalenderWidget extends StatefulWidget {
  const KalenderWidget({super.key});
  @override
  State<KalenderWidget> createState() => _KalenderWidgetState();
}

class _KalenderWidgetState extends State<KalenderWidget> {
  DateTime _selectedDate = DateTime.now();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 243, 243, 228),
      appBar: Topappbar(pagename: "Kalender"),
      bottomNavigationBar: const Bottomappbar(),
      body: Column(
        children: [
          Expanded(
            child: PageView.builder(
              reverse: true,
              itemBuilder: (context, index) {
                DateTime month = DateTime(
                    _selectedDate.year, _selectedDate.month - index, 1);
                return MonthView(month: month);
              },
            ),
          ),
        ],
      ),
    );
  }
}

class MonthView extends StatelessWidget {
  final DateTime month;

  MonthView({required this.month});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          DateFormat.yMMMM().format(month),
          style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
        ),
        Expanded(
          child: GridView.builder(
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 7, // 7 days a week
            ),
            itemCount: DateTime(month.year, month.month + 1, 0).day,
            itemBuilder: (context, index) {
              DateTime day = DateTime(month.year, month.month, index + 1);
              return Center(
                child: Text(
                  DateFormat.d().format(day),
                  style: TextStyle(fontSize: 16),
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}
