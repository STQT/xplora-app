import 'package:flutter/material.dart';
import '../widgets/progress_indicator.dart';
import '../widgets/fields.dart';

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
            ProfileHeader(),
            SizedBox(height: 8),

            ProfileDescription(text: "Choose your first destination!"),
            SizedBox(height: 86),

            CustomDropdownField(
              label: "Country",
              value: selectedCountry,
              options: countryCityMap.keys.toList(),
              onChanged: (value) {
                setState(() {
                  selectedCountry = value;
                  selectedCity = null;
                  availableCities = countryCityMap[value!] ?? [];
                });
              },
            ),
            SizedBox(height: 16),

            // Dropdowns for Country and City
            CustomDropdownField(
              label: "City",
              value: selectedCity,
              options: availableCities,
              onChanged: selectedCountry != null
                  ? (value) => setState(() => selectedCity = value)
                  : null,
            ),
            SizedBox(height: 24),

            // Dates of Visit Section
            DatePickerField(
                label: "From Date",
                controller: fromDateController,
                onDateSelected: () {},
                initialDate: DateTime.now(),
                lastDate: DateTime(2030, 1, 1)
            ),
            SizedBox(height: 16),
            DatePickerField(
                label: "To Date",
                controller: toDateController,
                onDateSelected: () {},
                initialDate: DateTime.now(),
                lastDate: DateTime(2030, 1, 1)
            ),
            Spacer(),

            SubmitButton(
              text: "Create an account",
              isEnabled: selectedCountry != null && selectedCity != null,
              onPressed: selectedCountry != null && selectedCity != null
                  ? () => Navigator.pushNamed(context, '/match')
                  : null,
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
