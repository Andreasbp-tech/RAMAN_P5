import 'package:flutter/material.dart';
import 'navigationbars.dart';
import 'fetch_data.dart' as data;

class Laromdinsmerte extends StatefulWidget {
  Laromdinsmerte({super.key});

  @override
  State<Laromdinsmerte> createState() => _LaromdinsmerteState();
}

class _LaromdinsmerteState extends State<Laromdinsmerte> {
  // Define variables for font size and button height
  final double buttonFontSize = 18;
  final double samletButtonFontSize = 20;
  final double buttonHeight = 80;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 243, 243, 228),
      appBar: Topappbar(pagename: "Lær om din smerte"),
      bottomNavigationBar: const Bottomappbar(),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Expanded(
                child: buildColumnGode(),
              ),
              Expanded(
                child: buildColumnDarlig(),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget buildColumnGode() {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        SizedBox(height: 30),
        Text(
          'Gode dage',
          style: TextStyle(
            fontSize: 32,
            fontWeight: FontWeight.bold,
            color: Colors.green,
          ),
        ),
        SizedBox(height: 20),
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 8.0),
          child: ElevatedButton(
            onPressed: () {},
            style: ElevatedButton.styleFrom(
              side: BorderSide(color: Colors.green),
              backgroundColor: Colors.white,
              foregroundColor: Colors.black,
              minimumSize: Size(double.infinity,
                  buttonHeight), // Use variable for button height
            ),
            child: Text(
              data.godeDage[0],
              style: TextStyle(
                  fontSize: buttonFontSize), // Use variable for font size
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 8.0),
          child: ElevatedButton(
            onPressed: () {},
            style: ElevatedButton.styleFrom(
              side: BorderSide(color: Colors.green),
              backgroundColor: Colors.white,
              foregroundColor: Colors.black,
              minimumSize: Size(double.infinity,
                  buttonHeight), // Use variable for button height
            ),
            child: Text(
              data.godeDage[1],
              style: TextStyle(
                  fontSize: buttonFontSize), // Use variable for font size
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 8.0),
          child: ElevatedButton(
            onPressed: () {},
            style: ElevatedButton.styleFrom(
              side: BorderSide(color: Colors.green),
              backgroundColor: Colors.white,
              foregroundColor: Colors.black,
              minimumSize: Size(double.infinity,
                  buttonHeight), // Use variable for button height
            ),
            child: Text(
              data.godeDage[2],
              style: TextStyle(
                  fontSize: buttonFontSize), // Use variable for font size
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 8.0),
          child: ElevatedButton(
            onPressed: () {},
            style: ElevatedButton.styleFrom(
              side: BorderSide(color: Colors.green),
              backgroundColor: Colors.white,
              foregroundColor: Colors.black,
              minimumSize: Size(double.infinity,
                  buttonHeight), // Use variable for button height
            ),
            child: Text(
              data.godeDage[3],
              style: TextStyle(
                  fontSize: buttonFontSize), // Use variable for font size
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 8.0),
          child: ElevatedButton(
            onPressed: () {},
            style: ElevatedButton.styleFrom(
              side: BorderSide(color: Colors.green),
              backgroundColor: Colors.white,
              foregroundColor: Colors.black,
              minimumSize: Size(double.infinity,
                  buttonHeight), // Use variable for button height
            ),
            child: Text(
              data.godeDage[4],
              style: TextStyle(
                  fontSize: buttonFontSize), // Use variable for font size
            ),
          ),
        ),
        SizedBox(height: 20),
        ElevatedButton(
          onPressed: () {},
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.green,
            foregroundColor: Colors.black,
            minimumSize: Size(double.infinity,
                buttonHeight), // Use variable for button height
          ),
          child: Text(
            'Samlet over de 5 gode dage',
            style: TextStyle(fontSize: samletButtonFontSize),
          ),
        ),
      ],
    );
  }

  Widget buildColumnDarlig() {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        SizedBox(height: 30),
        Text(
          'Dårlige dage',
          style: TextStyle(
            fontSize: 32,
            fontWeight: FontWeight.bold,
            color: Colors.red,
          ),
        ),
        SizedBox(height: 20),
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 8.0),
          child: ElevatedButton(
            onPressed: () {},
            style: ElevatedButton.styleFrom(
              side: BorderSide(color: Colors.red),
              backgroundColor: Colors.white,
              foregroundColor: Colors.black,
              minimumSize: Size(double.infinity,
                  buttonHeight), // Use variable for button height
            ),
            child: Text(
              data.badDays[0],
              style: TextStyle(
                  fontSize: buttonFontSize), // Use variable for font size
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 8.0),
          child: ElevatedButton(
            onPressed: () {},
            style: ElevatedButton.styleFrom(
              side: BorderSide(color: Colors.red),
              backgroundColor: Colors.white,
              foregroundColor: Colors.black,
              minimumSize: Size(double.infinity,
                  buttonHeight), // Use variable for button height
            ),
            child: Text(
              data.badDays[1],
              style: TextStyle(
                  fontSize: buttonFontSize), // Use variable for font size
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 8.0),
          child: ElevatedButton(
            onPressed: () {},
            style: ElevatedButton.styleFrom(
              side: BorderSide(color: Colors.red),
              backgroundColor: Colors.white,
              foregroundColor: Colors.black,
              minimumSize: Size(double.infinity,
                  buttonHeight), // Use variable for button height
            ),
            child: Text(
              data.badDays[2],
              style: TextStyle(
                  fontSize: buttonFontSize), // Use variable for font size
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 8.0),
          child: ElevatedButton(
            onPressed: () {},
            style: ElevatedButton.styleFrom(
              side: BorderSide(color: Colors.red),
              backgroundColor: Colors.white,
              foregroundColor: Colors.black,
              minimumSize: Size(double.infinity,
                  buttonHeight), // Use variable for button height
            ),
            child: Text(
              data.badDays[3],
              style: TextStyle(
                  fontSize: buttonFontSize), // Use variable for font size
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 8.0),
          child: ElevatedButton(
            onPressed: () {},
            style: ElevatedButton.styleFrom(
              side: BorderSide(color: Colors.red),
              backgroundColor: Colors.white,
              foregroundColor: Colors.black,
              minimumSize: Size(double.infinity,
                  buttonHeight), // Use variable for button height
            ),
            child: Text(
              data.badDays[4],
              style: TextStyle(
                  fontSize: buttonFontSize), // Use variable for font size
            ),
          ),
        ),
        SizedBox(height: 20),
        ElevatedButton(
          onPressed: () {},
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.red,
            foregroundColor: Colors.black,
            minimumSize: Size(double.infinity,
                buttonHeight), // Use variable for button height
          ),
          child: Text(
            'Samlet over de 5 dårlige dage',
            style: TextStyle(fontSize: samletButtonFontSize),
          ),
        ),
      ],
    );
  }
}
