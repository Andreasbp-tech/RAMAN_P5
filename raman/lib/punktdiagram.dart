import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:raman/navigationbars.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:intl/intl.dart';
import 'dart:math';

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
  Map<String, bool> showParametreStatus = {
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

  void updateParametre(Map<String, bool> parametre) {
    setState(() {
      showParametreStatus = parametre;
    });
  }

  void updateLength(String Length) {
    setState(() {
      chosenDataLength = Length;
      if (chosenDataLength == "Uge") {
        datasize = 7;
      } else if (chosenDataLength == "Måned") {
        datasize = 31;
      }
    });
  }

  Future<void> _fetchData() async {
    // The function for fetching data from the database
    DateTime now = DateTime.now();

    for (var i = fetchedDatasize; i >= 0; i--) {
      // Loop for running through the database, starting from today's date and going backwards
      DateTime date = now.subtract(Duration(days: i));
      String dateString = DateFormat('yyyy-MM-dd').format(date);
      String DateWithoutYYYY = DateFormat('dd-MM').format(date);
      DocumentReference docRef = FirebaseFirestore
          .instance // Instance for the program to fetch data from the database
          .collection("users")
          .doc(FirebaseAuth.instance.currentUser!.uid)
          .collection("dage")
          .doc(dateString)
          .collection("smertedagbog")
          .doc("VAS");
      DocumentSnapshot docSnapShot = await docRef.get();

      setState(() {
        if (docSnapShot.exists) {
          // When new data is acquired, save it at the appropriate data locations
          Map<String, dynamic> data =
              docSnapShot.data() as Map<String, dynamic>;
          smerteData.addEntries([MapEntry(DateWithoutYYYY, data["Smerte"])]);
          sleepData.addEntries([MapEntry(DateWithoutYYYY, data["Søvn"])]);
          socialData.addEntries([MapEntry(DateWithoutYYYY, data["Social"])]);
          moodData.addEntries([MapEntry(DateWithoutYYYY, data["Humør"])]);
          aktivitetsData.addEntries(
              [MapEntry(DateWithoutYYYY, data["Aktivitetsniveau"])]);
        } else {
          // Add null entries if the document does not exist
          smerteData.addEntries([MapEntry(DateWithoutYYYY, null)]);
          sleepData.addEntries([MapEntry(DateWithoutYYYY, null)]);
          socialData.addEntries([MapEntry(DateWithoutYYYY, null)]);
          moodData.addEntries([MapEntry(DateWithoutYYYY, null)]);
          aktivitetsData.addEntries([MapEntry(DateWithoutYYYY, null)]);
        }
      });
    }

    setState(() {
      // When data is finished loading, set the bool to false so that the page can be rendered
      isLoading = false;
    });

    // Debugging: remove in production
    print(smerteData);
  }

  Widget build(BuildContext context) {
    if (isLoading) {
      //loading page, that is active until data is loaded
      //TODO: add descriptive text of why the program is loading
      return Scaffold(
        backgroundColor: const Color.fromARGB(255, 243, 243, 228),
        appBar: Topappbar(pagename: "Punktdiagram"),
        body: const Center(child: CircularProgressIndicator()),
      );
    }
    return Scaffold(
      //the rendering of the page
      backgroundColor: const Color.fromARGB(255, 243, 243, 228),

      appBar: Topappbar(pagename: "Punktdiagram"),
      bottomNavigationBar: const Bottomappbar(),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Expanded(
                child: OptionsMenu(
                  items: showParametreStatus,
                  updatedItems: updateParametre,
                ),
              ),
              Expanded(
                child: OptionsMenuSingle(
                  items: lengthOfDataStatus,
                  updatedItem: updateLength,
                  selectedItem: chosenDataLength,
                ),
              )
            ],
          ),
          const Divider(
            height: 10,
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
      ),
    );
  }
}

