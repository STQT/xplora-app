import 'package:flutter/material.dart';
import '../widgets/progress_indicator.dart';
import '../widgets/chips_input.dart';

class CompleteProfileStep2 extends StatelessWidget {
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
              "Tell us a bit more about yourself!",
              style: TextStyle(
                fontSize: 16,
                color: Colors.black54,
              ),
            ),
            SizedBox(height: 24),
            ChipsInput(label: "Your interests"),
            SizedBox(height: 16),
            ChipsInput(label: "Languages"),
            SizedBox(height: 16),
            TextField(
              decoration: InputDecoration(
                labelText: "Bio",
              ),
              maxLines: 3,
            ),
            Spacer(),
            ElevatedButton(
              onPressed: () {
                Navigator.pushNamed(context, '/step3');
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
            ProfileProgressIndicator(step: 2),
          ],
        ),
      ),
    );
  }
}
