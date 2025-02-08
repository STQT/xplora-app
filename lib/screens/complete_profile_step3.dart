import 'package:flutter/material.dart';
import '../widgets/progress_indicator.dart';

class CompleteProfileStep3 extends StatefulWidget {
  @override
  _CompleteProfileStep3State createState() => _CompleteProfileStep3State();
}

class _CompleteProfileStep3State extends State<CompleteProfileStep3> {
  String? selectedCountry;
  String? selectedCity;

  // Date controllers
  final TextEditingController fromDateController = TextEditingController();
  final TextEditingController toDateController = TextEditingController();

  // Country to city mapping
  final Map<String, List<String>> countryCityMap = {
    "USA": ["New York", "Los Angeles", "Chicago", "Houston", "Phoenix"],
    "Canada": ["Toronto", "Vancouver", "Montreal", "Calgary", "Ottawa"],
    "England": ["London", "Manchester", "Birmingham", "Liverpool", "Leeds"],
  };

  List<String> availableCities = [];

  Future<void> _selectDate(TextEditingController controller) async {
    DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
    );
    if (pickedDate != null) {
      setState(() {
        controller.text =
        "${pickedDate.day.toString().padLeft(2, '0')}.${pickedDate.month.toString().padLeft(2, '0')}.${pickedDate.year}";
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Align(
              alignment: Alignment.center,
              child: Stack(
                clipBehavior: Clip.none,
                children: [
                  RichText(
                    text: TextSpan(
                      style: TextStyle(
                        fontFamily: 'Fira Sans Condensed',
                        fontStyle: FontStyle.normal,
                        fontWeight: FontWeight.w400,
                        fontSize: 24,
                        height: 1.0,
                        color: Color(0xFF121414),
                      ),
                      children: [
                        TextSpan(text: "Complete your "),
                        TextSpan(
                          text: "profile",
                          style: TextStyle(color: Color(0xFF121414)),
                        ),
                      ],
                    ),
                  ),
                  Positioned(
                    bottom: -5,
                    left: 150,
                    child: Container(
                      width: 65,
                      height: 8,
                      color: Color(0xFF77C2C8),
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 8),
            Align(
              alignment: Alignment.center,
              child: Text(
                "Choose your first destination!",
                style: TextStyle(
                  fontFamily: 'Fira Sans Condensed',
                  fontStyle: FontStyle.normal,
                  fontWeight: FontWeight.w400,
                  fontSize: 16,
                  height: 1.25,
                  color: Color(0xFF77C2C8),
                ),
              ),
            ),
            SizedBox(height: 86),
            // Dropdowns for Country and City
            Row(
              children: [
                Expanded(
                  child: Stack(
                    children: [
                      DropdownButtonFormField<String>(
                        value: selectedCountry,
                        items: countryCityMap.keys
                            .map((country) => DropdownMenuItem(
                          value: country,
                          child: Padding(
                            padding: const EdgeInsets.only(left: 40.0),
                            child: Text(
                              country,
                              style: TextStyle(
                                fontFamily: 'Fira Sans Condensed',
                                fontSize: 16,
                                fontWeight: FontWeight.w400,
                                color: Color(0xFF121414),
                              ),
                            ),
                          ),
                        ))
                            .toList(),
                        onChanged: (value) {
                          setState(() {
                            selectedCountry = value;
                            selectedCity = null;
                            availableCities = countryCityMap[value!] ?? [];
                          });
                        },
                        decoration: InputDecoration(
                          labelText: "Country",
                          filled: true,
                          fillColor: Color(0xFFE7EBED),
                        ),
                        icon: Icon(Icons.arrow_drop_down, color: Color(0xFF24786D)),
                      ),
                    ],
                  ),
                ),
                SizedBox(width: 16),
                Expanded(
                  child: Stack(
                    children: [
                      DropdownButtonFormField<String>(
                        value: selectedCity,
                        items: availableCities
                            .map((city) => DropdownMenuItem(
                          value: city,
                          child: Padding(
                            padding: const EdgeInsets.only(left: 40.0),
                            child: Text(
                              city,
                              style: TextStyle(
                                fontFamily: 'Fira Sans Condensed',
                                fontSize: 16,
                                fontWeight: FontWeight.w400,
                                color: Color(0xFF121414),
                              ),
                            ),
                          ),
                        ))
                            .toList(),
                        onChanged: selectedCountry != null
                            ? (value) {
                          setState(() {
                            selectedCity = value;
                          });
                        }
                            : null,
                        decoration: InputDecoration(
                          labelText: "City",
                          filled: true,
                          fillColor: Color(0xFFE7EBED),
                        ),
                        icon: Icon(Icons.arrow_drop_down, color: Color(0xFF24786D)),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            SizedBox(height: 24),
            // Dates of Visit Section
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Dates of visit",
                  style: TextStyle(
                    fontFamily: 'Fira Sans Condensed',
                    fontSize: 16,
                    fontWeight: FontWeight.w400,
                    color: Color(0xFF24786D),
                  ),
                ),
                SizedBox(height: 8),
                Row(
                  children: [
                    Expanded(
                      child: TextField(
                        controller: fromDateController,
                        readOnly: true,
                        onTap: () => _selectDate(fromDateController),
                        decoration: InputDecoration(
                          prefixIcon: Icon(Icons.calendar_today, color: Color(0xFF121414)),
                          hintText: "DD.MM.YYYY",
                          filled: true,
                          fillColor: Color(0xFFE7EBED),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8.0),
                            borderSide: BorderSide.none,
                          ),
                        ),
                      ),
                    ),
                    SizedBox(width: 16),
                    Expanded(
                      child: TextField(
                        controller: toDateController,
                        readOnly: true,
                        onTap: () => _selectDate(toDateController),
                        decoration: InputDecoration(
                          prefixIcon: Icon(Icons.calendar_today, color: Color(0xFF121414)),
                          hintText: "DD.MM.YYYY",
                          filled: true,
                          fillColor: Color(0xFFE7EBED),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8.0),
                            borderSide: BorderSide.none,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
            Spacer(),
            ElevatedButton(
              onPressed: selectedCountry != null && selectedCity != null
                  ? () {
                Navigator.pushNamed(context, '/match');
              }
                  : null,
              style: ElevatedButton.styleFrom(
                backgroundColor:
                selectedCountry != null && selectedCity != null ? Color(0xFF77C2C8) : Color(0xFFE0E0E0),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16.0),
                ),
                fixedSize: Size(327, 48),
                elevation: 0,
              ),
              child: Text(
                "Create an account",
                style: TextStyle(
                  fontFamily: 'Fira Sans Condensed',
                  fontSize: 16,
                  fontWeight: FontWeight.w400,
                  color: selectedCountry != null && selectedCity != null ? Color(0xFFFFFFFF) : Color(0xFFBDBDBD),
                ),
              ),
            ),
            SizedBox(height: 16),
            ProfileProgressIndicator(step: 3),
            SizedBox(height: 16),
          ],
        ),
      ),
    );
  }
}
