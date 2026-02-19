import 'package:flutter/material.dart';

import 'package:form_builder_validators/form_builder_validators.dart';
import '../../../../shared/widgets/inputs/custom_text_field.dart';
import '../../../../shared/widgets/inputs/custom_date_picker.dart';
import '../../../../shared/widgets/inputs/custom_dropdown.dart';

class ChildFormSection extends StatelessWidget {
  final int index;
  final VoidCallback onRemove;
  final String? uniqueCode;
  final Map<String, dynamic>? initialValues;

  const ChildFormSection({
    super.key,
    required this.index,
    required this.onRemove,
    this.uniqueCode,
    this.initialValues,
  });

  @override
  Widget build(BuildContext context) {
    debugPrint(
        "Generando formulario para el hijo $index con código: $uniqueCode");
    final theme = Theme.of(context);

    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      elevation: 2,
      child: ExpansionTile(
        maintainState: true,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        collapsedShape:
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        tilePadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        expandedCrossAxisAlignment: CrossAxisAlignment.start,
        childrenPadding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
        title: Text(
          'Hijo #${index + 1}',
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
        subtitle: uniqueCode != null
            ? Padding(
                padding: const EdgeInsets.only(top: 4.0),
                child: Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 8, vertical: 2),
                      decoration: BoxDecoration(
                        color: theme.colorScheme.primary.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Text(
                        uniqueCode!,
                        style: TextStyle(
                          fontSize: 12,
                          color: theme.colorScheme.primary,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
              )
            : const Padding(
                padding: EdgeInsets.only(top: 4.0),
                child: Text(
                  'Código único se generará al guardar',
                  style: TextStyle(fontSize: 12, color: Colors.grey),
                ),
              ),
        trailing: IconButton(
          icon: const Icon(Icons.delete_outline, color: Colors.red),
          onPressed: onRemove,
        ),
        children: [
          const Divider(),
          const SizedBox(height: 8),
          CustomTextField(
            name: 'child_${index}_name',
            initialValue: initialValues?['child_${index}_name'],
            label: 'Nombre *',
            prefixIcon: Icons.person,
            validator: FormBuilderValidators.required(
                errorText: 'Este campo es obligatorio'),
          ),
          CustomTextField(
            name: 'child_${index}_surname',
            initialValue: initialValues?['child_${index}_surname'],
            label: 'Apellido *',
            prefixIcon: Icons.person_outline,
            validator: FormBuilderValidators.required(
                errorText: 'Este campo es obligatorio'),
          ),
          CustomDatePicker(
            name: 'child_${index}_birthdate',
            initialValue: initialValues?['child_${index}_birthdate'],
            label: 'Fecha de Nacimiento *',
            prefixIcon: Icons.cake,
            lastDate: DateTime.now(),
            initialDate: DateTime(2015, 1, 1),
            validator: FormBuilderValidators.required(
                errorText: 'Este campo es obligatorio'),
          ),
          CustomTextField(
            name: 'child_${index}_age',
            initialValue: initialValues?['child_${index}_age'],
            label: 'Edad *',
            prefixIcon: Icons.onetwothree,
            keyboardType: TextInputType.number,
            validator: FormBuilderValidators.compose([
              FormBuilderValidators.required(
                  errorText: 'Este campo es obligatorio'),
              FormBuilderValidators.numeric(errorText: 'Solo números'),
            ]),
          ),
          CustomDropdown<String>(
            name: 'child_${index}_hairColor',
            initialValue: initialValues?['child_${index}_hairColor'],
            label: 'Color de Pelo *',
            prefixIcon: Icons.palette,
            validator: FormBuilderValidators.required(
                errorText: 'Este campo es obligatorio'),
            items: const [
              DropdownMenuItem(value: 'Negro', child: Text('Negro')),
              DropdownMenuItem(value: 'Castaño', child: Text('Castaño')),
              DropdownMenuItem(value: 'Rubio', child: Text('Rubio')),
              DropdownMenuItem(value: 'Rojo', child: Text('Rojo')),
              DropdownMenuItem(value: 'Otro', child: Text('Otro')),
            ],
          ),
        ],
      ),
    );
  }
}
