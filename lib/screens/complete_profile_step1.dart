import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../widgets/progress_indicator.dart';
import '../widgets/fields.dart';
import '../providers/profile_provider.dart';

class CompleteProfileStep1 extends StatefulWidget {
  @override
  _CompleteProfileStep1State createState() => _CompleteProfileStep1State();
}

class _CompleteProfileStep1State extends State<CompleteProfileStep1> {
  final firstNameController = TextEditingController();
  final lastNameController = TextEditingController();
  final dobController = TextEditingController();
  String? selectedGender;
  bool isFormValid = false;

  @override
  void initState() {
    super.initState();

    // Загружаем данные из провайдера (если они уже были сохранены)
    final provider = Provider.of<ProfileProvider>(context, listen: false);
    firstNameController.text = provider.firstName;
    lastNameController.text = provider.lastName;
    dobController.text = provider.dob;
    selectedGender = provider.gender;

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

  void _saveAndNext() {
    final provider = Provider.of<ProfileProvider>(context, listen: false);
    provider.updateProfileStep1(
      firstName: firstNameController.text,
      lastName: lastNameController.text,
      dob: dobController.text,
      gender: selectedGender!,
    );

    Navigator.pushNamed(context, '/step2'); // Переход на следующий шаг
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
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              ProfileHeader(),
              SizedBox(height: 8),
              ProfileDescription(
                  text: "Let’s start with some basic information!"),
              SizedBox(height: 32),
              CustomTextField(
                  label: "First Name", controller: firstNameController),
              SizedBox(height: 16),
              CustomTextField(
                  label: "Last Name", controller: lastNameController),
              SizedBox(height: 24),
              _buildGenderSection(),
              SizedBox(height: 16),
              _buildDatePickerField(),
              SizedBox(height: 32),
              SubmitButton(
                text: "Complete form",
                isEnabled: isFormValid,
                onPressed: isFormValid ? _saveAndNext : null,
              ),
              SizedBox(height: 16),
              ProfileProgressIndicator(step: 1),
              SizedBox(height: 24),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildGenderSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text("Gender",
            style: TextStyle(fontSize: 16, color: Color(0xFF8AC0C7))),
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
        labelStyle: TextStyle(fontSize: 16, color: Color(0xFF8AC0C7)),
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
            fontSize: 14,
            color: Color(0xFF121414),
          ),
        ),
      ],
    );
  }
}
