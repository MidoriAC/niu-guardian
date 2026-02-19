import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:niu_guardian/shared/widgets/inputs/custom_autocomplete.dart';
import '../../../../shared/widgets/inputs/custom_text_field.dart';
import '../../../../shared/widgets/inputs/custom_date_picker.dart';
import '../../../../shared/widgets/inputs/custom_dropdown.dart';
import '../../../../shared/widgets/inputs/custom_radio_group.dart';
import '../../../../shared/widgets/inputs/custom_checkbox_group.dart';
import '../../../../shared/widgets/inputs/custom_switch.dart';

class ParentFormSection extends StatelessWidget {
  const ParentFormSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Datos del Responsable',
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 16),

        // Campos Base (Obligatorios)
        CustomTextField(
          name: 'name',
          label: 'Nombre *',
          prefixIcon: Icons.person,
          validator: FormBuilderValidators.required(
              errorText: 'Este campo es obligatorio'),
        ),
        CustomTextField(
          name: 'surname',
          label: 'Apellido *',
          prefixIcon: Icons.person_outline,
          validator: FormBuilderValidators.required(
              errorText: 'Este campo es obligatorio'),
        ),
        CustomTextField(
          name: 'email',
          label: 'Email *',
          prefixIcon: Icons.email,
          keyboardType: TextInputType.emailAddress,
          validator: FormBuilderValidators.compose([
            FormBuilderValidators.required(
                errorText: 'Este campo es obligatorio'),
            FormBuilderValidators.email(errorText: 'Ingrese un email válido'),
          ]),
        ),
        CustomTextField(
          name: 'phone',
          label: 'Teléfono *',
          prefixIcon: Icons.phone,
          keyboardType: TextInputType.phone,
          validator: FormBuilderValidators.compose([
            FormBuilderValidators.required(
                errorText: 'Este campo es obligatorio'),
            FormBuilderValidators.minLength(8,
                errorText: 'Mínimo 8 caracteres'),
            FormBuilderValidators.numeric(errorText: 'Solo números'),
          ]),
        ),
        CustomDatePicker(
          name: 'birthdate',
          label: 'Fecha de Nacimiento *',
          prefixIcon: Icons.calendar_today,
          lastDate: DateTime.now().subtract(const Duration(days: 365 * 18)),
          initialDate: DateTime(2000, 1, 1),
          validator: FormBuilderValidators.required(
              errorText: 'Este campo es obligatorio'),
        ),
        CustomTextField(
          name: 'documentId',
          label: 'Documento de Identificación *',
          prefixIcon: Icons.badge,
          validator: FormBuilderValidators.required(
              errorText: 'Este campo es obligatorio'),
        ),

        const Divider(height: 32),
        const Text(
          'Información Adicional',
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 16),

        // Campos Adicionales (Tipos variados)
        // 1. Select
        CustomDropdown<String>(
          name: 'gender',
          label: 'Género *',
          prefixIcon: Icons.wc,
          validator: FormBuilderValidators.required(
              errorText: 'Este campo es obligatorio'),
          items: const [
            DropdownMenuItem(value: 'M', child: Text('Masculino')),
            DropdownMenuItem(value: 'F', child: Text('Femenino')),
            DropdownMenuItem(value: 'O', child: Text('Otro')),
          ],
        ),

        // 2. Radio button
        CustomRadioGroup<String>(
          name: 'civilStatus',
          label: 'Estado Civil *',
          validator: FormBuilderValidators.required(
              errorText: 'Este campo es obligatorio'),
          options: const [
            FormBuilderFieldOption(value: 'soltero', child: Text('Soltero/a')),
            FormBuilderFieldOption(value: 'casado', child: Text('Casado/a')),
            FormBuilderFieldOption(value: 'otro', child: Text('Otro')),
          ],
        ),

        // 3. Checkboxes
        CustomCheckboxGroup<String>(
          name: 'preferences',
          label: 'Preferencias de Contacto',
          options: const [
            FormBuilderFieldOption(value: 'whatsapp', child: Text('WhatsApp')),
            FormBuilderFieldOption(value: 'email', child: Text('Email')),
            FormBuilderFieldOption(value: 'call', child: Text('Llamada')),
          ],
        ),

        // 4. Switch
        const CustomSwitch(
          name: 'hasHealthInsurance',
          title: '¿Tiene seguro médico privado?',
          subtitle: 'Seleccione si cuenta con cobertura',
        ),

        const CustomSwitch(
          name: 'isEmployed',
          title: '¿Tiene empleo actualmente?',
          subtitle: 'Seleccione si trabaja actualmente',
        ),

        CustomAutocomplete(
          name: 'cityOfResidence',
          label: 'Ciudad de Residencia *',
          prefixIcon: Icons.location_city,
          validator: FormBuilderValidators.required(
              errorText: 'Este campo es obligatorio'),
          options: const [
            'Ciudad de Guatemala',
            'Mixco',
            'Villa Nueva',
            'Quetzaltenango',
            'Huehuetenango',
            'Santa Cruz del Quiché',
            'Cobán',
            'Antigua Guatemala',
          ],
        ),
        // 6. Textarea
        CustomTextField(
          maxLines: 3,
          name: 'notes',
          label: 'Notas Adicionales',
          keyboardType: TextInputType.multiline,
        ),
      ],
    );
  }
}
