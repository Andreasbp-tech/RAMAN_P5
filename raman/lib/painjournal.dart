import 'package:flutter/material.dart';
import 'navigationbars.dart';

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

  final List<String> activities = [
    'Exercise',
    'Læs en bog',
    'Meditation',
    'Work',
    'Træning',
    'Cook a meal',
    'Watch TV',
    'Go for a walk',
    'Play a game',
    'Listen to music',
    'Clean the house',
    'Do laundry',
  ];

  final Map<String, bool> activityStatus = {};

  @override
  void initState() {
    super.initState();
    for (var activity in activities) {
      activityStatus[activity] = false;
    }
  }

  void _finish() {
    // Handle the finish action, e.g., print the values or save them
    print('Pain: $painValue');
    print('Sleep: $sleepValue');
    print('Social: $socialValue');
    print('Mood: $moodValue');
    print('Activity: $activityValue');
    print('Activities: $activityStatus');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: Topappbar(pagename: "Smertedagbog"),
      bottomNavigationBar: const Bottomappbar(),
      body: Column(
        children: [
          CustomSlider(
            title: 'Hvor ondt har du haft i dag?',
            initialSliderValue: painValue,
            onChanged: (value) {
              setState(() {
                painValue = value;
              });
            },
          ),
          CustomSlider(
            title: 'Hvordan har du sovet i nat?',
            initialSliderValue: sleepValue,
            onChanged: (value) {
              setState(() {
                sleepValue = value;
              });
            },
          ),
          CustomSlider(
            title: 'Hvor social har du været i dag?',
            initialSliderValue: socialValue,
            onChanged: (value) {
              setState(() {
                socialValue = value;
              });
            },
          ),
          CustomSlider(
            title: 'Hvordan har dit humør været i dag?',
            initialSliderValue: moodValue,
            onChanged: (value) {
              setState(() {
                moodValue = value;
              });
            },
          ),
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
            height: MediaQuery.of(context).size.height *
                0.25, // Adjust the height as needed
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
            child: const Text('Finish'),
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

  @override
  void initState() {
    super.initState();
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
