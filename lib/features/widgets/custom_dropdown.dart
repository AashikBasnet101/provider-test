import 'package:flutter/material.dart';

class DropDown extends StatelessWidget {
  final String? value;
  final String? labelText;
  final void Function(String?)? onChanged;
  final List<String> items;
  final String? Function(String?)? validator;

  const DropDown({
    super.key,
    required this.items,
    this.labelText,
    this.onChanged,
    this.validator,
    this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(12),
      child: DropdownButtonFormField<String>(
        value: (value == null || value!.isEmpty) ? null : value,
        decoration: InputDecoration(
          labelText: labelText,
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
          contentPadding: const EdgeInsets.symmetric(horizontal: 12),
        ),
        hint: Text('Select ${labelText ?? ''}'),
        items: items.map((item) {
          return DropdownMenuItem<String>(value: item, child: Text(item));
        }).toList(),
        validator: validator,
        onChanged: onChanged,
      ),
    );
  }
}
