import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:niu_guardian/features/census/domain/entities/parent_entity.dart';
import 'package:niu_guardian/features/census/presentation/providers/census_provider.dart';
import 'package:niu_guardian/core/utils/code_generator.dart';
import 'package:niu_guardian/features/census/domain/entities/child_entity.dart';
import 'package:niu_guardian/features/census/presentation/widgets/child_form_section.dart';
import 'package:niu_guardian/features/census/presentation/widgets/parent_form_section.dart';

class CensusScreen extends ConsumerStatefulWidget {
  final String? censusId;

  const CensusScreen({super.key, this.censusId});

  @override
  ConsumerState<CensusScreen> createState() => _CensusScreenState();
}

class _CensusScreenState extends ConsumerState<CensusScreen> {
  final _formKey = GlobalKey<FormBuilderState>();
  final List<int> _childIndexes = [];
  int _nextChildIndex = 0;
  bool _isLoading = false;
  int? _editingFormId;

  @override
  void initState() {
    super.initState();
    if (widget.censusId != null && widget.censusId != 'new') {
      _loadForm(int.parse(widget.censusId!));
    }
  }

  Future<void> _loadForm(int id) async {
    setState(() => _isLoading = true);
    final form = await ref.read(censusProvider.notifier).getFormById(id);
    if (form != null) {
      _editingFormId = form.id;
      WidgetsBinding.instance.addPostFrameCallback((_) {
        _formKey.currentState?.patchValue({
          'name': form.name,
          'surname': form.surname,
          'email': form.email,
          'phone': form.phone,
          'birthdate': form.birthdate,
          'documentId': form.documentId,
          'civilStatus': form.civilStatus,
          'gender': form.gender,
          'hasHealthInsurance': form.hasHealthInsurance,
          'isEmployed': form.isEmployed,
          'cityOfResidence': form.cityOfResidence,
          'notes': form.notes,
        });

        setState(() {
          _childIndexes.clear();
          for (int i = 0; i < form.children.length; i++) {
            _childIndexes.add(i);
            _nextChildIndex = i + 1;
          }
        });

        WidgetsBinding.instance.addPostFrameCallback((_) {
          final Map<String, dynamic> childrenValues = {};
          for (int i = 0; i < form.children.length; i++) {
            final child = form.children[i];
            childrenValues['child_${i}_name'] = child.name;
            childrenValues['child_${i}_surname'] = child.surname;
            childrenValues['child_${i}_birthdate'] = child.birthdate;
            childrenValues['child_${i}_age'] = child.age.toString();
            childrenValues['child_${i}_hairColor'] = child.hairColor;
          }
          _formKey.currentState?.patchValue(childrenValues);
        });
      });
    }
    setState(() => _isLoading = false);
  }

  void _addChild() {
    setState(() {
      _childIndexes.add(_nextChildIndex);
      _nextChildIndex++;
    });
  }

  void _removeChild(int index) {
    setState(() {
      _childIndexes.remove(index);
    });
    _formKey.currentState?.fields['child_${index}_name']?.didChange(null);
  }

  Future<void> _submitForm() async {
    if (_formKey.currentState?.saveAndValidate() ?? false) {
      final values = _formKey.currentState!.value;

      final List<ChildEntity> children = [];
      for (final index in _childIndexes) {
        final birthdate = values['child_${index}_birthdate'] as DateTime?;
        final ageString = values['child_${index}_age'] as String?;

        if (birthdate != null && ageString != null) {
          final age = int.tryParse(ageString) ?? 0;

          final now = DateTime.now();
          final calculatedAge = now.year -
              birthdate.year -
              ((now.month < birthdate.month ||
                      (now.month == birthdate.month && now.day < birthdate.day))
                  ? 1
                  : 0);

          if (calculatedAge != age) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(
                    'La edad del Hijo #${index + 1} no coincide con su fecha de nacimiento.'),
                backgroundColor: Colors.orange,
              ),
            );
            return;
          }

          final allForms = ref.read(censusProvider).forms;
          final otherForms = _editingFormId == null
              ? allForms
              : allForms.where((f) => f.id != _editingFormId).toList();

          final existingCodes = otherForms
              .expand((f) => f.children.map((c) => c.uniqueCode))
              .toList();

          try {
            //? Generar identificador único

            final uniqueCode = CodeGenerator.generate(
              parentName: values['name'],
              parentSurname: values['surname'],
              childName: values['child_${index}_name'],
              childSurname: values['child_${index}_surname'],
              childBirthdate: birthdate,
              existingCodes: existingCodes,
            );

            existingCodes.add(uniqueCode);

            children.add(ChildEntity(
              name: values['child_${index}_name'],
              surname: values['child_${index}_surname'],
              birthdate: birthdate,
              age: age,
              hairColor: values['child_${index}_hairColor'],
              uniqueCode: uniqueCode,
            ));
          } catch (e) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content:
                    Text('Error al generar código para hijo #${index + 1}: $e'),
                backgroundColor: Colors.red,
              ),
            );
            return;
          }
        }
      }

      final parent = ParentEntity(
        id: _editingFormId,
        name: values['name'],
        surname: values['surname'],
        email: values['email'],
        phone: values['phone'],
        birthdate: values['birthdate'],
        documentId: values['documentId'],
        civilStatus: values['civilStatus'] ?? 'otro',
        gender: values['gender'] ?? 'O',
        hasHealthInsurance: values['hasHealthInsurance'],
        isEmployed: values['isEmployed'],
        cityOfResidence: values['cityOfResidence'] ?? '',
        notes: values['notes'] ?? '',
        children: children,
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
          if (_editingFormId != null) {
            // Si es edición, volver atrás
            Navigator.of(context).pop();
          } else {
            // Si es nuevo, limpiar
            _formKey.currentState?.reset();
            setState(() {
              _childIndexes.clear();
              _nextChildIndex = 0;
            });
          }
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
    if (_isLoading) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    final censusState = ref.watch(censusProvider);
    final isEditing = _editingFormId != null;

    return Scaffold(
      appBar: AppBar(
        title: Text(isEditing ? 'Editar Censo' : 'Nuevo Censo'),
        centerTitle: true,
      ),
      body: censusState.isLoading && !isEditing
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
                    const Text(
                      'Hijos',
                      style:
                          TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 16),
                    ..._childIndexes.map((index) => ChildFormSection(
                          key: ValueKey(index),
                          index: index,
                          onRemove: () => _removeChild(index),
                        )),
                    OutlinedButton.icon(
                      onPressed: _addChild,
                      icon: const Icon(Icons.add),
                      label: const Text('Agregar Hijo'),
                      style: OutlinedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                    ),
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
                      child: Text(isEditing ? 'Actualizar' : 'Guardar'),
                    ),
                    const SizedBox(height: 32),
                  ],
                ),
              ),
            ),
    );
  }
}
