import 'dart:convert';
import 'package:flutter/material.dart';
import 'navigationbars.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'errormessage.dart';
import 'popupsmertedagbog.dart';
import 'package:intl/intl.dart';
import 'globals.dart';

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
  final Map<String, bool> activityStatus = {};

  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _fetchData();
  }

  Future<void> _fetchData() async {
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
        painValue = data['Smerte']?.toDouble() ?? 5.0;
        sleepValue = data['Søvn']?.toDouble() ?? 5.0;
        socialValue = data['Social']?.toDouble() ?? 5.0;
        moodValue = data['Humør']?.toDouble() ?? 5.0;
        activityValue = data['Aktivitetsniveau']?.toDouble() ?? 5.0;

        for (var activity in activities) {
          activityStatus[activity] =
              data['Aktivitetsliste']?.contains(activity) ?? false;
        }

        isLoading = false;
      });
    } else {
      setState(() {
        isLoading = false;
      });
      print('No such document!');
    }
  }

  void _finish() {
    List<String> trueActivities = [];

    for (var activity in activities) {
      if (activityStatus[activity] == true) {
        trueActivities.add(activity);
      }
    }

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
      {"Aktivitetsliste": activityStatus},
    );

    showMyPopup(context, 'Godt arbejde!',
        "Vil du gå til hjemmeskærm eller opsummering?");
  }

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return Scaffold(
        appBar: Topappbar(pagename: "Smertedagbog"),
        body: const Center(child: CircularProgressIndicator()),
      );
    }

    return Scaffold(
      appBar: Topappbar(pagename: "Smertedagbog"),
      bottomNavigationBar: const Bottomappbar(),
      body: Column(
        children: [
          if (painValue != null)
            CustomSlider(
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
            child: Scrollbar(
              thumbVisibility: true,
              child: SingleChildScrollView(
                child: CheckboxList(
                  activities: activities,
                  activityStatus: activityStatus,
                  onChanged: (activity, value) {
                    setState(() {
                      activityStatus[activity] = value;
                    });
                  },
                ),
              ),
            ),
          ),
          const Divider(),
          ElevatedButton(
            onPressed: _finish,
            child: const Text('Færdig'),
          ),
        ],
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
