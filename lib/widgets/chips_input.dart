import 'package:flutter/material.dart';

class ChipsInput extends StatelessWidget {
  final String label;
  final ValueChanged<List<String>>? onChanged;

  ChipsInput({required this.label, this.onChanged});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(
            fontFamily: 'Fira Sans Condensed',
            fontSize: 16,
            fontWeight: FontWeight.w400,
            color: Color(0xFF24786D),
          ),
        ),
        SizedBox(height: 8),
        Wrap(
          spacing: 8.0,
          runSpacing: 4.0,
          children: [
            InputChip(
              label: Text('Add Item'),
              onDeleted: null,
              onPressed: () {
                // Example action
                if (onChanged != null) {
                  onChanged!(["Example"]);
                }
              },
            ),
          ],
        ),
      ],
    );
  }
}
