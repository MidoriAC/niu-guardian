import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';

class CustomAutocomplete extends StatelessWidget {
  final String name;
  final String label;
  final IconData? prefixIcon;
  final List<String> options;
  final String? Function(String?)? validator;

  const CustomAutocomplete({
    super.key,
    required this.name,
    required this.label,
    required this.options,
    this.prefixIcon,
    this.validator,
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
      child: FormBuilderField<String>(
        name: name,
        validator: validator,
        builder: (FormFieldState<String?> field) {
          return Autocomplete<String>(
            initialValue: TextEditingValue(text: field.value ?? ''),
            optionsBuilder: (TextEditingValue textEditingValue) {
              if (textEditingValue.text.isEmpty) {
                return const Iterable<String>.empty();
              }
              return options.where((String option) {
                return option
                    .toLowerCase()
                    .contains(textEditingValue.text.toLowerCase());
              });
            },
            onSelected: (String selection) {
              field.didChange(selection);
            },
            fieldViewBuilder: (BuildContext context,
                TextEditingController textEditingController,
                FocusNode focusNode,
                VoidCallback onFieldSubmitted) {
              return TextField(
                controller: textEditingController,
                focusNode: focusNode,
                onChanged: (value) {
                  field.didChange(value);
                },
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
                  errorText: field.errorText, // Muestra el error de validación
                ),
              );
            },
          );
        },
      ),
    );
  }
}
