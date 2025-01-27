// import 'package:flutter/material.dart';
//
// class CreateEventScreen extends StatelessWidget {
//   final TextEditingController titleController = TextEditingController();
//   final TextEditingController dateController = TextEditingController();
//   final TextEditingController noOfPeopleController = TextEditingController();
//   final TextEditingController addressController = TextEditingController();
//   final TextEditingController descriptionController = TextEditingController();
//
//   String? selectedCountry;
//   String? selectedCity;
//
//   final List<String> countries = ["USA", "Canada", "UK"];
//   final Map<String, List<String>> cities = {
//     "USA": ["New York", "Los Angeles", "Chicago"],
//     "Canada": ["Toronto", "Vancouver", "Montreal"],
//     "UK": ["London", "Manchester", "Liverpool"],
//   };
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text("Back to feed"),
//         leading: IconButton(
//           icon: Icon(Icons.arrow_back),
//           onPressed: () {
//             Navigator.pop(context);
//           },
//         ),
//         backgroundColor: Colors.transparent,
//         elevation: 0,
//       ),
//       body: SingleChildScrollView(
//         padding: EdgeInsets.all(16.0),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             // Image Picker Placeholder
//             Center(
//               child: Container(
//                 width: 100,
//                 height: 100,
//                 decoration: BoxDecoration(
//                   color: Color(0xFF20A090),
//                   borderRadius: BorderRadius.circular(16),
//                 ),
//                 child: Icon(Icons.image, size: 50, color: Colors.white),
//               ),
//             ),
//             SizedBox(height: 16),
//
//             // Title Field
//             TextField(
//               controller: titleController,
//               decoration: InputDecoration(
//                 labelText: "Title",
//                 border: UnderlineInputBorder(),
//               ),
//             ),
//             SizedBox(height: 16),
//
//             // Country and City Dropdowns
//             Row(
//               children: [
//                 Expanded(
//                   child: DropdownButtonFormField<String>(
//                     value: selectedCountry,
//                     items: countries.map((country) {
//                       return DropdownMenuItem(
//                         value: country,
//                         child: Text(country),
//                       );
//                     }).toList(),
//                     onChanged: (value) {
//                       selectedCountry = value;
//                       selectedCity = null; // Reset city when country changes
//                     },
//                     decoration: InputDecoration(
//                       labelText: "Select country",
//                       border: UnderlineInputBorder(),
//                     ),
//                   ),
//                 ),
//                 SizedBox(width: 16),
//                 Expanded(
//                   child: DropdownButtonFormField<String>(
//                     value: selectedCity,
//                     items: (selectedCountry != null
//                         ? cities[selectedCountry] ?? []
//                         : [])
//                         .map((city) {
//                       return DropdownMenuItem(
//                         value: city,
//                         child: Text(city),
//                       );
//                     }).toList(),
//                     onChanged: (value) {
//                       selectedCity = value;
//                     },
//                     decoration: InputDecoration(
//                       labelText: "Select city",
//                       border: UnderlineInputBorder(),
//                     ),
//                   ),
//                 ),
//               ],
//             ),
//             SizedBox(height: 16),
//
//             // Date and Number of People
//             Row(
//               children: [
//                 Expanded(
//                   child: TextField(
//                     controller: dateController,
//                     decoration: InputDecoration(
//                       labelText: "Date",
//                       border: UnderlineInputBorder(),
//                     ),
//                     onTap: () async {
//                       DateTime? selectedDate = await showDatePicker(
//                         context: context,
//                         initialDate: DateTime.now(),
//                         firstDate: DateTime(2000),
//                         lastDate: DateTime(2100),
//                       );
//                       if (selectedDate != null) {
//                         dateController.text =
//                         "${selectedDate.day}/${selectedDate.month}/${selectedDate.year}";
//                       }
//                     },
//                   ),
//                 ),
//                 SizedBox(width: 16),
//                 Expanded(
//                   child: TextField(
//                     controller: noOfPeopleController,
//                     decoration: InputDecoration(
//                       labelText: "No. of People",
//                       border: UnderlineInputBorder(),
//                     ),
//                     keyboardType: TextInputType.number,
//                   ),
//                 ),
//               ],
//             ),
//             SizedBox(height: 16),
//
//             // Address Field
//             TextField(
//               controller: addressController,
//               decoration: InputDecoration(
//                 labelText: "Address",
//                 border: UnderlineInputBorder(),
//               ),
//             ),
//             SizedBox(height: 16),
//
//             // Description Field
//             TextField(
//               controller: descriptionController,
//               maxLines: 3,
//               decoration: InputDecoration(
//                 labelText: "Description",
//                 border: UnderlineInputBorder(),
//               ),
//             ),
//             SizedBox(height: 24),
//
//             // Create Button
//             Center(
//               child: ElevatedButton(
//                 onPressed: () {
//                   // Logic to create the event
//                   print("Event Created!");
//                 },
//                 style: ElevatedButton.styleFrom(
//                   backgroundColor: Color(0xFF20A090),
//                   fixedSize: Size(200, 48),
//                   shape: RoundedRectangleBorder(
//                     borderRadius: BorderRadius.circular(16),
//                   ),
//                 ),
//                 child: Text(
//                   "Create",
//                   style: TextStyle(
//                     color: Colors.white,
//                     fontSize: 16,
//                     fontWeight: FontWeight.bold,
//                   ),
//                 ),
//               ),
//             ),
//           ],
//         ),
//       ),
//       bottomNavigationBar: BottomNavigationBar(
//         currentIndex: 1, // Match tab
//         onTap: (index) {
//           // Navigation logic
//         },
//         items: [
//           BottomNavigationBarItem(
//             icon: Icon(Icons.message),
//             label: "Message",
//           ),
//           BottomNavigationBarItem(
//             icon: Icon(Icons.group),
//             label: "Match",
//           ),
//           BottomNavigationBarItem(
//             icon: Icon(Icons.person),
//             label: "Profile",
//           ),
//         ],
//       ),
//     );
//   }
// }
