import 'package:flutter/material.dart';
import 'navigationbars.dart';

class PainJournal extends StatefulWidget {
  const PainJournal({super.key});

  @override
  State<PainJournal> createState() => _PainJournalState();
}

class _PainJournalState extends State<PainJournal> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: Topappbar(pagename: "Smertedagbog"),
      bottomNavigationBar: const Bottomappbar(),
      body: const SliderExample(),
    );
  }
}

class SliderExample extends StatefulWidget {
  const SliderExample({super.key});

  @override
  State<SliderExample> createState() => _SliderExampleState();
}

class _SliderExampleState extends State<SliderExample> {
  double _currentSliderValue = 5;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      //appBar: AppBar(title: const Text('Slider')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              'Hvor ondt har du haft i dag?',
              style: TextStyle(fontSize: 20),
            ),
            SliderTheme(
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
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Color _getSliderColor(double value) {
    double ratio = value / 10;
    return Color.lerp(Colors.red, Colors.green, ratio)!;
  }
}



//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       //appBar: AppBar(title: const Text('Slider')),
//       body: Slider(
//         value: _currentSliderValue,
//         max: 10,
//         divisions: 100,
//         label: _currentSliderValue.toStringAsFixed(1),
//         onChanged: (double value) {
//           setState(() {
//             _currentSliderValue = value;
//           });
//         },
//       ),
//     );
//   }
// }
