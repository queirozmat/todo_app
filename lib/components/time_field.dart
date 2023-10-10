import 'package:flutter/material.dart';

class TimeField extends StatelessWidget {
  final TextEditingController controller;
  final String labelText;
  final VoidCallback onTap;
  final String? Function(String?) validator;

  const TimeField({
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
              suffixIcon: const Icon(Icons.access_time),
            ),
            validator: validator,
          ),
        ),
      ),
    );
  }
}
