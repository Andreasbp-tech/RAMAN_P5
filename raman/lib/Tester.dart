// import 'package:flutter/material.dart';

// class TesterPage extends StatefulWidget {
//   const TesterPage({Key? key}) : super(key: key);

//   @override
//   State<TesterPage> createState() => _TesterPageState();
// }

// class _TesterPageState extends State<TesterPage> {
//   List<String> _selectedItems = [];

//   void _showMultiSelect() async {
//     final List<String> items = ['Flutter', 'Node.js', 'React Native', 'Java', 'Docker', 'MySQL'];
//     final List<String>? results = await showDialog(
//       context: context,
//       builder: (BuildContext context) {
//         return MultiSelect(items: items);
//       },
//     );

//     if (results != null) {
//       setState(() {
//         _selectedItems = results;
//       });
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text('Multi-Select Dropdown'),
//       ),
//       body: Padding(
//         padding: const EdgeInsets.all(20),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             ElevatedButton(
//               onPressed: _showMultiSelect,
//               child: const Text('Select Your Favorite Topics'),
//             ),
//             const Divider(height: 30),
//             Wrap(
//               children: _selectedItems.map((e) => Chip(label: Text(e))).toList(),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }

// class MultiSelect extends StatefulWidget {
//   final List<String> items;

//   const MultiSelect({Key? key, required this.items}) : super(key: key);

//   @override
//   State<MultiSelect> createState() => _MultiSelectState();
// }

// class _MultiSelectState extends State<MultiSelect> {
//   final List<String> _selectedItems = [];

//   void _itemChange(String itemValue, bool isSelected) {
//     setState(() {
//       if (isSelected) {
//         _selectedItems.add(itemValue);
//       } else {
//         _selectedItems.remove(itemValue);
//       }
//     });
//   }

//   void _cancel() {
//     Navigator.pop(context);
//   }

//   void _submit() {
//     Navigator.pop(context, _selectedItems);
//   }

//   @override
//   Widget build(BuildContext context) {
//     return AlertDialog(
//       title: const Text('Select Topics'),
//       content: SingleChildScrollView(
//         child: ListBody(
//           children: widget.items.map((item) {
//             return CheckboxListTile(
//               value: _selectedItems.contains(item),
//               title: Text(item),
//               controlAffinity: ListTileControlAffinity.leading,
//               onChanged: (isChecked) => _itemChange(item, isChecked!),
//             );
//           }).toList(),
//         ),
//       ),
//       actions: [
//         TextButton(
//           onPressed: _cancel,
//           child: const Text('Cancel'),
//         ),
//         ElevatedButton(
//           onPressed: _submit,
//           child: const Text('Submit'),
//         ),
//       ],
//     );
//   }
// }

// // import 'package:flutter/material.dart';

// // class TesterPage extends StatefulWidget {
// //   const TesterPage({Key? key}) : super(key: key);

// //   @override
// //   State<TesterPage> createState() => _TesterPageState();
// // }

// // class _TesterPageState extends State<TesterPage> {
// //   bool _isDropdownOpen = false;

// //   final Map<String, bool> _items = {
// //     'Flutter': false,
// //     'Node.js': false,
// //     'React Native': false,
// //     'Java': false,
// //     'Docker': false,
// //     'MySQL': false,
// //   };

// //   void _itemChange(String itemValue, bool isSelected) {
// //     setState(() {
// //       _items[itemValue] = isSelected;
// //     });
// //   }

// //   @override
// //   Widget build(BuildContext context) {
// //     return Scaffold(
// //       appBar: AppBar(
// //         title: const Text('Inline Multi-Select Dropdown'),
// //       ),
// //       body: Padding(
// //         padding: const EdgeInsets.all(20),
// //         child: Column(
// //           crossAxisAlignment: CrossAxisAlignment.start,
// //           children: [
// //             GestureDetector(
// //               onTap: () {
// //                 setState(() {
// //                   _isDropdownOpen = !_isDropdownOpen;
// //                 });
// //               },
// //               child: Container(
// //                 padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 15),
// //                 decoration: BoxDecoration(
// //                   border: Border.all(color: Colors.grey),
// //                   borderRadius: BorderRadius.circular(5),
// //                 ),
// //                 child: Row(
// //                   mainAxisAlignment: MainAxisAlignment.spaceBetween,
// //                   children: [
// //                     Text(_items.entries.where((entry) => entry.value).isEmpty
// //                         ? 'Select Your Favorite Topics'
// //                         : _items.entries.where((entry) => entry.value).map((entry) => entry.key).join(', ')),
// //                     Icon(_isDropdownOpen ? Icons.arrow_drop_up : Icons.arrow_drop_down),
// //                   ],
// //                 ),
// //               ),
// //             ),
// //             if (_isDropdownOpen)
// //               Column(
// //                 children: _items.keys.map((item) {
// //                   return CheckboxListTile(
// //                     value: _items[item],
// //                     title: Text(item),
// //                     controlAffinity: ListTileControlAffinity.leading,
// //                     onChanged: (isChecked) => _itemChange(item, isChecked!),
// //                   );
// //                 }).toList(),
// //               ),
// //             const Divider(height: 30),
// //             Wrap(
// //               children: _items.entries
// //                   .where((entry) => entry.value)
// //                   .map((entry) => Chip(label: Text(entry.key)))
// //                   .toList(),
// //             ),
// //           ],
// //         ),
// //       ),
// //     );
// //   }
// // }

