import 'package:flutter/material.dart';
import '../widgets/progress_indicator.dart';

class CompleteProfileStep1 extends StatefulWidget {
  @override
  _CompleteProfileStep1State createState() => _CompleteProfileStep1State();
}

class _CompleteProfileStep1State extends State<CompleteProfileStep1> {
  final TextEditingController firstNameController =
      TextEditingController(text: "Shokan");
  final TextEditingController lastNameController =
      TextEditingController(text: "Iliyas");
  final TextEditingController dobController =
      TextEditingController(text: "01.01.2000");
  String? selectedGender;
  bool isFormValid = false;

  @override
  void initState() {
    super.initState();
    firstNameController.addListener(_validateForm);
    lastNameController.addListener(_validateForm);
    dobController.addListener(_validateForm);
  }

  @override
  void dispose() {
    firstNameController.dispose();
    lastNameController.dispose();
    dobController.dispose();
    super.dispose();
  }

  void _validateForm() {
    setState(() {
      isFormValid = firstNameController.text.isNotEmpty &&
          lastNameController.text.isNotEmpty &&
          dobController.text.isNotEmpty &&
          selectedGender != null;
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
        padding: const EdgeInsets.symmetric(horizontal: 24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // Заголовок
            Stack(
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
                  right: 0,
                  child: Container(
                    width: 65,
                    height: 8,
                    color: Color(0xFF58C4B6),
                  ),
                ),
              ],
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
                  color: Color(0xFF797C7B),
                ),
              ),
            ),
            SizedBox(height: 86),
            // Поля ввода
            TextField(
              controller: firstNameController,
              decoration: InputDecoration(
                labelText: "First Name",
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
            ),
            SizedBox(height: 16),
            TextField(
              controller: lastNameController,
              decoration: InputDecoration(
                labelText: "Last Name",
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
            ),
            SizedBox(height: 24),
            // Поле Gender
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Gender",
                  style: TextStyle(
                    fontFamily: 'Fira Sans Condensed',
                    fontWeight: FontWeight.w400,
                    fontSize: 16,
                    height: 14 / 16,
                    letterSpacing: 0.1,
                    color: Color(0xFF24786D),
                  ),
                ),
                SizedBox(height: 16),
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Expanded(
                      child: GenderRadioButton(
                        label: "Male",
                        groupValue: selectedGender,
                        onChanged: (value) {
                          setState(() {
                            selectedGender = value;
                          });
                          _validateForm();
                        },
                      ),
                    ),
                    Expanded(
                      child: GenderRadioButton(
                        label: "Female",
                        groupValue: selectedGender,
                        onChanged: (value) {
                          setState(() {
                            selectedGender = value;
                          });
                          _validateForm();
                        },
                      ),
                    ),
                    Expanded(
                      child: GenderRadioButton(
                        label: "Beyond Binary",
                        groupValue: selectedGender,
                        onChanged: (value) {
                          setState(() {
                            selectedGender = value;
                          });
                          _validateForm();
                        },
                      ),
                    ),
                  ],
                ),
              ],
            ),
            SizedBox(height: 16),
            TextField(
              controller: dobController,
              decoration: InputDecoration(
                labelText: "Date of birth",
                labelStyle: TextStyle(
                  fontFamily: 'Fira Sans Condensed',
                  fontSize: 16,
                  fontWeight: FontWeight.w400,
                  color: Color(0xFF24786D),
                ),
                suffixIcon:
                    Icon(Icons.calendar_today, color: Color(0xFF797C7B)),
                enabledBorder: UnderlineInputBorder(
                  borderSide: BorderSide(color: Color(0xFFE0E0E0)),
                ),
                focusedBorder: UnderlineInputBorder(
                  borderSide: BorderSide(color: Color(0xFF54A59B), width: 2.0),
                ),
              ),
              readOnly: true,
              onTap: () async {
                DateTime? pickedDate = await showDatePicker(
                  context: context,
                  initialDate: DateTime(2000, 1, 1),
                  firstDate: DateTime(1900),
                  lastDate: DateTime.now(),
                );
                if (pickedDate != null) {
                  setState(() {
                    dobController.text =
                        "${pickedDate.day.toString().padLeft(2, '0')}.${pickedDate.month.toString().padLeft(2, '0')}.${pickedDate.year}";
                  });
                  _validateForm();
                }
              },
            ),
            Spacer(),
            if (isFormValid) // Показывать кнопку только если форма валидна
              ElevatedButton(
                onPressed: () {
                  Navigator.pushNamed(context, '/step2');
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Color(0xFF4CAF93),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16.0),
                  ),
                  fixedSize: Size(327, 48),
                  elevation: 0,
                ),
                child: Text(
                  "Complete form",
                  style: TextStyle(
                    fontFamily: 'Fira Sans Condensed',
                    fontSize: 16,
                    fontWeight: FontWeight.w400,
                    color: Color(0xFFFFFFFF),
                  ),
                ),
              ),
            SizedBox(height: 16),
            ProfileProgressIndicator(step: 1),
            SizedBox(height: 16)
          ],
        ),
      ),
    );
  }
}

class GenderRadioButton extends StatelessWidget {
  final String label;
  final String? groupValue;
  final ValueChanged<String?> onChanged;

  const GenderRadioButton({
    required this.label,
    required this.groupValue,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 23.0, bottom: 8.0),
      // Отступ для положения радиобатона
      child: Row(
        children: [
          SizedBox(
            width: 16, // Ширина марки
            height: 18, // Высота марки
            child: Radio<String?>(
              value: label,
              groupValue: groupValue,
              onChanged: onChanged,
              fillColor:
                  MaterialStateProperty.all(Color(0xFF54A59B)), // Цвет марки
            ),
          ),
          SizedBox(width: 13), // Расстояние между маркой и текстом
          Text(
            label,
            style: TextStyle(
              fontFamily: 'Fira Sans Condensed',
              fontStyle: FontStyle.normal,
              fontWeight: FontWeight.w400,
              fontSize: 14,
              // Размер шрифта
              height: 20 / 14,
              // Высота строки
              letterSpacing: 0.1,
              // Межбуквенный интервал
              color: Color(0xFF000000), // Цвет текста
            ),
          ),
        ],
      ),
    );
  }
}
