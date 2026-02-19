import '../../domain/entities/parent_entity.dart';

class CensusState {
  final bool isLoading;
  final List<ParentEntity> forms;
  final String? errorMessage;

  const CensusState({
    this.isLoading = false,
    this.forms = const [],
    this.errorMessage,
  });

  CensusState copyWith({
    bool? isLoading,
    List<ParentEntity>? forms,
    String? errorMessage,
  }) {
    return CensusState(
      isLoading: isLoading ?? this.isLoading,
      forms: forms ?? this.forms,
      errorMessage: errorMessage,
    );
  }
}
