import 'package:flutter/material.dart';
import 'opsummering.dart';
import 'homepage.dart';
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

  /// Used by [Scaffold] to compute its [AppBar]'s overall height. The returned value is
  /// the same `preferredSize.height` unless [AppBar.toolbarHeight] was null and
  /// `AppBarTheme.of(context).toolbarHeight` is non-null. In that case the
  /// return value is the sum of the theme's toolbar height and the height of
  /// the app bar's [AppBar.bottom] widget.
  static double preferredHeightFor(BuildContext context, Size preferredSize) {
    if (preferredSize is _PreferredAppBarSize &&
        preferredSize.toolbarHeight == null) {
      return (AppBarTheme.of(context).toolbarHeight ?? kToolbarHeight) +
          (preferredSize.bottomHeight ?? 0);
    }
    return preferredSize.height;
  }

  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: SizedBox(child: Text(pagename)),
      centerTitle: true,
      actions: <Widget>[
        IconButton(
          onPressed: () {},
          icon: const Icon(Icons.settings),
        ),
      ],
    );
  }
}

class Bottomappbar extends StatefulWidget {
  const Bottomappbar({super.key});

  @override
  State<Bottomappbar> createState() => _BottomappbarState();
}


class _BottomappbarState extends State<Bottomappbar> {
  //int _selectedIndex = 0;

  void _onItemTapped(int index) {
    setState(() {
      globals.bottomNavigationBarIndex = index;
      if (globals.bottomNavigationBarIndex == 0) {
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (BuildContext context) {
              return const Homepage();
            },
          ),
        );
      } else if (globals.bottomNavigationBarIndex == 1) {

      } else if (globals.bottomNavigationBarIndex == 2) {

      } else if (globals.bottomNavigationBarIndex == 3) {
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (BuildContext context) {
              return const Opsummering();
            },
          ),
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      type: BottomNavigationBarType.fixed,
      currentIndex: globals.bottomNavigationBarIndex,
      onTap: _onItemTapped,
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
    );
  }
}