class OptionsMenu extends StatefulWidget {
  final Map<String, bool> items;
  final Function(Map<String, bool>) updatedItems;

  OptionsMenu({
    Key? key,
    required this.items,
    required this.updatedItems,
  }) : super(key: key);

  @override
  State<OptionsMenu> createState() => _OptionsMenuState();
}

class _OptionsMenuState extends State<OptionsMenu> {
  void _itemChange(String itemValue, bool isSelected) {
    setState(() {
      widget.items[itemValue] = isSelected;
    });
    widget.updatedItems(widget.items);
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Vælg parametre',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
          Column(
            children: widget.items.keys.map((item) {
              return CheckboxListTile(
                value: widget.items[item],
                title: Text(item),
                controlAffinity: ListTileControlAffinity.leading,
                onChanged: (isChecked) {
                  _itemChange(item, isChecked!);
                },
              );
            }).toList(),
          ),
        ],
      ),
    );
  }
}

class OptionsMenuSingle extends StatefulWidget {
  final List<String> items;
  final Function(String) updatedItem;
  String? selectedItem;

  OptionsMenuSingle({
    Key? key,
    required this.items,
    required this.updatedItem,
    required this.selectedItem,
  }) : super(key: key);

  @override
  State<OptionsMenuSingle> createState() => _OptionsMenuSingleState();
}

class _OptionsMenuSingleState extends State<OptionsMenuSingle> {
  void _itemChange(String itemValue) {
    setState(() {
      widget.selectedItem = itemValue;
    });
    widget.updatedItem(itemValue);
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Vælg tidsramme',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
          Column(
            children: widget.items.map((item) {
              return RadioListTile<String>(
                value: item,
                groupValue: widget.selectedItem,
                title: Text(item),
                onChanged: (value) {
                  if (value != null) {
                    _itemChange(value);
                  }
                },
              );
            }).toList(),
          ),
        ],
      ),
    );
  }
}

class DropDownMenuWithSingleTrue extends StatefulWidget {
  final List<String> items;
  final Function(String) updatedItem;
  String? selectedItem;

  DropDownMenuWithSingleTrue(
      {super.key,
      required this.items,
      required this.updatedItem,
      required this.selectedItem});

  @override
  State<DropDownMenuWithSingleTrue> createState() =>
      _DropDownMenuWithSingleTrueState();
}

class _DropDownMenuWithSingleTrueState
    extends State<DropDownMenuWithSingleTrue> {
  bool _isDropdownOpen = false;

  void _itemChange(String itemValue) {
    setState(() {
      widget.selectedItem = itemValue;
    });
    widget.updatedItem(itemValue);
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          GestureDetector(
            onTap: () {
              setState(() {
                _isDropdownOpen = !_isDropdownOpen;
              });
            },
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 15),
              decoration: BoxDecoration(
                border: Border.all(color: Colors.grey),
                borderRadius: BorderRadius.circular(5),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    /*widget.selectedItem == null
                        ?*/
                    'vælg tidsramme' /*: widget.selectedItem!*/,
                  ),
                  Icon(
                    _isDropdownOpen
                        ? Icons.arrow_drop_up
                        : Icons.arrow_drop_down,
                  ),
                ],
              ),
            ),
          ),
          if (_isDropdownOpen)
            Column(
              children: widget.items.map((item) {
                return RadioListTile<String>(
                  value: item,
                  groupValue: widget.selectedItem,
                  title: Text(item),
                  onChanged: (value) {
                    if (value != null) {
                      _itemChange(value);
                      widget.updatedItem(value);
                    }
                  },
                );
              }).toList(),
            ),
        ],
      ),
    );
  }
}

class LineChartSample extends StatelessWidget {
  final Map<String, dynamic> smerteData;
  final Map<String, dynamic> sleepData;
  final Map<String, dynamic> socialData;
  final Map<String, dynamic> moodData;
  final Map<String, dynamic> aktivitetsData;
  final Map<String, bool> showParametreStatus;
  final int datasize;

