import 'package:flutter/material.dart';
import 'navigationbars.dart';

class Opsummering extends StatefulWidget {
  const Opsummering({super.key});

  @override
  State<Opsummering> createState() => _OpsummeringState();
}

class _OpsummeringState extends State<Opsummering> {
         

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: Topappbar(pagename: "Opsummering"),
      bottomNavigationBar: const Bottomappbar(),
       
    );
  }
}