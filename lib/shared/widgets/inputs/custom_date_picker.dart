import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:intl/intl.dart';

class CustomDatePicker extends StatelessWidget {
  final String name;
  final String label;
  final IconData? prefixIcon;
  final String? Function(DateTime?)? validator;
  final DateTime? initialValue;
  final DateTime? firstDate;
  final DateTime? lastDate;
  final DateTime? initialDate;

  const CustomDatePicker({
    super.key,
    required this.name,
    required this.label,
    this.prefixIcon,
    this.validator,
    this.initialValue,
    this.firstDate,
    this.lastDate,
    this.initialDate,
  });

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;

    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: FormBuilderDateTimePicker(
        name: name,
        initialValue: initialValue,
        initialDate: initialDate,
        inputType: InputType.date,
        format: DateFormat('dd/MM/yyyy'),
        firstDate: firstDate,
        lastDate: lastDate,
        validator: validator,
        decoration: InputDecoration(
          labelText: label,
          prefixIcon: prefixIcon != null
              ? Icon(prefixIcon, color: colors.primary)
              : null,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide.none,
          ),
          filled: true,
          fillColor: Colors.transparent,
          contentPadding:
              const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
        ),
      ),
    );
  }
}
