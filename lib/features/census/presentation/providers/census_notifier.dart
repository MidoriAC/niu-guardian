import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../domain/entities/parent_entity.dart';
import '../../domain/repositories/census_repository.dart';
import 'census_state.dart';

class CensusNotifier extends StateNotifier<CensusState> {
  final CensusRepository repository;

  CensusNotifier(this.repository) : super(const CensusState()) {
    loadForms();
  }

  Future<void> loadForms() async {
    state = state.copyWith(isLoading: true, errorMessage: null);
    try {
      final forms = await repository.getAllForms();
      state = state.copyWith(isLoading: false, forms: forms);
    } catch (e) {
      state =
          state.copyWith(isLoading: false, errorMessage: "Error al cargar: $e");
    }
  }

  Future<bool> saveForm(ParentEntity parent) async {
    state = state.copyWith(isLoading: true, errorMessage: null);
    try {
      await repository.saveForm(parent);
      await loadForms();
      return true;
    } catch (e) {
      state = state.copyWith(
          isLoading: false, errorMessage: "Error al guardar: $e");
      return false;
    }
  }

  Future<void> deleteForm(int id) async {
    try {
      await repository.deleteForm(id);
      final updatedForms = state.forms.where((f) => f.id != id).toList();
      state = state.copyWith(forms: updatedForms);
    } catch (e) {
      state = state.copyWith(errorMessage: "No se pudo eliminar: $e");
    }
  }
}
