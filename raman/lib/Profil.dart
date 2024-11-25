import 'dart:math';

import 'package:flutter/material.dart';
import 'package:raman/navigationbars.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';
//import 'globals.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'popupsmertedagbog.dart';

class Profil extends StatefulWidget {
  const Profil({super.key});

  @override
  State<Profil> createState() => _ProfilState();
}

class _ProfilState extends State<Profil> {
  double painValue = 5;
  double sleepValue = 5;
  double socialValue = 5;
  double moodValue = 5;
  double activityValue = 5;

  void _generateData() {
    DateTime now = DateTime.now();
    for (var i = 0; i < 30; i++) {
      painValue = double.parse((Random().nextDouble() * 10).toStringAsFixed(1));
      sleepValue =
          double.parse((Random().nextDouble() * 10).toStringAsFixed(1));
      socialValue =
          double.parse((Random().nextDouble() * 10).toStringAsFixed(1));
      moodValue = double.parse((Random().nextDouble() * 10).toStringAsFixed(1));
      activityValue =
          double.parse((Random().nextDouble() * 10).toStringAsFixed(1));

      DateTime date = now.subtract(Duration(days: i));
      String dagsDato = DateFormat('yyyy-MM-dd').format(date);
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
    }
    print(painValue);
    showMyPopup(context, 'Godt arbejde!',
        "Vil du gå til hjemmeskærm eller opsummering?");
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 243, 243, 228),
      appBar: Topappbar(pagename: "Profil"),
      bottomNavigationBar: BottomAppBar(),
      body: ElevatedButton(
          onPressed: _generateData,
          child: const Text('Tryk for at generere en måneds data')),
    );
  }
}
