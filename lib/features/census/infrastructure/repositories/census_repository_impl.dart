import '../../domain/datasources/census_datasource.dart';
import '../../domain/entities/parent_entity.dart';
import '../../domain/repositories/census_repository.dart';

class CensusRepositoryImpl implements CensusRepository {
  final CensusDatasource datasource;

  CensusRepositoryImpl(this.datasource);

  @override
  Future<void> saveForm(ParentEntity parent) {
    return datasource.saveForm(parent);
  }

  @override
  Future<List<ParentEntity>> getAllForms() {
    return datasource.getAllForms();
  }

  @override
  Future<void> deleteForm(int id) {
    return datasource.deleteForm(id);
  }
}
