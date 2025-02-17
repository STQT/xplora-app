import 'package:flutter/material.dart';
import '../widgets/chips_input.dart';
import '../widgets/progress_indicator.dart';
import '../widgets/fields.dart';

class CompleteProfileStep2 extends StatefulWidget {
  @override
  _CompleteProfileStep2State createState() => _CompleteProfileStep2State();
}

class _CompleteProfileStep2State extends State<CompleteProfileStep2> {
  final TextEditingController bioController = TextEditingController();

  bool isFormValid = false;
  List<String> selectedInterests = [];
  List<String> selectedLanguages = [];

  List<String> allInterests = [
    "Sports",
    "Music",
    "Technology",
    "Art",
    "Traveling",
    "Gaming",
    "Cooking",
  ];

  List<String> allLanguages = [
    "English",
    "Spanish",
    "French",
    "German",
    "Russian",
    "Chinese",
    "Japanese",
    "Arabic",
  ];

  @override
  void initState() {
    super.initState();
    bioController.addListener(_validateForm);
  }

  @override
  void dispose() {
    bioController.dispose();
    super.dispose();
  }

  void _validateForm() {
    setState(() {
      isFormValid = selectedInterests.isNotEmpty &&
          selectedLanguages.isNotEmpty &&
          bioController.text.isNotEmpty;
    });
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
        padding: const EdgeInsets.symmetric(horizontal: 20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // Header with underline
            ProfileHeader(),
            SizedBox(height: 8),

            ProfileDescription(text: "Tell us a bit more about yourself!"),
            SizedBox(height: 86),

            // ChipsInput for Interests
            ChipsInput(
              label: "Interests",
              options: allInterests,
              selectedItems: selectedInterests,
              onChanged: (value) {
                setState(() {
                  selectedInterests = value;
                });
                _validateForm();
              },
            ),
            SizedBox(height: 16),

            // ChipsInput for Languages
            ChipsInput(
              label: "Languages",
              options: allLanguages,
              selectedItems: selectedLanguages,
              onChanged: (value) {
                setState(() {
                  selectedLanguages = value;
                });
                _validateForm();
              },
            ),
            SizedBox(height: 16),

            // Bio Input
            CustomTextField(label: "Bio", controller: bioController),
            Spacer(),

            // Complete Button
            SubmitButton(
              text: "Complete form",
              isEnabled: isFormValid,
              onPressed: isFormValid ? () => Navigator.pushNamed(context, '/step3') : null,
            ),
            SizedBox(height: 16),

            ProfileProgressIndicator(step: 2),
            SizedBox(height: 16),
          ],
        ),
      ),
    );
  }
}
