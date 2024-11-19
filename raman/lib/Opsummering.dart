import 'package:flutter/material.dart';
import 'navigationbars.dart';
import 'opsummering.dart';
import 'homepage.dart';
import 'globals.dart' as globals;
import 'painjournal.dart';
import 'loginpage.dart';
import 'radardiagram.dart';
import 'punktdiagram.dart';
import 'laromdinsmerte.dart';

class Opsummering extends StatefulWidget {
  const Opsummering({super.key});

  @override
  State<Opsummering> createState() => _OpsummeringState();
}

class _OpsummeringState extends State<Opsummering> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFC8E6C9),
      appBar: Topappbar(pagename: "Opsummering"),
      bottomNavigationBar: const Bottomappbar(),
      body: Padding(
        padding: const EdgeInsets.symmetric(
            horizontal: 16.0), // Margen ud til kanten
        child: Column(
          children: [
            Spacer(), // Tomt mellemrum før første række
            Row(
              mainAxisAlignment: MainAxisAlignment
                  .spaceEvenly, // Ensartet spacing mellem knapper
              children: [
                Expanded(
                  child: ElevatedButton(
                    onPressed: () {Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (BuildContext context) {
                            return  RadardiagramPage();
                          },
                        ),
                      );},
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 60),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.radar_rounded, size: 24),
                        SizedBox(width: 8),
                        Text('Radardiagram', style: TextStyle(fontSize: 20)),
                      ],
                    ),
                  ),
                ),
              ],
            ),
            Spacer(),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Expanded(
                  child: ElevatedButton(
                    onPressed: () {Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (BuildContext context) {
                            return  PunktdiagramPage();
                          },
                        ),
                      );},
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 60),
                    ),
                    child: Row(
                      
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.show_chart, size: 24),
                        SizedBox(width: 8),
                        Text('Punktdiagram', style: TextStyle(fontSize: 20)),
                      ],
                    ),
                  ),
                ),
              ],
            ),
            Spacer(),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Expanded(
                  child: ElevatedButton(
                    onPressed: () {Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (BuildContext context) {
                            return LaromdinsmertePage();
                          },
                        ),
                      );},
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 60),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.insert_chart_outlined_outlined, size: 24),
                        SizedBox(width: 8),
                        Text('Lær om din smerte',
                            style: TextStyle(fontSize: 20)),
                      ],
                    ),
                  ),
                ),
              ],
            ),
            Spacer(),
          ],
        ),
      ),
    );
  }
}

class RadardiagramPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Radardiagram')),
      body: Center(child: Text('Indhold for Radardiagram-siden')),
    );
  }
}

class PunktdiagramPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Punktdiagram')),
      body: Center(child: Text('Indhold for Punktdiagram-siden')),
    );
  }
}

class LaromdinsmertePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Lær om din smerte')),
      body: Center(child: Text('Indhold for Lær om din smerte-siden')),
    );
  }
}
