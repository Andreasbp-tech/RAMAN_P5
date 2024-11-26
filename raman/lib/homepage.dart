import 'package:flutter/material.dart';
import 'package:raman/painjournal.dart';
import 'navigationbars.dart';
import 'package:awesome_notifications/awesome_notifications.dart';

class Homepage extends StatefulWidget {
  const Homepage({super.key});

  @override
  State<Homepage> createState() => _HomepageState();
}

class _HomepageState extends State<Homepage> {
  @override
  void initState() {
    AwesomeNotifications().isNotificationAllowed().then((isAllowed) {
      if (!isAllowed) {
        AwesomeNotifications().requestPermissionToSendNotifications();
      }
    });
    super.initState();
  }

  triggerNotification() {
    AwesomeNotifications().createNotification(
      content: NotificationContent(
        id: 10,
        channelKey: 'basic_channel',
        title: 'Udfyld Smertedagbog',
        body: 'Vurder smerteparametre',
        displayOnBackground: true,
        displayOnForeground: true,
      ),
      schedule: NotificationCalendar.fromDate(
          date: DateTime.now().add(Duration(seconds: 2)), repeats: true),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 243, 243, 228),
      appBar: Topappbar(pagename: "Hjem"),
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
                    onPressed: triggerNotification,
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 65),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.school_rounded, size: 24),
                        SizedBox(width: 8),
                        Text('E-læring', style: TextStyle(fontSize: 20)),
                      ],
                    ),
                  ),
                ),
                SizedBox(width: 16), // Mellemrum mellem knapper
                Expanded(
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (BuildContext context) {
                            return const PainJournal();
                          },
                        ),
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 65),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.menu_book, size: 24),
                        SizedBox(width: 8),
                        Text('Smertedagbog', style: TextStyle(fontSize: 20)),
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
                    onPressed: () {},
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 65),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.fitness_center, size: 24),
                        SizedBox(width: 8),
                        Text('Øvelser', style: TextStyle(fontSize: 20)),
                      ],
                    ),
                  ),
                ),
                SizedBox(width: 16),
                Expanded(
                  child: ElevatedButton(
                    onPressed: () {},
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 40),
                    ),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.bookmark_added_rounded, size: 24),
                        SizedBox(width: 8),
                        Text(
                          'Konsultations-\nlogbog',
                          textAlign: TextAlign.center,
                          style: TextStyle(fontSize: 20),
                        ),
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
                    onPressed: () {},
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 65),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.people, size: 24),
                        SizedBox(width: 8),
                        Text('Patienthistorier',
                            style: TextStyle(fontSize: 20)),
                      ],
                    ),
                  ),
                ),
                SizedBox(width: 16),
                Expanded(
                  child: ElevatedButton(
                    onPressed: () {},
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 65),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.my_library_books, size: 24),
                        SizedBox(width: 8),
                        Text('Metaforordbog', style: TextStyle(fontSize: 20)),
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