  LineChartSample({
    Key? key,
    required this.smerteData,
    required this.sleepData,
    required this.socialData,
    required this.moodData,
    required this.aktivitetsData,
    required this.showParametreStatus,
    required this.datasize,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    int actualDataSize =
        smerteData.length < datasize ? smerteData.length : datasize;

    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: LineChart(
        LineChartData(
          minX: 0,
          maxX: actualDataSize.toDouble() - 1,
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
          gridData: FlGridData(
            show: true,
            drawVerticalLine: true,
            verticalInterval: 1,
            horizontalInterval: 1,
            getDrawingVerticalLine: (value) {
              if (value.toInt() >= 0 && value.toInt() < actualDataSize) {
                return const FlLine(
                  color: Colors.grey,
                  strokeWidth: 1,
                );
              } else {
                return FlLine(
                  color: Colors.transparent,
                );
              }
            },
            getDrawingHorizontalLine: (value) {
              return const FlLine(
                color: Colors.grey,
                strokeWidth: 1,
              );
            },
          ),
          lineBarsData: _createLineBarsData(actualDataSize),
          titlesData: FlTitlesData(
            bottomTitles: AxisTitles(
              sideTitles: SideTitles(
                showTitles: true,
                getTitlesWidget: (value, meta) {
                  if (value.toInt() >= 0 && value.toInt() < actualDataSize) {
                    return Transform.rotate(
                      angle: -pi / 2, // Rotate 90 degrees
                      child: Text(smerteData.keys.elementAt(value.toInt())),
                    );
                  } else {
                    return const SizedBox.shrink();
                  }
                },
              ),
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

  List<LineChartBarData> _createLineBarsData(int actualDataSize) {
    return [
      if (showParametreStatus["Smerte"] ?? false)
        LineChartBarData(
          spots: _createFlSpots(smerteData, actualDataSize),
          isCurved: false,
          color: Colors.blue,
          barWidth: 2,
          isStrokeCapRound: true,
          dotData: const FlDotData(show: true),
        ),
      if (showParametreStatus["Søvn"] ?? false)
        LineChartBarData(
          spots: _createFlSpots(sleepData, actualDataSize),
          isCurved: false,
          color: Colors.red,
          barWidth: 2,
          isStrokeCapRound: true,
          dotData: const FlDotData(show: true),
        ),
      if (showParametreStatus["Social"] ?? false)
        LineChartBarData(
          spots: _createFlSpots(socialData, actualDataSize),
          isCurved: false,
          color: Colors.purple,
          barWidth: 2,
          isStrokeCapRound: true,
          dotData: const FlDotData(show: true),
        ),
      if (showParametreStatus["Humør"] ?? false)
        LineChartBarData(
          spots: _createFlSpots(moodData, actualDataSize),
          isCurved: false,
          color: Colors.green,
          barWidth: 2,
          isStrokeCapRound: true,
          dotData: const FlDotData(show: true),
        ),
      if (showParametreStatus["Aktivitet"] ?? false)
        LineChartBarData(
          spots: _createFlSpots(aktivitetsData, actualDataSize),
          isCurved: false,
          color: Colors.amber,
          barWidth: 2,
          isStrokeCapRound: true,
          dotData: const FlDotData(show: true),
        ),
    ];
  }

  List<FlSpot> _createFlSpots(Map<String, dynamic> data, int actualDataSize) {
    List<MapEntry<String, dynamic>> reversedEntries =
        data.entries.toList().reversed.toList();
    return reversedEntries
        .asMap()
        .entries
        .map((entry) {
          int index = entry.key;
          var value = entry.value.value;
          return value != null
              ? FlSpot((actualDataSize - 1 - index).toDouble(), value)
              : FlSpot.nullSpot;
        })
        .take(actualDataSize)
        .toList();
  }
}
