import 'package:flutter/material.dart';

class DateField extends StatelessWidget {
  final TextEditingController controller;
  final String labelText;
  final VoidCallback onTap;
  final String? Function(String?) validator;

  const DateField({
    super.key,
    required this.controller,
    required this.labelText,
    required this.onTap,
    required this.validator,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: InkWell(
        onTap: onTap,
        child: IgnorePointer(
          child: TextFormField(
            controller: controller,
            decoration: InputDecoration(
              labelText: labelText,
              floatingLabelBehavior: FloatingLabelBehavior.always,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(15),
              ),
              suffixIcon: const Icon(Icons.calendar_today),
            ),
            validator: validator,
          ),
        ),
      ),
    );
  }
}
