import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:niu_guardian/features/census/domain/entities/parent_entity.dart';
import 'package:niu_guardian/features/census/presentation/providers/census_provider.dart';
import 'package:niu_guardian/core/utils/code_generator.dart';
import 'package:niu_guardian/features/census/domain/entities/child_entity.dart';
import 'package:niu_guardian/features/census/presentation/widgets/child_form_section.dart';
import 'package:niu_guardian/features/census/presentation/widgets/parent_form_section.dart';
import 'package:niu_guardian/core/utils/ui_feedback.dart';
import 'package:niu_guardian/shared/widgets/keep_alive_wrapper.dart';

class CensusScreen extends ConsumerStatefulWidget {
  final String? censusId;

  const CensusScreen({super.key, this.censusId});

  @override
  ConsumerState<CensusScreen> createState() => _CensusScreenState();
}

class _CensusScreenState extends ConsumerState<CensusScreen> {
  final _formKey = GlobalKey<FormBuilderState>();
  final List<int> _childIndexes = [];
  final Map<int, String> _childUniqueCodes = {};
  final Map<int, Map<String, dynamic>> _loadedChildrenValues = {};
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
          _childUniqueCodes.clear();
          _loadedChildrenValues.clear();
          for (int i = 0; i < form.children.length; i++) {
            _childIndexes.add(i);
            _childUniqueCodes[i] = form.children[i].uniqueCode;

            final child = form.children[i];
            _loadedChildrenValues[i] = {
              'child_${i}_name': child.name,
              'child_${i}_surname': child.surname,
              'child_${i}_birthdate': child.birthdate,
              'child_${i}_age': child.age.toString(),
              'child_${i}_hairColor': child.hairColor,
            };

            _nextChildIndex = i + 1;
          }
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

  void _removeChild(int index) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Eliminar Hijo'),
        content: const Text(
            '¿Estás seguro de que deseas eliminar este registro de hijo?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: const Text('CANCELAR'),
          ),
          TextButton(
            onPressed: () => Navigator.of(context).pop(true),
            child: const Text('ELIMINAR', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );

    if (confirmed == true) {
      setState(() {
        _childIndexes.remove(index);
        _childUniqueCodes.remove(index);
        _formHasChanges = true;
      });
      _formKey.currentState?.fields['child_${index}_name']?.didChange(null);
    }
  }

