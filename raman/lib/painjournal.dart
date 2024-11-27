import 'dart:convert';
import 'package:flutter/material.dart';
import 'navigationbars.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'errormessage.dart';
import 'popupsmertedagbog.dart';
import 'package:intl/intl.dart';
import 'globals.dart' as globals;
import 'fetch_data.dart' as data;

int painjournalNavigationIndex = 0;

class PainJournal extends StatefulWidget {
  const PainJournal({super.key});

  @override
  State<PainJournal> createState() => _PainJournalState();
}

class _PainJournalState extends State<PainJournal> {
  double painValue = 5;
  double sleepValue = 5;
  double socialValue = 5;
  double moodValue = 5;
  double activityValue = 5;
  //final Map<String, bool> activityStatus = {};
  //Map<String, dynamic> activityPrevalance = {};
  //Map<String, dynamic> activityPrevalanceSorted = {};
  List<MapEntry<String, int>> activityPrevalanceSortedEntries = [];
  //bool isCheckedButton1 = false;
  //bool isCheckedButton2 = false;
  //bool isCheckedButton3 = false;
  Map<String, bool> activitiesBoolMap = {};
  //int prevalenceLength = 14;

  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _fetchData();
  }

  void _fetchData() {
    painValue = data.painValue;
    sleepValue = data.sleepValue;
    socialValue = data.socialValue;
    moodValue = data.moodValue;
    activityValue = data.activityValue;
    activityPrevalanceSortedEntries = data.activityPrevalanceSortedEntries;
    activitiesBoolMap = data.activitiesBoolMap;
    isLoading = false;
    print(painValue);
    print("\n");
    print(sleepValue);
    print("\n");
    print(socialValue);
    print("\n");
    print(moodValue);
    print("\n");
    print(activityValue);
    print("\n");
    print(activityPrevalanceSortedEntries);
    print("\n");
    print(activitiesBoolMap);
    print("\n");
    print(isLoading);
    print("\n");
  }

  void _finish() {
    print(activitiesBoolMap);
    DateTime now = DateTime.now();
    String dagsDato = DateFormat('yyyy-MM-dd').format(now);
    FirebaseFirestore.instance
        .collection("users")
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .collection("dage")
        .doc(dagsDato)
        .collection("smertedagbog")
        .doc("VAS")
        .set(
      {
        "Smerte": painValue,
        "Søvn": sleepValue,
        "Social": socialValue,
        "Humør": moodValue,
        "Aktivitetsniveau": activityValue,
      },
    );
    FirebaseFirestore.instance
        .collection("users")
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .collection("dage")
        .doc(dagsDato)
        .collection("smertedagbog")
        .doc("aktiviteter")
        .set(
      {"Aktivitetsliste": activitiesBoolMap},
    );

    showMyPopup(context, 'Godt arbejde!',
        "Vil du gå til hjemmeskærm eller opsummering?");
  }

  void _showMultiSelect(Map<String, bool> items) async {
    final Map<String, bool>? results = await showDialog(
      context: context,
      builder: (BuildContext context) {
        return MultiSelect(items: items);
      },
    );

    if (results != null) {
      setState(() {
        activitiesBoolMap = results;
      });
    }
    print(activitiesBoolMap);
  }

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return Scaffold(
        backgroundColor: const Color.fromARGB(255, 243, 243, 228),
        appBar: Topappbar(pagename: "Smertedagbog"),
        body: const Center(child: CircularProgressIndicator()),
      );
    }

    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 243, 243, 228),
      appBar: Topappbar(pagename: "Smertedagbog"),
      bottomNavigationBar: const Bottomappbar(),
      body: SingleChildScrollView(
        child: Column(
          children: [
            if (painValue != null)
              InverseCustomSlider(
                title: 'Hvor ondt har du haft i dag?',
                initialSliderValue: painValue,
                onChanged: (value) {
                  setState(() {
                    painValue = value;
                  });
                },
              ),
            if (sleepValue != null)
              CustomSlider(
                title: 'Hvordan har du sovet i nat?',
                initialSliderValue: sleepValue,
                onChanged: (value) {
                  setState(() {
                    sleepValue = value;
                  });
                },
              ),
            if (socialValue != null)
              CustomSlider(
                title: 'Hvor social har du været i dag?',
                initialSliderValue: socialValue,
                onChanged: (value) {
                  setState(() {
                    socialValue = value;
                  });
                },
              ),
            if (moodValue != null)
              CustomSlider(
                title: 'Hvordan har dit humør været i dag?',
                initialSliderValue: moodValue,
                onChanged: (value) {
                  setState(() {
                    moodValue = value;
                  });
                },
              ),
            if (activityValue != null)
              CustomSlider(
                title: 'Hvor aktiv har du været i dag?',
                initialSliderValue: activityValue,
                onChanged: (value) {
                  setState(() {
                    activityValue = value;
                  });
                },
              ),
            const Divider(),
            const SizedBox(height: 10),
            const Text(
              'Hvilke aktiviteter har du udført i dag?',
              style: TextStyle(fontSize: 20),
            ),
            const SizedBox(height: 3),
            const Divider(),
            SizedBox(
                height: MediaQuery.of(context).size.height * 0.25,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        ElevatedButton(
                          onPressed: () {
                            setState(() {
                              activitiesBoolMap[
                                      activityPrevalanceSortedEntries[0].key] =
                                  !activitiesBoolMap[
                                      activityPrevalanceSortedEntries[0].key]!;
                            });
                          },
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Checkbox(
                                value: activitiesBoolMap[
                                    activityPrevalanceSortedEntries[0].key],
                                onChanged: (bool? value) {
                                  setState(() {
                                    activitiesBoolMap[
                                        activityPrevalanceSortedEntries[0]
                                            .key] = value!;
                                  });
                                },
                              ),
                              Text('${activityPrevalanceSortedEntries[0].key}'),
                            ],
                          ),
                        ),
                        ElevatedButton(
                          onPressed: () {
                            setState(() {
                              activitiesBoolMap[
                                      activityPrevalanceSortedEntries[1].key] =
                                  !activitiesBoolMap[
                                      activityPrevalanceSortedEntries[1].key]!;
                            });
                          },
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Checkbox(
                                value: activitiesBoolMap[
                                    activityPrevalanceSortedEntries[1].key],
                                onChanged: (bool? value) {
                                  setState(() {
                                    activitiesBoolMap[
                                        activityPrevalanceSortedEntries[1]
                                            .key] = value!;
                                  });
                                },
                              ),
                              Text('${activityPrevalanceSortedEntries[1].key}'),
                            ],
                          ),
                        ),
                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        ElevatedButton(
                          onPressed: () {
                            setState(() {
                              activitiesBoolMap[
                                      activityPrevalanceSortedEntries[2].key] =
                                  !activitiesBoolMap[
                                      activityPrevalanceSortedEntries[2].key]!;
                            });
                          },
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Checkbox(
                                value: activitiesBoolMap[
                                    activityPrevalanceSortedEntries[2].key],
                                onChanged: (bool? value) {
                                  setState(() {
                                    activitiesBoolMap[
                                        activityPrevalanceSortedEntries[2]
                                            .key] = value!;
                                  });
                                },
                              ),
                              Text('${activityPrevalanceSortedEntries[2].key}'),
                            ],
                          ),
                        ),
                        ElevatedButton(
                            onPressed: () {
                              _showMultiSelect(activitiesBoolMap);
                            },
                            child: const Text("Flere aktiviteter")),
                      ],
                    )
                  ],
                )),
            const Divider(),
            ElevatedButton(
              onPressed: _finish,
              child: const Text('Færdig'),
            ),
          ],
        ),
      ),
    );
  }
}

