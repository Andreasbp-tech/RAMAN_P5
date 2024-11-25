import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:raman/Profil.dart';
import 'opsummering.dart';
import 'homepage.dart';
import 'settingspage.dart';
import 'globals.dart' as globals;

class _PreferredAppBarSize extends Size {
  _PreferredAppBarSize(this.toolbarHeight, this.bottomHeight)
      : super.fromHeight(
            (toolbarHeight ?? kToolbarHeight) + (bottomHeight ?? 0));

  final double? toolbarHeight;
  final double? bottomHeight;
}

class Topappbar extends StatelessWidget implements PreferredSizeWidget {
  final String pagename;
  final Widget? leading;
  final Widget? titleWidget;
  @override
  final Size preferredSize;
  final PreferredSizeWidget? bottom;
  final double? elevation;
  final double? toolbarHeight;

  Topappbar({
    super.key,
    required this.pagename,
    this.leading,
    this.titleWidget,
    this.bottom,
    this.toolbarHeight,
    this.elevation,
  })  : assert(elevation == null || elevation >= 0.0),
        preferredSize =
            _PreferredAppBarSize(toolbarHeight, bottom?.preferredSize.height);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: const Color.fromARGB(255, 243, 243, 228),
      leading: IconButton(
        icon: Icon(Icons.arrow_back),
        onPressed: () {
          // // Handle back button press here
          // if (globals.bottomNavigationBarIndex == 0) {
          //   // Do nothing if already on the home screen
          //   return;
          // } else {
          if (Navigator.of(context).canPop()) {
            Navigator.of(context).pop();
          } else {
            // Prevent navigating to the login page
            if (globals.bottomNavigationBarIndex != 0) {
              Navigator.of(context).pushReplacement(
                MaterialPageRoute(
                  builder: (BuildContext context) {
                    return const Homepage();
                  },
                ),
              );
            }
          }
          //}
        },
      ),
      title: SizedBox(child: Text(pagename)),
      centerTitle: true,
      actions: [
        IconButton(
          onPressed: () {
            Navigator.of(context).push(
              MaterialPageRoute(
                builder: (BuildContext context) {
                  return SettingsPage();
                },
              ),
            );
          },
          icon: const Icon(Icons.settings),
        ),
      ],
    );
  }
}

class Bottomappbar extends StatefulWidget {
  const Bottomappbar({super.key});

  @override
  State createState() => _BottomappbarState();
}

class _BottomappbarState extends State<Bottomappbar> {
  void _navigateToPage(int index) {
    globals.bottomNavigationBarIndex = index;
    Widget page;
    switch (index) {
      case 0:
        page = const Homepage();
        break;
      case 1:
        // Add your Calendar page here
        return;
      case 2:
        page = const Profil();
        break;
      case 3:
        page = const Opsummering();
        break;
      default:
        return;
    }
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (BuildContext context) {
          return page;
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      type: BottomNavigationBarType.fixed,
      onTap: _navigateToPage,
      items: const [
        BottomNavigationBarItem(
          icon: Icon(Icons.home),
          label: "Hjem",
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.calendar_month_outlined),
          label: "Kalender",
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.account_circle),
          label: "Profil",
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.bar_chart_rounded),
          label: "Opsummering",
        ),
      ],
      currentIndex: globals.bottomNavigationBarIndex,
    );
  }
}