// // import 'package:flutter/material.dart';

// // class TesterPage extends StatefulWidget {
// //   const TesterPage({Key? key}) : super(key: key);

// //   @override
// //   State<TesterPage> createState() => _TesterPageState();
// // }

// // class _TesterPageState extends State<TesterPage> {
// //   final Map<String, bool> _items = {
// //     'Flutter': false,
// //     'Node.js': false,
// //     'React Native': false,
// //     'Java': false,
// //     'Docker': false,
// //     'MySQL': false,
// //   };

// //   bool _isDropdownOpen = false;

// //   void _toggleDropdown() {
// //     setState(() {
// //       _isDropdownOpen = !_isDropdownOpen;
// //     });
// //   }

// //   @override
// //   Widget build(BuildContext context) {
// //     return Scaffold(
// //       appBar: AppBar(
// //         title: const Text('Stack Dropdown Menu'),
// //       ),
// //       body: Stack(
// //         children: [
// //           Padding(
// //             padding: const EdgeInsets.all(20),
// //             child: Column(
// //               crossAxisAlignment: CrossAxisAlignment.start,
// //               children: [
// //                 GestureDetector(
// //                   onTap: _toggleDropdown,
// //                   child: Container(
// //                     padding: const EdgeInsets.symmetric(
// //                         horizontal: 10, vertical: 15),
// //                     decoration: BoxDecoration(
// //                       border: Border.all(color: Colors.grey),
// //                       borderRadius: BorderRadius.circular(5),
// //                     ),
// //                     child: Row(
// //                       mainAxisAlignment: MainAxisAlignment.spaceBetween,
// //                       children: [
// //                         Text(
// //                             _items.entries.where((entry) => entry.value).isEmpty
// //                                 ? 'Select Your Favorite Topics'
// //                                 : _items.entries
// //                                     .where((entry) => entry.value)
// //                                     .map((entry) => entry.key)
// //                                     .join(', ')),
// //                         Icon(_isDropdownOpen
// //                             ? Icons.arrow_drop_up
// //                             : Icons.arrow_drop_down),
// //                       ],
// //                     ),
// //                   ),
// //                 ),
// //                 const Divider(height: 30),
// //                 Wrap(
// //                   children: _items.entries
// //                       .where((entry) => entry.value)
// //                       .map((entry) => Chip(label: Text(entry.key)))
// //                       .toList(),
// //                 ),
// //               ],
// //             ),
// //           ),
// //           if (_isDropdownOpen)
// //             Positioned(
// //               top: 80, // Adjust this value based on your layout
// //               left: 20,
// //               right: 20,
// //               child: Material(
// //                 elevation: 4.0,
// //                 child: Column(
// //                   children: _items.keys.map((item) {
// //                     return CheckboxListTile(
// //                       value: _items[item],
// //                       title: Text(item),
// //                       controlAffinity: ListTileControlAffinity.leading,
// //                       onChanged: (isChecked) {
// //                         setState(() {
// //                           _items[item] = isChecked!;
// //                         });
// //                       },
// //                     );
// //                   }).toList(),
// //                 ),
// //               ),
// //             ),
// //         ],
// //       ),
// //     );
// //   }
// // }
// // import 'package:flutter/material.dart';

// // class TesterPage extends StatelessWidget {
// //   const TesterPage({super.key});
// //   @override
// //   Widget build(BuildContext context) {
// //     return MaterialApp(
// //       home: Scaffold(
// //         appBar: AppBar(title: Text('Positioned Example')),
// //         body: Stack(
// //           children: [
// //             Container(
// //               width: 300,
// //               height: 300,
// //               color: Colors.blue[100],
// //             ),
// //             Positioned(
// //               top: 50,
// //               left: 50,
// //               child: Container(
// //                 width: 100,
// //                 height: 100,
// //                 color: Colors.red,
// //               ),
// //             ),
// //             Positioned(
// //               bottom: 20,
// //               right: 20,
// //               child: Container(
// //                 width: 50,
// //                 height: 50,
// //                 color: Colors.green,
// //               ),
// //             ),
// //           ],
// //         ),
// //       ),
// //     );
// //   }
// // }

// for (var i = 0; i < 31; i++) {
//       DateTime date = now.subtract(Duration(days: i));
//       String dateString = DateFormat('yyyy-MM-dd').format(date);
//       DocumentSnapshot docSnapShot = await FirebaseFirestore.instance
//           .collection("users")
//           .doc(userUID)
//           .collection("dage")
//           .doc(dateString)
//           .collection("smertedagbog")
//           .doc("VAS")
//           .get();
//       if (docSnapShot.exists) {
//         Map<String, dynamic> data = docSnapShot.data() as Map<String, dynamic>;
//         smerteManed = smerteManed + data['Smerte']?.toDouble();
//         humorManed = humorManed + data['Humør']?.toDouble();
//         sovnManed = sovnManed + data['Søvn']?.toDouble();
//         aktivitetManed = aktivitetManed + data['Aktivitet']?.toDouble();
//         socialManed = socialManed + data['Social']?.toDouble();
//       }
//     }
//     smerteManed = smerteManed / 31;
//     humorManed = humorManed / 31;
//     sovnManed = sovnManed / 31;
//     aktivitetManed = aktivitetManed / 31;
//     socialManed = socialManed / 31;
