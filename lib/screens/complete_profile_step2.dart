import 'package:flutter/material.dart';
import '../widgets/chips_input.dart';
import '../widgets/progress_indicator.dart';

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
                "Let’s start with some basic information!",
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
            TextField(
              controller: bioController,
              decoration: InputDecoration(
                labelText: "Bio",
                labelStyle: TextStyle(
                  fontFamily: 'Fira Sans Condensed',
                  fontSize: 16,
                  fontWeight: FontWeight.w400,
                  color: Color(0xFF24786D),
                ),
                enabledBorder: UnderlineInputBorder(
                  borderSide: BorderSide(color: Color(0xFFE0E0E0)),
                ),
                focusedBorder: UnderlineInputBorder(
                  borderSide: BorderSide(color: Color(0xFF54A59B), width: 2.0),
                ),
              ),
              maxLines: 3,
              textInputAction: TextInputAction.done, // Устанавливаем действие кнопки "Done"
              onSubmitted: (value) {
                // Действие при нажатии "Return" или "Done"
                FocusScope.of(context).unfocus(); // Скрыть клавиатуру
                // Здесь можно также добавить логику сохранения, если необходимо
                print("Bio submitted: $value");
              },
            ),
            Spacer(),
            // Complete Button
            ElevatedButton(
              onPressed: isFormValid
                  ? () {
                Navigator.pushNamed(context, '/step3');
              }
                  : null,
              style: ElevatedButton.styleFrom(
                backgroundColor:
                isFormValid ? Color(0xFF77C2C8) : Color(0xFFE0E0E0),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16.0),
                ),
                fixedSize: Size(327, 48),
                elevation: 0,
              ),
              child: Text(
                isFormValid ? "Complete form" : "Complete",
                style: TextStyle(
                  fontFamily: 'Fira Sans Condensed',
                  fontSize: 16,
                  fontWeight: FontWeight.w400,
                  color: isFormValid ? Color(0xFFFFFFFF) : Color(0xFFBDBDBD),
                ),
              ),
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
