import 'package:flutter/material.dart';
import '../widgets/progress_indicator.dart';

class CompleteProfileStep3 extends StatelessWidget {
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
              "Choose your first destination!",
              style: TextStyle(
                fontSize: 16,
                color: Colors.black54,
              ),
            ),
            SizedBox(height: 24),
            Row(
              children: [
                Expanded(
                  child: DropdownButtonFormField<String>(
                    items: [
                      DropdownMenuItem(value: "Country 1", child: Text("Country 1")),
                      DropdownMenuItem(value: "Country 2", child: Text("Country 2")),
                    ],
                    onChanged: (value) {},
                    decoration: InputDecoration(labelText: "Country"),
                  ),
                ),
                SizedBox(width: 16),
                Expanded(
                  child: DropdownButtonFormField<String>(
                    items: [
                      DropdownMenuItem(value: "City 1", child: Text("City 1")),
                      DropdownMenuItem(value: "City 2", child: Text("City 2")),
                    ],
                    onChanged: (value) {},
                    decoration: InputDecoration(labelText: "City"),
                  ),
                ),
              ],
            ),
            SizedBox(height: 24),
            TextField(
              decoration: InputDecoration(
                labelText: "Dates of visit",
              ),
            ),
            Spacer(),
            ElevatedButton(
              onPressed: () {
                Navigator.pushNamed(context, '/match'); // Переход на MatchScreen
              },
              child: Text("Create an account"),
            ),
            SizedBox(height: 16),
            ProfileProgressIndicator(step: 3),
          ],
        ),
      ),
    );
  }
}
