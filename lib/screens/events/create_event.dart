import 'package:flutter/material.dart';
import 'package:discoveria/components/bottom_nav_bar.dart';

import '../match_screen.dart';

class CreateEventScreen extends StatefulWidget {
  @override
  _CreateEventScreenState createState() => _CreateEventScreenState();
}

class _CreateEventScreenState extends State<CreateEventScreen> {
  final List<String> countries = ["USA", "Canada", "UK"];
  final Map<String, List<String>> cities = {
    "USA": ["New York", "Los Angeles", "Chicago"],
    "Canada": ["Toronto", "Vancouver", "Montreal"],
    "UK": ["London", "Manchester", "Liverpool"],
  };

  String? selectedDate;
  String? selectedCountry;
  List<String> availableCities = [];
  String? selectedCity;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(10.0), // 10px отступ
        child: AppBar(
          automaticallyImplyLeading: true,
          backgroundColor: Colors.transparent,
          elevation: 0,
          leading: IconButton(
            icon: Icon(Icons.arrow_back, color: Colors.black),
            onPressed: () => Navigator.pop(context),
          ),
        ),
      ),
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextButton(
              onPressed: () {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                    builder: (context) => MatchScreen(initialTabIndex: 1), // Открываем вкладку Events
                  ),
                );
              },
              child: Row(
                children: [
                  Icon(Icons.arrow_back, color: Colors.black),
                  SizedBox(width: 10),
                  Text(
                    "Back to feed",
                    style: TextStyle(
                      fontFamily: 'Fira Sans Condensed',
                      fontSize: 20,
                      color: Colors.black,
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 10),
            // Блок с изображением и заголовком
            Row(
              children: [
                Container(
                  width: 128,
                  height: 135,
                  decoration: BoxDecoration(
                    color: Color(0xFF20A090),
                    border: Border.all(color: Colors.black),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Center(
                    child: Icon(Icons.add_photo_alternate,
                        size: 50, color: Colors.white),
                  ),
                ),
                SizedBox(width: 20, height: 100),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Title",
                      style: TextStyle(
                        fontFamily: 'Fira Sans Condensed',
                        fontSize: 16,
                        fontWeight: FontWeight.w400,
                        color: Color(0xFF24786D),
                      ),
                    ),
                    SizedBox(
                      width: 187,
                      child: _buildTextField(""),
                    ),
                  ],
                ),
              ],
            ),
            SizedBox(height: 20),
            Row(
              children: [
                Expanded(child: _buildCountryDropdown()),
                SizedBox(width: 10),
                Expanded(child: _buildCityDropdown()),
              ],
            ),
            SizedBox(height: 10),
            Row(
              children: [
                Expanded(child: _buildDatePicker(context)),
                SizedBox(width: 10),
                Expanded(child: _buildTextField("No. of People")),
              ],
            ),
            SizedBox(height: 10),
            _buildTextField("Address"),
            SizedBox(height: 10),
            _buildTextField("Description"),
            SizedBox(height: 20),
            Center(
              child: ElevatedButton(
                onPressed: () {
                  // TODO: Add event creation logic
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Color(0xFF20A090),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                  padding: EdgeInsets.symmetric(horizontal: 50, vertical: 12),
                ),
                child: Text(
                  "Create",
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: CustomBottomNavBar(currentIndex: 2),
    );
  }

  Widget _buildTextField(String label) {
    return TextField(
      decoration: InputDecoration(
        labelText: label,
        labelStyle: TextStyle(
          color: Colors.teal,
          fontFamily: 'Fira Sans Condensed',
        ),
        border: UnderlineInputBorder(),
      ),
    );
  }

  Widget _buildCountryDropdown() {
    return DropdownButtonFormField<String>(
      decoration: InputDecoration(
        labelText: "Country",
        labelStyle:
        TextStyle(color: Colors.teal, fontFamily: 'Fira Sans Condensed'),
        border: UnderlineInputBorder(),
      ),
      value: selectedCountry,
      items: countries.map((String country) {
        return DropdownMenuItem<String>(
          value: country,
          child: Text(country),
        );
      }).toList(),
      onChanged: (value) {
        setState(() {
          selectedCountry = value;
          availableCities = cities[value] ?? [];
          selectedCity = null; // Сброс выбора города при смене страны
        });
      },
    );
  }

  Widget _buildCityDropdown() {
    return DropdownButtonFormField<String>(
      decoration: InputDecoration(
        labelText: "City",
        labelStyle:
        TextStyle(color: Colors.teal, fontFamily: 'Fira Sans Condensed'),
        border: UnderlineInputBorder(),
      ),
      value: selectedCity,
      items: availableCities.map((String city) {
        return DropdownMenuItem<String>(
          value: city,
          child: Text(city),
        );
      }).toList(),
      onChanged: (value) {
        setState(() {
          selectedCity = value;
        });
      },
    );
  }


  Widget _buildDatePicker(BuildContext context) {
    return TextFormField(
      readOnly: true, // Запрещаем ручной ввод
      decoration: InputDecoration(
        labelText: "Date",
        labelStyle: TextStyle(
          color: Colors.teal,
          fontFamily: 'Fira Sans Condensed',
        ),
        suffixIcon: Icon(Icons.calendar_today, color: Colors.teal),
        border: UnderlineInputBorder(),
      ),
      onTap: () async {
        DateTime? pickedDate = await showDatePicker(
          context: context,
          initialDate: DateTime(2000),
          firstDate: DateTime(1900), // Нельзя выбрать прошедшую дату
          lastDate: DateTime(2010),
        );
        if (pickedDate != null) {
          setState(() {
            selectedDate = "${pickedDate.day}.${pickedDate.month}.${pickedDate.year}";
          });
        }
      },
      controller: TextEditingController(text: selectedDate),
    );
  }
}