class CustomSlider extends StatefulWidget {
  final String title;
  final double initialSliderValue;
  final ValueChanged<double> onChanged;

  const CustomSlider({
    super.key,
    required this.title,
    required this.initialSliderValue,
    required this.onChanged,
  });

  @override
  State<CustomSlider> createState() => _CustomSliderState();
}

class _CustomSliderState extends State<CustomSlider> {
  late double _currentSliderValue;

  void readData() async {
    DateTime now = DateTime.now();
    String dagsDato = DateFormat('yyyy-MM-dd').format(now);
    String userId = FirebaseAuth.instance.currentUser!.uid;

    DocumentSnapshot documentSnapshot = await FirebaseFirestore.instance
        .collection("users")
        .doc(userId)
        .collection("dage")
        .doc(dagsDato)
        .collection("smertedagbog")
        .doc("VAS")
        .get();

    if (documentSnapshot.exists) {
      Map<String, dynamic> data =
          documentSnapshot.data() as Map<String, dynamic>;
      setState(() {
        _currentSliderValue = data[widget.title] ?? widget.initialSliderValue;
      });
    } else {
      print('No such document!');
    }
  }

  @override
  void initState() {
    super.initState();
    readData();
    _currentSliderValue = widget.initialSliderValue;
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Text(
            widget.title,
            style: const TextStyle(fontSize: 20),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Padding(
                padding: EdgeInsets.only(left: 15.0),
                child: Text('0'),
              ),
              Expanded(
                child: SliderTheme(
                  data: SliderTheme.of(context).copyWith(
                    activeTrackColor: _getSliderColor(_currentSliderValue),
                    thumbColor: _getSliderColor(_currentSliderValue),
                  ),
                  child: Slider(
                    value: _currentSliderValue,
                    max: 10,
                    divisions: 100,
                    label: _currentSliderValue.toStringAsFixed(1),
                    onChanged: (double value) {
                      setState(() {
                        _currentSliderValue = value;
                      });
                      widget.onChanged(value);
                    },
                  ),
                ),
              ),
              const Padding(
                padding: EdgeInsets.only(right: 15.0),
                child: Text('10'),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Color _getSliderColor(double value) {
    double ratio = value / 10;
    if (ratio <= 0.5) {
      // Transition from red to yellow
      return Color.lerp(Colors.red, Colors.yellow, ratio * 2)!;
    } else {
      // Transition from yellow to green
      return Color.lerp(Colors.yellow, Colors.green, (ratio - 0.5) * 2)!;
    }
  }
}

class InverseCustomSlider extends StatefulWidget {
  final String title;
  final double initialSliderValue;
  final ValueChanged<double> onChanged;

  const InverseCustomSlider({
    super.key,
    required this.title,
    required this.initialSliderValue,
    required this.onChanged,
  });

  @override
  State<InverseCustomSlider> createState() => _InverseCustomSliderState();
}

class _InverseCustomSliderState extends State<InverseCustomSlider> {
  late double _currentSliderValue;

  void readData() async {
    DateTime now = DateTime.now();
    String dagsDato = DateFormat('yyyy-MM-dd').format(now);
    String userId = FirebaseAuth.instance.currentUser!.uid;

    DocumentSnapshot documentSnapshot = await FirebaseFirestore.instance
        .collection("users")
        .doc(userId)
        .collection("dage")
        .doc(dagsDato)
        .collection("smertedagbog")
        .doc("VAS")
        .get();

    if (documentSnapshot.exists) {
      Map<String, dynamic> data =
          documentSnapshot.data() as Map<String, dynamic>;
      setState(() {
        _currentSliderValue = data[widget.title] ?? widget.initialSliderValue;
      });
    } else {
      print('No such document!');
    }
  }

  @override
  void initState() {
    super.initState();
    readData();
    _currentSliderValue = widget.initialSliderValue;
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Text(
            widget.title,
            style: const TextStyle(fontSize: 20),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Padding(
                padding: EdgeInsets.only(left: 15.0),
                child: Text('0'),
              ),
              Expanded(
                child: SliderTheme(
                  data: SliderTheme.of(context).copyWith(
                    activeTrackColor:
                        _getinverseSliderColor(_currentSliderValue),
                    thumbColor: _getinverseSliderColor(_currentSliderValue),
                  ),
                  child: Slider(
                    value: _currentSliderValue,
                    max: 10,
                    divisions: 100,
                    label: _currentSliderValue.toStringAsFixed(1),
                    onChanged: (double value) {
                      setState(() {
                        _currentSliderValue = value;
                      });
                      widget.onChanged(value);
                    },
                  ),
                ),
              ),
              const Padding(
                padding: EdgeInsets.only(right: 15.0),
                child: Text('10'),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Color _getinverseSliderColor(double value) {
    double ratio = value / 10;
    if (ratio <= 0.5) {
      // Transition from red to yellow
      return Color.lerp(Colors.green, Colors.yellow, ratio * 2)!;
    } else {
      // Transition from yellow to green
      return Color.lerp(Colors.yellow, Colors.red, (ratio - 0.5) * 2)!;
    }
  }
}

class CheckboxList extends StatelessWidget {
  final List<String> activities;
  final Map<String, bool> activityStatus;
  final Function(String, bool) onChanged;

  const CheckboxList({
    super.key,
    required this.activities,
    required this.activityStatus,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: activities.map((activity) {
        return CheckboxListTile(
          title: Text(activity),
          value: activityStatus[activity] ?? false,
          onChanged: (bool? value) {
            onChanged(activity, value ?? false);
          },
        );
      }).toList(),
    );
  }
}

class MultiSelect extends StatefulWidget {
  final Map<String, bool> items;
  const MultiSelect({Key? key, required this.items}) : super(key: key);

  @override
  State<MultiSelect> createState() => _MultiSelectState();
}

class _MultiSelectState extends State<MultiSelect> {
  late Map<String, bool> _selectedItems;
  final TextEditingController _textController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _selectedItems = Map.from(widget.items);
  }

  void _itemChange(String itemValue, bool isSelected) {
    setState(() {
      _selectedItems[itemValue] = isSelected;
    });
  }

  void _addItem() {
    String newItem = _textController.text.trim();
    if (newItem.isNotEmpty && !_selectedItems.containsKey(newItem)) {
      setState(() {
        _selectedItems[newItem] = true; // Set the new item to true
      });
      _textController.clear();
    }
  }

  void _cancel() {
    Navigator.pop(context);
  }

  void _submit() {
    Navigator.pop(context, _selectedItems);
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Tilføj aktiviteter'),
      content: SingleChildScrollView(
        child: Column(
          children: [
            TextField(
              controller: _textController,
              decoration: InputDecoration(
                labelText: 'Ny aktivitet',
                suffixIcon: IconButton(
                  icon: const Icon(Icons.add),
                  onPressed: _addItem,
                ),
              ),
            ),
            const SizedBox(height: 10),
            ListBody(
              children: _selectedItems.keys.map((item) {
                return CheckboxListTile(
                  value: _selectedItems[item]!,
                  title: Text(item),
                  controlAffinity: ListTileControlAffinity.leading,
                  onChanged: (isChecked) => _itemChange(item, isChecked!),
                );
              }).toList(),
            ),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: _cancel,
          child: const Text('Annuller'),
        ),
        ElevatedButton(
          onPressed: _submit,
          child: const Text('Accepter'),
        ),
      ],
    );
  }
}
