import 'package:flutter/material.dart';

class CustomTextField extends StatelessWidget {
  final String label;
  final TextEditingController controller;

  const CustomTextField({required this.label, required this.controller});

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      decoration: InputDecoration(
        labelText: label,
        labelStyle: TextStyle(fontSize: 16, color: Color(0xFF8AC0C7)),
        enabledBorder: UnderlineInputBorder(
          borderSide: BorderSide(color: Color(0xFFE0E0E0)),
        ),
        focusedBorder: UnderlineInputBorder(
          borderSide: BorderSide(color: Color(0xFF54A59B), width: 2.0),
        ),
      ),
    );
  }
}

class DatePickerField extends StatelessWidget {
  final String label;
  final TextEditingController controller;
  final VoidCallback onDateSelected;
  final DateTime initialDate;
  final DateTime lastDate;

  DatePickerField({
    Key? key,
    required this.label,
    required this.controller,
    required this.onDateSelected,
    DateTime? initialDate,
    DateTime? lastDate,
  })  : initialDate = initialDate ?? DateTime(2000, 1, 1),
        lastDate = lastDate ?? DateTime.now(),
        super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      decoration: InputDecoration(
        labelText: label,
        suffixIcon: Icon(Icons.calendar_today, color: Color(0xFF8AC0C7)),
      ),
      readOnly: true,
      onTap: () async {
        final pickedDate = await showDatePicker(
          context: context,
          initialDate: initialDate,
          firstDate: DateTime(1900),
          lastDate: lastDate,
        );
        if (pickedDate != null) {
          controller.text =
          "${pickedDate.day.toString().padLeft(2, '0')}.${pickedDate.month.toString().padLeft(2, '0')}.${pickedDate.year}";
          onDateSelected();
        }
      },
    );
  }
}


class SubmitButton extends StatelessWidget {
  final String text;
  final bool isEnabled;
  final VoidCallback? onPressed;

  const SubmitButton(
      {required this.text, required this.isEnabled, required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: isEnabled ? onPressed : null,
      style: ElevatedButton.styleFrom(
        backgroundColor: isEnabled ? Color(0xFF77C2C8) : Color(0xFFE0E0E0),
        shape:
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(16.0)),
        fixedSize: Size(327, 48),
      ),
      child: Text(
        text,
        style: TextStyle(
            fontSize: 16, color: isEnabled ? Colors.white : Color(0xFFBDBDBD)),
      ),
    );
  }
}

class ProfileHeader extends StatelessWidget {

  const ProfileHeader();

  @override
  Widget build(BuildContext context) {
    return Align(
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
    );
  }
}

class ProfileDescription extends StatelessWidget {
  final String text;

  const ProfileDescription({required this.text});

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: TextStyle(fontSize: 16, color: Color(0xFF77C2C8)),
    );
  }
}

class CustomDropdownField extends StatelessWidget {
  final String label;
  final String? value;
  final List<String> options;
  final ValueChanged<String?>? onChanged;

  const CustomDropdownField({
    required this.label,
    required this.value,
    required this.options,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return DropdownButtonFormField<String>(
      value: value,
      items: options
          .map((option) => DropdownMenuItem(
                value: option,
                child: Text(option, style: TextStyle(fontSize: 16)),
              ))
          .toList(),
      onChanged: onChanged,
      decoration: InputDecoration(
        labelText: label,
        filled: true,
        fillColor: Color(0xFFE7EBED),
      ),
      icon: Icon(Icons.arrow_drop_down, color: Color(0xFF24786D)),
    );
  }
}
