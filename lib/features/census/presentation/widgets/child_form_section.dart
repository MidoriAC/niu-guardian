import 'package:flutter/material.dart';

import 'package:form_builder_validators/form_builder_validators.dart';
import '../../../../shared/widgets/inputs/custom_text_field.dart';
import '../../../../shared/widgets/inputs/custom_date_picker.dart';
import '../../../../shared/widgets/inputs/custom_dropdown.dart';

class ChildFormSection extends StatelessWidget {
  final int index;
  final VoidCallback onRemove;

  const ChildFormSection({
    super.key,
    required this.index,
    required this.onRemove,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 24),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      elevation: 4,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Hijo #${index + 1}',
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.delete, color: Colors.red),
                  onPressed: onRemove,
                ),
              ],
            ),
            const SizedBox(height: 16),
            CustomTextField(
              name: 'child_${index}_name',
              label: 'Nombre *',
              prefixIcon: Icons.person,
              validator: FormBuilderValidators.required(
                  errorText: 'Este campo es obligatorio'),
            ),
            CustomTextField(
              name: 'child_${index}_surname',
              label: 'Apellido *',
              prefixIcon: Icons.person_outline,
              validator: FormBuilderValidators.required(
                  errorText: 'Este campo es obligatorio'),
            ),
            CustomDatePicker(
              name: 'child_${index}_birthdate',
              label: 'Fecha de Nacimiento *',
              prefixIcon: Icons.cake,
              lastDate: DateTime.now(),
              initialDate: DateTime(2015, 1, 1),
              validator: FormBuilderValidators.required(
                  errorText: 'Este campo es obligatorio'),
            ),
            CustomTextField(
              name: 'child_${index}_age',
              label: 'Edad *',
              prefixIcon: Icons.onetwothree,
              keyboardType: TextInputType.number,
              validator: FormBuilderValidators.compose([
                FormBuilderValidators.required(
                    errorText: 'Este campo es obligatorio'),
                FormBuilderValidators.numeric(errorText: 'Solo números'),
                (val) {
                  return null;
                }
              ]),
            ),
            CustomDropdown<String>(
              name: 'child_${index}_hairColor',
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
      ),
    );
  }
}
