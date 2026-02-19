import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';

class CustomSwitch extends StatelessWidget {
  final String name;
  final String title;
  final String? subtitle;
  final FormFieldValidator<bool>? validator;
  final bool initialValue;

  const CustomSwitch({
    super.key,
    required this.name,
    required this.title,
    this.subtitle,
    this.validator,
    this.initialValue = false,
  });

  @override
  Widget build(BuildContext context) {
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
      child: FormBuilderSwitch(
        name: name,
        title: Text(
          title,
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        subtitle: subtitle != null ? Text(subtitle!) : null,
        initialValue: initialValue,
        validator: validator,
        decoration: const InputDecoration(
          border: InputBorder.none,
          contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        ),
        activeColor: Theme.of(context).colorScheme.primary,
      ),
    );
  }
}
