import 'package:flutter/material.dart';
import 'package:raman/homepage.dart';
import 'package:raman/navigationbars.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:intl/intl.dart';
import 'package:raman/opsummering.dart';

int prevalenceLength = 14;
int fetchVASDatasize = 31;
int fetchGodeOgDaarligeDageDataSize = 31;
double painValue = 5;
double sleepValue = 5;
double socialValue = 5;
double moodValue = 5;
double activityValue = 5;
Map<String, dynamic> smerteData = {};
Map<String, dynamic> sleepData = {};
Map<String, dynamic> socialData = {};
Map<String, dynamic> moodData = {};
Map<String, dynamic> aktivitetsData = {};
Map<String, dynamic> activityPrevalance = {};
Map<String, bool> activitiesBoolMap = {};
List<MapEntry<String, int>> activityPrevalanceSortedEntries = [];

class LoadingDataPage extends StatefulWidget {
  int pageIndex = 0;
  bool isLoading = true;
  LoadingDataPage({super.key, required this.pageIndex});

  @override
  State<LoadingDataPage> createState() => _LoadingDataPageState();
}

class _LoadingDataPageState extends State<LoadingDataPage> {
  //start of punktdiagram fetching
  bool isLoading = true;
  Future<void> _fetchData() async {
    DateTime now = DateTime.now();
    String userUID = FirebaseAuth.instance.currentUser!.uid;
    String dagsDato = DateFormat('yyyy-MM-dd').format(now);
    for (var i = fetchGodeOgDaarligeDageDataSize; i >= 0; i--) {
      // Loop for running through the database, starting from today's date and going backwards
      DateTime date = now.subtract(Duration(days: i));
      String dateString = DateFormat('yyyy-MM-dd').format(date);
      String dateWithoutYYYY = DateFormat('dd-MM').format(date);
      DocumentReference docRef = FirebaseFirestore
          .instance // Instance for the program to fetch data from the database
          .collection("users")
          .doc(userUID)
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
          smerteData.addEntries([MapEntry(dateWithoutYYYY, data["Smerte"])]);
          sleepData.addEntries([MapEntry(dateWithoutYYYY, data["Søvn"])]);
          socialData.addEntries([MapEntry(dateWithoutYYYY, data["Social"])]);
          moodData.addEntries([MapEntry(dateWithoutYYYY, data["Humør"])]);
          aktivitetsData.addEntries(
              [MapEntry(dateWithoutYYYY, data["Aktivitetsniveau"])]);
        } else {
          // Add null entries if the document does not exist
          smerteData.addEntries([MapEntry(dateWithoutYYYY, null)]);
          sleepData.addEntries([MapEntry(dateWithoutYYYY, null)]);
          socialData.addEntries([MapEntry(dateWithoutYYYY, null)]);
          moodData.addEntries([MapEntry(dateWithoutYYYY, null)]);
          aktivitetsData.addEntries([MapEntry(dateWithoutYYYY, null)]);
        }
      });
    }
    try {
      DocumentSnapshot documentSnapshot = await FirebaseFirestore.instance
          .collection("users")
          .doc(userUID)
          .collection("dage")
          .doc(dagsDato)
          .collection("smertedagbog")
          .doc("VAS")
          .get();

      DocumentSnapshot documentSnapshot2 = await FirebaseFirestore.instance
          .collection("users")
          .doc(userUID)
          .collection("dage")
          .doc(dagsDato)
          .collection("smertedagbog")
          .doc("aktiviteter")
          .get();

      if (documentSnapshot.exists) {
        Map<String, dynamic> data =
            documentSnapshot.data() as Map<String, dynamic>;
        if (documentSnapshot2.exists) {
          DocumentSnapshot documentSnapshot3 = await FirebaseFirestore.instance
              .collection("users")
              .doc(userUID)
              .collection("AktivitetsOversigt")
              .doc("Aktiviteter")
              .get();
          Map<String, int> activitiesPrevalence = {};
          if (documentSnapshot3.exists) {
            activityPrevalance =
                documentSnapshot3.data() as Map<String, dynamic>;
            Map<String, dynamic> nestedMap = activityPrevalance['Aktiviteter'];

            // Convert to Map<String, int>
            activitiesPrevalence =
                nestedMap.map((key, value) => MapEntry(key, value as int));

            // Initialize activitiesPrevalence with zeros
            activitiesPrevalence = {for (var key in nestedMap.keys) key: 0};

            for (var i = 0; i < prevalenceLength; i++) {
              DateTime date = now.subtract(Duration(days: i));
              String prevalenceDate = DateFormat('yyyy-MM-dd').format(date);
              DocumentSnapshot documentSnapshot4 = await FirebaseFirestore
                  .instance
                  .collection("users")
                  .doc(userUID)
                  .collection("dage")
                  .doc(prevalenceDate)
                  .collection("smertedagbog")
                  .doc("aktiviteter")
                  .get();
              if (documentSnapshot4.exists) {
                Map<String, dynamic> dbbool =
                    documentSnapshot4.data() as Map<String, dynamic>;
                Map<String, dynamic> activitiesBoolNestedMap =
                    dbbool['Aktivitetsliste'];
                Map<String, bool> activitiesBool = activitiesBoolNestedMap
                    .map((key, value) => MapEntry(key, value as bool));

                activitiesBool.forEach((key, value) {
                  if (value == true) {
                    if (activitiesPrevalence.containsKey(key)) {
                      activitiesPrevalence[key] =
                          activitiesPrevalence[key]! + 1;
                    } else {
                      activitiesPrevalence[key] = 1;
                    }
                  }
                });
              }
            }

            // Sort the map by values in descending order
            activityPrevalanceSortedEntries = activitiesPrevalence.entries
                .toList()
              ..sort((a, b) => b.value.compareTo(a.value));

            // Convert to Map<String, bool> with all values set to false
            activitiesBoolMap = {
              for (var entry in activityPrevalanceSortedEntries)
                entry.key: false
            };

            // Update activitiesBoolMap with values from the latest document
            Map<String, dynamic> dbbool =
                documentSnapshot2.data() as Map<String, dynamic>;
            Map<String, dynamic> activitiesBoolNestedMap =
                dbbool['Aktivitetsliste'];
            Map<String, bool> activitiesBool = activitiesBoolNestedMap
                .map((key, value) => MapEntry(key, value as bool));
            activitiesBool.forEach((key, value) {
              if (activitiesBoolMap.containsKey(key)) {
                activitiesBoolMap[key] = value;
              }
            });
          }
        }

        setState(() {
          painValue = data['Smerte']?.toDouble() ?? 5.0;
          sleepValue = data['Søvn']?.toDouble() ?? 5.0;
          socialValue = data['Social']?.toDouble() ?? 5.0;
          moodValue = data['Humør']?.toDouble() ?? 5.0;
          activityValue = data['Aktivitetsniveau']?.toDouble() ?? 5.0;
          isLoading = false;
        });
      } else {
        Map<String, int> activitiesPrevalence = {};
        DocumentSnapshot documentSnapshot3 = await FirebaseFirestore.instance
            .collection("users")
            .doc(userUID)
            .collection("AktivitetsOversigt")
            .doc("Aktiviteter")
            .get();
        if (documentSnapshot3.exists) {
          activityPrevalance = documentSnapshot3.data() as Map<String, dynamic>;
          Map<String, dynamic> nestedMap = activityPrevalance['Aktiviteter'];

          // Convert to Map<String, int>
          activitiesPrevalence =
              nestedMap.map((key, value) => MapEntry(key, value as int));

          // Initialize activitiesPrevalence with zeros
          activitiesPrevalence = {for (var key in nestedMap.keys) key: 0};

          for (var i = 0; i < prevalenceLength; i++) {
            DateTime date = now.subtract(Duration(days: i));
            String prevalenceDate = DateFormat('yyyy-MM-dd').format(date);
            DocumentSnapshot documentSnapshot4 = await FirebaseFirestore
                .instance
                .collection("users")
                .doc(userUID)
                .collection("dage")
                .doc(prevalenceDate)
                .collection("smertedagbog")
                .doc("aktiviteter")
                .get();
            if (documentSnapshot4.exists) {
              Map<String, dynamic>? dbbool =
                  documentSnapshot4.data() as Map<String, dynamic>?;
              if (dbbool != null && dbbool.containsKey('Aktivitetsliste')) {
                Map<String, dynamic> activitiesBoolNestedMap =
                    dbbool['Aktivitetsliste'];
                Map<String, bool> activitiesBool = activitiesBoolNestedMap
                    .map((key, value) => MapEntry(key, value as bool));

                activitiesBool.forEach((key, value) {
                  if (value == true) {
                    if (activitiesPrevalence.containsKey(key)) {
                      activitiesPrevalence[key] =
                          activitiesPrevalence[key]! + 1;
                    } else {
                      activitiesPrevalence[key] = 1;
                    }
                  }
                });
              }
            }
          }

          // Sort the map by values in descending order
          activityPrevalanceSortedEntries = activitiesPrevalence.entries
              .toList()
            ..sort((a, b) => b.value.compareTo(a.value));

          // Convert to Map<String, bool> with all values set to false
          activitiesBoolMap = {
            for (var entry in activityPrevalanceSortedEntries) entry.key: false
          };

          // Update activitiesBoolMap with values from the latest document
          Map<String, dynamic>? dbbool =
              documentSnapshot2.data() as Map<String, dynamic>?;
          if (dbbool != null && dbbool.containsKey('Aktivitetsliste')) {
            Map<String, dynamic> activitiesBoolNestedMap =
                dbbool['Aktivitetsliste'];
            Map<String, bool> activitiesBool = activitiesBoolNestedMap
                .map((key, value) => MapEntry(key, value as bool));
            activitiesBool.forEach((key, value) {
              if (activitiesBoolMap.containsKey(key)) {
                activitiesBoolMap[key] = value;
              }
            });
          }
        }

        setState(() {
          isLoading = false;
        });
        print('No such document!');
      }
    } catch (e) {
      setState(() {
        isLoading = false;
      });
      print('Error fetching data: $e');
    }

    setState(() {
      // When data is finished loading, set the bool to false so that the page can be rendered
      isLoading = false;
    });
  }

  @override
  void initState() {
    super.initState();
    _fetchData();
  }

  Widget build(BuildContext context) {
    if (isLoading) {
      return Scaffold(
        backgroundColor: const Color.fromARGB(255, 243, 243, 228),
        appBar: Topappbar(pagename: "Loading data"),
        body: const Center(child: CircularProgressIndicator()),
      );
    } else if (widget.pageIndex == 1) {
      return Opsummering();
    }
    return Homepage();
  }
}
