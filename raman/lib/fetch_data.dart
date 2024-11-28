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
int dataLengthForAktivitiesOnGoodAndBadDays = 5;
double gnsSmerte = 0;
double gnsSmerteUpperLimit = 0;
double gnsSmerteLowerLimit = 0;
int gnsInputDataLength = 7;
double painValue = 5;
double sleepValue = 5;
double socialValue = 5;
double moodValue = 5;
double activityValue = 5;
double smerteUge = 5;
double humorUge = 5;
double aktivitetUge = 5;
double socialUge = 5;
double sovnUge = 5;
double smerteManed = 5;
double humorManed = 5;
double aktivitetManed = 5;
double socialManed = 5;
double sovnManed = 5;

String userUID = FirebaseAuth.instance.currentUser!.uid;
Map<String, dynamic> smerteData = {};
Map<String, dynamic> sleepData = {};
Map<String, dynamic> socialData = {};
Map<String, dynamic> moodData = {};
Map<String, dynamic> aktivitetsData = {};
Map<String, dynamic> activityPrevalance = {};
Map<String, bool> activitiesBoolMap = {};
List<MapEntry<String, int>> activityPrevalanceSortedEntries = [];
List<Map<String, Map<String, bool>>> senesteDagesAktiviteter = [];
List<String> godeDage = [];
List<String> badDays = [];
bool dataFetched = false;

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
  DateTime now = DateTime.now();
  String userUID = FirebaseAuth.instance.currentUser!.uid;

  Future<void> _fetchData() async {
    int j = 0;
    Map<String, dynamic> dataGodeDage;
    Map<String, dynamic> dataBadDays;
    while (true) {
      DocumentSnapshot docSnapShot = await FirebaseFirestore.instance
          .collection("users")
          .doc(userUID)
          .collection("LærOmDinSmerte")
          .doc("GodeDage")
          .get();
      DocumentSnapshot docSnapShot2 = await FirebaseFirestore.instance
          .collection("users")
          .doc(userUID)
          .collection("LærOmDinSmerte")
          .doc("DårligeDage")
          .get();
      if (docSnapShot.exists) {
        Map<String, dynamic> dataGodeDage =
            docSnapShot.data() as Map<String, dynamic>;
      }
      if (docSnapShot2.exists) {
        Map<String, dynamic> dataBadDays =
            docSnapShot2.data() as Map<String, dynamic>;
      }

      for (var i = 0; i < 90; i++) {
        DateTime date = now.subtract(Duration(days: i));
        String dateString = DateFormat('yyyy-MM-dd').format(date);
        // godeDage[0] = dataGodeDage[dateString];
      }
      break;
    }

    gnsSmerte = 0;
    gnsSmerteUpperLimit = 0;
    gnsSmerteLowerLimit = 0;
    senesteDagesAktiviteter = [];

    String dagsDato = DateFormat('yyyy-MM-dd').format(now);
    for (var i = 0; i < gnsInputDataLength; i++) {
      DateTime date = now.subtract(Duration(days: i));
      
      String dateString = DateFormat('yyyy-MM-dd').format(date);
      DocumentSnapshot docSnapShot = await FirebaseFirestore.instance
          .collection("users")
          .doc(userUID)
          .collection("dage")
          .doc(dateString)
          .collection("smertedagbog")
          .doc("VAS")
          .get();
      if (docSnapShot.exists) {
        Map<String, dynamic> data = docSnapShot.data() as Map<String, dynamic>;
        gnsSmerte = gnsSmerte + data['Smerte']?.toDouble();
      }
    }
    gnsSmerte = gnsSmerte / gnsInputDataLength;
    gnsSmerteUpperLimit = gnsSmerte + (gnsSmerte * 0.33);
    gnsSmerteLowerLimit = gnsSmerte - (gnsSmerte * 0.33);
    print("gnsSmerte = $gnsSmerte");
    print("gnsSmerteUpperLimit = $gnsSmerteUpperLimit");
    print("gnsSmerteLowerLimit = $gnsSmerteLowerLimit");

    int jUge = 0;
    for (var i = 0; i < 7; i++) {
      DateTime date = now.subtract(Duration(days: i));
      String dateString = DateFormat('yyyy-MM-dd').format(date);
      DocumentSnapshot docSnapShot = await FirebaseFirestore.instance
          .collection("users")
          .doc(userUID)
          .collection("dage")
          .doc(dateString)
          .collection("smertedagbog")
          .doc("VAS")
          .get();
      if (docSnapShot.exists) {
        Map<String, dynamic> data = docSnapShot.data() as Map<String, dynamic>;
        smerteUge = smerteUge + data['Smerte']?.toDouble();
        humorUge = humorUge + data['Humør']?.toDouble();
        sovnUge = sovnUge + data['Søvn']?.toDouble();
        aktivitetUge = aktivitetUge + data['Aktivitet']?.toDouble();
        socialUge = socialUge + data['Social']?.toDouble();
        jUge++;
      }
    }
    smerteUge = smerteUge / jUge;
    humorUge = humorUge / jUge;
    sovnUge = sovnUge / jUge;
    aktivitetUge = aktivitetUge / jUge;
    socialUge = socialUge / jUge;

    int jManed = 0;
    for (var i = 0; i < 31; i++) {
      DateTime date = now.subtract(Duration(days: i));
      String dateString = DateFormat('yyyy-MM-dd').format(date);
      DocumentSnapshot docSnapShot = await FirebaseFirestore.instance
          .collection("users")
          .doc(userUID)
          .collection("dage")
          .doc(dateString)
          .collection("smertedagbog")
          .doc("VAS")
          .get();
      if (docSnapShot.exists) {
        Map<String, dynamic> data = docSnapShot.data() as Map<String, dynamic>;
        smerteManed = smerteManed + data['Smerte']?.toDouble();
        humorManed = humorManed + data['Humør']?.toDouble();
        sovnManed = sovnManed + data['Søvn']?.toDouble();
        aktivitetManed = aktivitetManed + data['Aktivitet']?.toDouble();
        socialManed = socialManed + data['Social']?.toDouble();
        jManed++;
      }
    }
    smerteManed = smerteManed / jManed;
    humorManed = humorManed / jManed;
    sovnManed = sovnManed / jManed;
    aktivitetManed = aktivitetManed / jManed;
    socialManed = socialManed / jManed;

    for (var i = 0; i <= dataLengthForAktivitiesOnGoodAndBadDays; i++) {
      DateTime date = now.subtract(Duration(days: i));
      String dateString = DateFormat('yyyy-MM-dd').format(date);
      DocumentSnapshot docSnapShot = await FirebaseFirestore.instance
          .collection("users")
          .doc(userUID)
          .collection("dage")
          .doc(dateString)
          .collection("smertedagbog")
          .doc("aktiviteter")
          .get();
      if (docSnapShot.exists) {
        Map<String, dynamic> data = docSnapShot.data() as Map<String, dynamic>;
        Map<String, Map<String, bool>> mellemMap = {};

// Assuming 'Aktivitetsliste' is the key for the map you want to extract
        if (data['Aktivitetsliste'] is Map<String, dynamic>) {
          Map<String, dynamic> aktivitetslisteDynamic =
              data['Aktivitetsliste'] as Map<String, dynamic>;
          Map<String, bool> aktivitetsliste = aktivitetslisteDynamic
              .map((key, value) => MapEntry(key, value as bool));
          if (aktivitetsliste is Map<String, bool>) {
            mellemMap[dateString] = aktivitetsliste;
            senesteDagesAktiviteter.add(mellemMap);
          }
        }
      }
    }
    for (var i = fetchVASDatasize; i >= 0; i--) {
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
          dataFetched = true;
        });
      }
    } catch (e) {
      setState(() {
        isLoading = false;
      });
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
