import 'package:flutter/material.dart';
import 'settings.dart';

class Homepage extends StatelessWidget {
  const Homepage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const SizedBox(child: Text("Hjemmeskærm")),
        centerTitle: true,
        actions: <Widget>[
          IconButton(
            onPressed: () {},
            icon: const Icon(Icons.settings),
          ),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
          items: const [BottomNavigationBarItem(icon: Icon(Icons.home))]),
    );
  }
}
