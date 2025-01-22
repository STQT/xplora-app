import 'package:flutter/material.dart';
import 'package:dropdown_search/dropdown_search.dart';

class ChipsInput extends StatelessWidget {
  final String label;
  final List<String> options;
  final List<String> selectedItems;
  final ValueChanged<List<String>> onChanged;

  ChipsInput({
    required this.label,
    required this.options,
    required this.selectedItems,
    required this.onChanged,
  });

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
        DropdownSearch<String>.multiSelection(
          items: options,
          dropdownDecoratorProps: DropDownDecoratorProps(
            dropdownSearchDecoration: InputDecoration(
              hintText: "Select", // Placeholder
              filled: true,
              fillColor: Color(0xFFE7EBED),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8.0),
                borderSide: BorderSide.none,
              ),
              contentPadding:
              EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
            ),
          ),
          popupProps: PopupPropsMultiSelection.menu(
            showSearchBox: true,
            searchFieldProps: TextFieldProps(
              decoration: InputDecoration(
                hintText: "Search or select", // Search hint
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8.0),
                ),
              ),
            ),
          ),
          onChanged: onChanged,
          selectedItems: selectedItems,
        ),
      ],
    );
  }
}
