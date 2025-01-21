import 'package:flutter/material.dart';
import '../widgets/progress_indicator.dart';

class CompleteProfileStep1 extends StatefulWidget {
  @override
  _CompleteProfileStep1State createState() => _CompleteProfileStep1State();
}

class _CompleteProfileStep1State extends State<CompleteProfileStep1> {
  final TextEditingController firstNameController = TextEditingController(text: "Jihan");
  final TextEditingController lastNameController = TextEditingController(text: "Khan");
  final TextEditingController dobController = TextEditingController(text: "04.07.2003");
  String? selectedGender;

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
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Complete your profile",
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 8),
            Text(
              "Let’s start with some basic information!",
              style: TextStyle(
                fontSize: 16,
                color: Colors.black54,
              ),
            ),
            SizedBox(height: 24),
            TextField(
              controller: firstNameController,
              decoration: InputDecoration(
                labelText: "First Name",
              ),
            ),
            SizedBox(height: 16),
            TextField(
              controller: lastNameController,
              decoration: InputDecoration(
                labelText: "Last Name",
              ),
            ),
            SizedBox(height: 16),
            Text("Gender"),
            SizedBox(height: 8),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                GenderRadioButton(
                  label: "Male",
                  groupValue: selectedGender,
                  onChanged: (value) {
                    setState(() {
                      selectedGender = value;
                    });
                  },
                ),
                GenderRadioButton(
                  label: "Female",
                  groupValue: selectedGender,
                  onChanged: (value) {
                    setState(() {
                      selectedGender = value;
                    });
                  },
                ),
                GenderRadioButton(
                  label: "Beyond Binary",
                  groupValue: selectedGender,
                  onChanged: (value) {
                    setState(() {
                      selectedGender = value;
                    });
                  },
                ),
              ],
            ),
            SizedBox(height: 16),
            TextField(
              controller: dobController,
              decoration: InputDecoration(
                labelText: "Date of birth",
                suffixIcon: Icon(Icons.calendar_today),
              ),
              readOnly: true,
              onTap: () async {
                DateTime? pickedDate = await showDatePicker(
                  context: context,
                  initialDate: DateTime(2003, 7, 4),
                  firstDate: DateTime(1900),
                  lastDate: DateTime.now(),
                );
                if (pickedDate != null) {
                  setState(() {
                    dobController.text =
                    "${pickedDate.day.toString().padLeft(2, '0')}.${pickedDate.month.toString().padLeft(2, '0')}.${pickedDate.year}";
                  });
                }
              },
            ),
            Spacer(),
            ElevatedButton(
              onPressed: () {
                Navigator.pushNamed(context, '/step2');
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Color(0xFF4CAF93),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              child: Text("Complete form"),
            ),
            SizedBox(height: 16),
            ProfileProgressIndicator(step: 1),
          ],
        ),
      ),
    );
  }
}

class GenderRadioButton extends StatelessWidget {
  final String label;
  final String? groupValue;
  final ValueChanged<String?> onChanged; // Изменено на String?

  const GenderRadioButton({
    required this.label,
    required this.groupValue,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => onChanged(label),
      child: Row(
        children: [
          Radio<String?>(
            value: label,
            groupValue: groupValue,
            onChanged: onChanged,
          ),
          Text(label),
        ],
      ),
    );
  }
}

