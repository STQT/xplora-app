import 'package:flutter/material.dart';

class ChipsInput extends StatefulWidget {
  final String label;

  ChipsInput({required this.label});

  @override
  _ChipsInputState createState() => _ChipsInputState();
}

class _ChipsInputState extends State<ChipsInput> {
  final TextEditingController controller = TextEditingController();
  final List<String> chips = [];

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          widget.label,
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: Colors.black87,
          ),
        ),
        SizedBox(height: 8),
        TextField(
          controller: controller,
          decoration: InputDecoration(
            hintText: "Add ${widget.label.toLowerCase()}",
            suffixIcon: IconButton(
              icon: Icon(Icons.add),
              onPressed: () {
                if (controller.text.isNotEmpty) {
                  setState(() {
                    chips.add(controller.text);
                    controller.clear();
                  });
                }
              },
            ),
          ),
        ),
        SizedBox(height: 8),
        Wrap(
          spacing: 8,
          children: chips
              .map(
                (chip) => Chip(
              label: Text(chip),
              deleteIcon: Icon(Icons.close),
              onDeleted: () {
                setState(() {
                  chips.remove(chip);
                });
              },
            ),
          )
              .toList(),
        ),
      ],
    );
  }
}
