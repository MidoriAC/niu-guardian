import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:niu_guardian/features/census/domain/entities/parent_entity.dart';
import 'package:niu_guardian/features/census/presentation/providers/census_provider.dart';
import 'package:niu_guardian/features/census/presentation/widgets/parent_form_section.dart';

class CensusScreen extends ConsumerStatefulWidget {
  const CensusScreen({super.key});

  @override
  ConsumerState<CensusScreen> createState() => _CensusScreenState();
}

class _CensusScreenState extends ConsumerState<CensusScreen> {
  final _formKey = GlobalKey<FormBuilderState>();

  Future<void> _submitForm() async {
    if (_formKey.currentState?.saveAndValidate() ?? false) {
      final values = _formKey.currentState!.value;

      final parent = ParentEntity(
        name: values['name'],
        surname: values['surname'],
        email: values['email'],
        phone: values['phone'],
        birthdate: values['birthdate'],
        documentId: values['documentId'],
        civilStatus: values['civilStatus'] ?? 'otro',
        gender: values['gender'] ?? 'O',
        hasHealthInsurance: values['hasHealthInsurance'] ?? false,
        isEmployed: values['isEmployed'] ?? false,
        cityOfResidence: values['cityOfResidence'] ?? '',
        notes: values['notes'] ?? '',
      );

      final success = await ref.read(censusProvider.notifier).saveForm(parent);

      if (mounted) {
        if (success) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Formulario guardado exitosamente'),
              backgroundColor: Colors.green,
            ),
          );
          _formKey.currentState?.reset();
        } else {
          final error = ref.read(censusProvider).errorMessage;
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(error ?? 'Error al guardar'),
              backgroundColor: Colors.red,
            ),
          );
        }
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Por favor corrija los errores en el formulario'),
          backgroundColor: Colors.orange,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final censusState = ref.watch(censusProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('NIU Guardian - Censo'),
        centerTitle: true,
      ),
      body: censusState.isLoading
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              padding: const EdgeInsets.all(16.0),
              child: FormBuilder(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    const ParentFormSection(),
                    const SizedBox(height: 32),
                    ElevatedButton(
                      onPressed: _submitForm,
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        backgroundColor: Theme.of(context).colorScheme.primary,
                        foregroundColor: Colors.white,
                        textStyle: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      child: const Text('Guardar'),
                    ),
                    const SizedBox(height: 32),
                  ],
                ),
              ),
            ),
    );
  }
}