  Future<void> _submitForm() async {
    if (_formKey.currentState?.saveAndValidate() ?? false) {
      final values = _formKey.currentState!.value;

      final List<ChildEntity> children = [];
      final allForms = ref.read(censusProvider).forms;
      final otherForms = _editingFormId == null
          ? allForms
          : allForms.where((f) => f.id != _editingFormId).toList();

      final existingCodes = otherForms
          .expand((f) => f.children.map((c) => c.uniqueCode))
          .toList();

      final dpi = values['documentId'] as String;
      final duplicateDpi = otherForms.any((f) => f.documentId == dpi);
      if (duplicateDpi) {
        final existingParent =
            otherForms.firstWhere((f) => f.documentId == dpi);
        FeedbackUtils.showError(context,
            'El DPI $dpi ya está registrado a nombre de ${existingParent.name} ${existingParent.surname}');
        return;
      }

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
            FeedbackUtils.showInfo(context,
                'La edad del Hijo #${index + 1} no coincide con su fecha de nacimiento.');
            return;
          }

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
            FeedbackUtils.showError(
                context, 'Error al generar código para hijo #${index + 1}: $e');
            return;
          }
        }
      }

      final generatedCodes = children.map((c) => c.uniqueCode).toList();
      if (generatedCodes.toSet().length != generatedCodes.length) {
        final codeCounts = <String, int>{};
        String? duplicate;
        for (final code in generatedCodes) {
          codeCounts[code] = (codeCounts[code] ?? 0) + 1;
          if (codeCounts[code]! > 1) {
            duplicate = code;
            break;
          }
        }

        FeedbackUtils.showError(context,
            'Error: Se generaron códigos duplicados ($duplicate). Intente guardar nuevamente.');
        return;
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
          FeedbackUtils.showSuccess(
              context, 'Formulario guardado exitosamente');
          if (_editingFormId != null) {
            // Si es edición, volver atrás
            Navigator.of(context).pop();
          } else {
            // Si es nuevo, limpiar
            _formKey.currentState?.reset();
            setState(() {
              _childIndexes.clear();
              _childUniqueCodes.clear();
              _nextChildIndex = 0;
            });
          }
        } else {
          final error = ref.read(censusProvider).errorMessage;
          FeedbackUtils.showError(context, error ?? 'Error al guardar');
        }
      }
    } else {
      final parentFields = [
        'name',
        'surname',
        'email',
        'phone',
        'birthdate',
        'documentId',
        'gender',
        'civilStatus',
        'cityOfResidence'
      ];
      final hasParentError = parentFields.any(
          (field) => _formKey.currentState?.fields[field]?.hasError ?? false);

      if (hasParentError) {
        FeedbackUtils.showInfo(context,
            'Por favor complete los datos del Responsable para continuar.');
      } else {
        FeedbackUtils.showInfo(
            context, 'Por favor corrija los errores en el formulario');
      }
    }
  }

  bool _formHasChanges = false;

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    final censusState = ref.watch(censusProvider);
    final isEditing = _editingFormId != null;

    return PopScope(
      canPop: false,
      onPopInvoked: (didPop) async {
        if (didPop) return;

        if (!_formHasChanges) {
          Navigator.of(context).pop();
          return;
        }

        final shouldPop = await showDialog<bool>(
          context: context,
          builder: (context) => AlertDialog(
            title: const Text('¿Salir sin guardar?'),
            content: const Text(
                'Tienes cambios pendientes. Si sales ahora, se perderán.'),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(context).pop(false),
                child: const Text('CANCELAR'),
              ),
              TextButton(
                onPressed: () => Navigator.of(context).pop(true),
                child: const Text('SALIR'),
              ),
            ],
          ),
        );

        if (shouldPop == true && context.mounted) {
          Navigator.of(context).pop();
        }
      },
      child: DefaultTabController(
        length: 2,
        child: Scaffold(
          appBar: AppBar(
            title: Text(isEditing ? 'Editar Censo' : 'Nuevo Censo'),
            centerTitle: true,
            bottom: const TabBar(
              tabs: [
                Tab(text: 'Datos Responsable', icon: Icon(Icons.person)),
                Tab(text: 'Grupo Familiar', icon: Icon(Icons.people)),
              ],
            ),
          ),
          body: censusState.isLoading && !isEditing
              ? const Center(child: CircularProgressIndicator())
              : FormBuilder(
                  key: _formKey,
                  onChanged: () {
                    _formHasChanges = true;
                  },
                  child: TabBarView(
                    children: [
                      // Tab 1: Responsable
                      const KeepAliveWrapper(
                        child: SingleChildScrollView(
                          padding: EdgeInsets.all(16.0),
                          child: Column(
                            children: [
                              ParentFormSection(),
                              SizedBox(height: 80),
                            ],
                          ),
                        ),
                      ),
                      // Tab 2: Hijos
                      KeepAliveWrapper(
                        child: Stack(
                          children: [
                            _childIndexes.isEmpty
                                ? Center(
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Icon(Icons.child_care,
                                            size: 64, color: Colors.grey[300]),
                                        const SizedBox(height: 16),
                                        Text(
                                          'No hay hijos registrados',
                                          style: TextStyle(
                                              color: Colors.grey[600]),
                                        ),
                                        const SizedBox(height: 8),
                                        const Text(
                                            'Use el botón + para agregar'),
                                      ],
                                    ),
                                  )
                                : ListView(
                                    padding: const EdgeInsets.all(16),
                                    children: [
                                      ..._childIndexes.map(
                                        (index) {
                                          // Usar valores cargados explícitamente desde la base de datos
                                          // si el índice existe en _loadedChildrenValues
                                          final childInitials =
                                              _loadedChildrenValues[index];

                                          return ChildFormSection(
                                            key: ValueKey(index),
                                            index: index,
                                            uniqueCode:
                                                _childUniqueCodes[index],
                                            initialValues: childInitials,
                                            onRemove: () => _removeChild(index),
                                          );
                                        },
                                      ),
                                      const SizedBox(height: 80),
                                    ],
                                  ),
                            Positioned(
                              bottom: 16,
                              right: 16,
                              child: FloatingActionButton(
                                onPressed: _addChild,
                                child: const Icon(Icons.add),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
          bottomNavigationBar: Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white,
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.05),
                  blurRadius: 10,
                  offset: const Offset(0, -4),
                ),
              ],
            ),
            child: SafeArea(
              child: ElevatedButton(
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
                child: Text(isEditing ? 'Actualizar Censo' : 'Guardar Censo'),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
