import 'package:flutter/material.dart';
import '../widgets/progress_indicator.dart';
import '../widgets/fields.dart';

class CompleteProfileStep1 extends StatefulWidget {
  @override
  _CompleteProfileStep1State createState() => _CompleteProfileStep1State();
}

class _CompleteProfileStep1State extends State<CompleteProfileStep1> {
  final firstNameController = TextEditingController(text: "Shokan");
  final lastNameController = TextEditingController(text: "Iliyas");
  final dobController = TextEditingController(text: "01.01.2000");
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
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SingleChildScrollView( // ⬅️ Добавили прокрутку, если контент превышает экран
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              ProfileHeader(),
              SizedBox(height: 8),
              ProfileDescription(text: "Let’s start with some basic information!"),
              SizedBox(height: 32),

              CustomTextField(label: "First Name", controller: firstNameController),
              SizedBox(height: 16),
              CustomTextField(label: "Last Name", controller: lastNameController),
              SizedBox(height: 24),


              _buildGenderSection(),
              SizedBox(height: 16),
              _buildDatePickerField(),

              SizedBox(height: 32), // ⬅️ Добавил отступ перед кнопкой

              _buildSubmitButton(),
              SizedBox(height: 16),

              ProfileProgressIndicator(step: 1), // ⬅️ Прогресс-бар теперь всегда виден
              SizedBox(height: 24),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Align(
      alignment: Alignment.center,
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          RichText(
            text: TextSpan(
              style: _textStyle(fontSize: 24, color: Color(0xFF121414)),
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
              color: Color(0xFF8AC0C7),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTextField(String label, TextEditingController controller) {
    return TextField(
      controller: controller,
      decoration: InputDecoration(
        labelText: label,
        labelStyle: _textStyle(fontSize: 16, color: Color(0xFF8AC0C7)),
        enabledBorder: UnderlineInputBorder(
          borderSide: BorderSide(color: Color(0xFFE0E0E0)),
        ),
        focusedBorder: UnderlineInputBorder(
          borderSide: BorderSide(color: Color(0xFF54A59B), width: 2.0),
        ),
      ),
    );
  }

  Widget _buildGenderSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text("Gender", style: _textStyle(fontSize: 16, color: Color(0xFF8AC0C7))),
        SizedBox(height: 16),
        Wrap(
          spacing: 16.0,
          runSpacing: 8.0,
          children: ["Male", "Female", "Beyond Binary"]
              .map((gender) => GenderRadioButton(
            label: gender,
            groupValue: selectedGender,
            onChanged: (value) {
              setState(() => selectedGender = value);
              _validateForm();
            },
          ))
              .toList(),
        ),
      ],
    );
  }

  Widget _buildDatePickerField() {
    return TextField(
      controller: dobController,
      decoration: InputDecoration(
        labelText: "Date of birth",
        labelStyle: _textStyle(fontSize: 16, color: Color(0xFF8AC0C7)),
        suffixIcon: Icon(Icons.calendar_today, color: Color(0xFF8AC0C7)),
        enabledBorder: UnderlineInputBorder(
          borderSide: BorderSide(color: Color(0xFFE0E0E0)),
        ),
        focusedBorder: UnderlineInputBorder(
          borderSide: BorderSide(color: Color(0xFF54A59B), width: 2.0),
        ),
      ),
      readOnly: true,
      onTap: () async {
        final pickedDate = await showDatePicker(
          context: context,
          initialDate: DateTime(2000, 1, 1),
          firstDate: DateTime(1900),
          lastDate: DateTime.now(),
        );
        if (pickedDate != null) {
          dobController.text =
          "${pickedDate.day.toString().padLeft(2, '0')}.${pickedDate.month.toString().padLeft(2, '0')}.${pickedDate.year}";
          _validateForm();
        }
      },
    );
  }

  Widget _buildSubmitButton() {
    return ElevatedButton(
      onPressed: isFormValid ? () => Navigator.pushNamed(context, '/step2') : null,
      style: ElevatedButton.styleFrom(
        backgroundColor: isFormValid ? Color(0xFF77C2C8) : Color(0xFFE0E0E0),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16.0),
        ),
        fixedSize: Size(327, 48),
        elevation: 0,
      ),
      child: Text(
        isFormValid ? "Complete form" : "Complete",
        style: _textStyle(
          fontSize: 16,
          color: isFormValid ? Colors.white : Color(0xFFBDBDBD),
        ),
      ),
    );
  }

  TextStyle _textStyle({required double fontSize, required Color color}) {
    return TextStyle(
      fontFamily: 'Fira Sans Condensed',
      fontSize: fontSize,
      fontWeight: FontWeight.w400,
      color: color,
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
    return Row(
      children: [
        Radio<String?>(
          value: label,
          groupValue: groupValue,
          onChanged: onChanged,
          fillColor: MaterialStateProperty.all(Color(0xFF8AC0C7)),
        ),
        SizedBox(width: 8),
        Text(
          label,
          style: TextStyle(
            fontFamily: 'Fira Sans Condensed',
            fontSize: 14,
            fontWeight: FontWeight.w400,
            color: Color(0xFF121414),
          ),
        ),
      ],
    );
  }
}
